data "aws_region" "current" {}

############################################
# Security Group for the Interface Endpoints
# Allows HTTPS (443) from inside the VPC only.
############################################
resource "aws_security_group" "endpoints" {
  name        = "${var.name_prefix-vpce-mod}-vpce-sg"
  description = "Allow HTTPS from within the VPC to SSM interface endpoints"
  vpc_id      = var.vpc_id-vpce-mod

  ingress {
    description = "HTTPS from the VPC CIDR"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr-vpce-mod]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags-vpce-mod,
    { Name = "${var.name_prefix-vpce-mod}-vpce-sg" }
  )
}

############################################
# Interface Endpoints required for SSM
# (Session Manager / SSM Agent) to work from
# private subnets without internet access:
#   - ssm           : core SSM service
#   - ssmmessages   : Session Manager channel
#   - ec2messages   : Agent <-> service messaging
############################################
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = var.vpc_id-vpce-mod
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids-vpce-mod
  security_group_ids  = [aws_security_group.endpoints.id]
  private_dns_enabled = true

  tags = merge(
    var.tags-vpce-mod,
    { Name = "${var.name_prefix-vpce-mod}-vpce-ssm" }
  )
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = var.vpc_id-vpce-mod
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids-vpce-mod
  security_group_ids  = [aws_security_group.endpoints.id]
  private_dns_enabled = true

  tags = merge(
    var.tags-vpce-mod,
    { Name = "${var.name_prefix-vpce-mod}-vpce-ssmmessages" }
  )
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = var.vpc_id-vpce-mod
  service_name        = "com.amazonaws.${data.aws_region.current.name}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids-vpce-mod
  security_group_ids  = [aws_security_group.endpoints.id]
  private_dns_enabled = true

  tags = merge(
    var.tags-vpce-mod,
    { Name = "${var.name_prefix-vpce-mod}-vpce-ec2messages" }
  )
}
