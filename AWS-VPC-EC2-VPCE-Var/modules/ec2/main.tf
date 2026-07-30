############################################
# Latest Amazon Linux 2023 AMI (comes with
# the SSM Agent preinstalled). Used unless an
# explicit ami_id-ec2-mod is supplied.
############################################
data "aws_ami" "amazon_linux_2023" {
  count       = var.ami_id-ec2-mod == null ? 1 : 0
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  ami_id-ec2-mod = coalesce(var.ami_id-ec2-mod, try(data.aws_ami.amazon_linux_2023[0].id, null))

  # Installs git and docker, enables and starts the docker service,
  # and adds ec2-user to the docker group. The SSM Agent is already
  # preinstalled and running on Amazon Linux 2023.
  user_data-ec2-mod = <<-EOF
    #!/bin/bash
    set -e
    dnf update -y
    dnf install -y git docker
    systemctl enable docker
    systemctl start docker
    usermod -aG docker ec2-user
  EOF
}

############################################
# IAM Role + Instance Profile for SSM
############################################
resource "aws_iam_role" "ssm_role" {
  name = "${var.name_prefix-ec2-mod}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    var.tags-ec2-mod,
    { Name = "${var.name_prefix-ec2-mod}-ec2-ssm-role" }
  )
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "${var.name_prefix-ec2-mod}-ec2-ssm-profile"
  role = aws_iam_role.ssm_role.name
}

############################################
# Security Group for the EC2 instances
# No inbound rules needed - access is via
# SSM Session Manager, not SSH.
############################################
resource "aws_security_group" "ec2" {
  name        = "${var.name_prefix-ec2-mod}-ec2-sg"
  description = "Security group for EC2 instances (SSM managed, no inbound access)"
  vpc_id      = var.vpc_id-ec2-mod

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags-ec2-mod,
    { Name = "${var.name_prefix-ec2-mod}-ec2-sg" }
  )
}

############################################
# EC2 instance in the PUBLIC subnet
############################################
resource "aws_instance" "public" {
  ami                         = local.ami_id-ec2-mod
  instance_type               = var.instance_type-ec2-mod
  subnet_id                   = var.public_subnet_id-ec2-mod
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  iam_instance_profile        = aws_iam_instance_profile.ssm_profile.name
  associate_public_ip_on_launch = true
  user_data                   = local.user_data-ec2-mod

  tags = merge(
    var.tags-ec2-mod,
    { Name = "${var.name_prefix-ec2-mod}-ec2-public" }
  )
}

############################################
# EC2 instance in the PRIVATE subnet
############################################
resource "aws_instance" "private" {
  ami                     = local.ami_id-ec2-mod
  instance_type           = var.instance_type-ec2-mod
  subnet_id               = var.private_subnet_id-ec2-mod
  vpc_security_group_ids  = [aws_security_group.ec2.id]
  iam_instance_profile    = aws_iam_instance_profile.ssm_profile.name
  user_data               = local.user_data-ec2-mod

  tags = merge(
    var.tags-ec2-mod,
    { Name = "${var.name_prefix-ec2-mod}-ec2-private" }
  )
}
