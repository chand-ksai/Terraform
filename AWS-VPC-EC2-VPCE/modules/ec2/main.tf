############################################
# Latest Amazon Linux 2023 AMI (used unless
# var.ami_id is explicitly supplied)
############################################
data "aws_ami" "al2023" {
  count       = var.ami_id == null ? 1 : 0
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
  ami_id = coalesce(var.ami_id, try(data.aws_ami.al2023[0].id, null))
}

############################################
# IAM Role + Instance Profile for SSM
############################################
resource "aws_iam_role" "ec2_ssm" {
  name = "${var.name_prefix}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = merge(
    var.tags,
    { Name = "${var.name_prefix}-ec2-ssm-role" }
  )
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm" {
  name = "${var.name_prefix}-ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm.name
}

############################################
# Security Group
# No inbound rules - management is via SSM
# Session Manager, not SSH. All outbound
# traffic allowed (HTTPS to SSM endpoints /
# internet for docker & git).
############################################
resource "aws_security_group" "ec2" {
  name        = "${var.name_prefix}-ec2-sg"
  description = "Security group for SSM-managed EC2 instances (no inbound; SSM only)"
  vpc_id      = var.vpc_id

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    { Name = "${var.name_prefix}-ec2-sg" }
  )
}

############################################
# Public EC2 Instance
############################################
resource "aws_instance" "public" {
  ami                         = local.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_ssm.name
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip_on_public_instance

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
    encrypted   = true
  }

  metadata_options {
    http_tokens   = "required" # enforce IMDSv2
    http_endpoint = "enabled"
  }

  user_data = base64encode(templatefile("${path.module}/templates/user_data.sh.tpl", {
    instance_role = "public"
  }))

  tags = merge(
    var.tags,
    { Name = "${var.name_prefix}-ec2-public" }
  )
}

############################################
# Private EC2 Instance
############################################
resource "aws_instance" "private" {
  ami                     = local.ami_id
  instance_type           = var.instance_type
  subnet_id               = var.private_subnet_id
  vpc_security_group_ids  = [aws_security_group.ec2.id]
  iam_instance_profile    = aws_iam_instance_profile.ec2_ssm.name
  key_name                = var.key_name

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
    encrypted   = true
  }

  metadata_options {
    http_tokens   = "required" # enforce IMDSv2
    http_endpoint = "enabled"
  }

  user_data = base64encode(templatefile("${path.module}/templates/user_data.sh.tpl", {
    instance_role = "private"
  }))

  tags = merge(
    var.tags,
    { Name = "${var.name_prefix}-ec2-private" }
  )
}
