############################################
# Security Group for Interface Endpoints
# Allows HTTPS (443) from inside the VPC only
############################################
resource "aws_security_group" "endpoints" {
  name        = "${var.name_prefix}-vpce-sg"
  description = "Allow HTTPS from within the VPC to SSM interface endpoints"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from VPC CIDR"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    { Name = "${var.name_prefix}-vpce-sg" }
  )
}

############################################
# Interface Endpoints required for SSM
# (Session Manager / Run Command) to reach
# private instances without needing NAT/IGW
############################################
locals {
  ssm_interface_services = {
    ssm         = "com.amazonaws.${var.aws_region}.ssm"
    ssmmessages = "com.amazonaws.${var.aws_region}.ssmmessages"
    ec2messages = "com.amazonaws.${var.aws_region}.ec2messages"
  }
}

resource "aws_vpc_endpoint" "ssm" {
  for_each = local.ssm_interface_services

  vpc_id              = var.vpc_id
  service_name        = each.value
  vpc_endpoint_type    = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = [aws_security_group.endpoints.id]
  private_dns_enabled = true

  tags = merge(
    var.tags,
    { Name = "${var.name_prefix}-vpce-${each.key}" }
  )
}

############################################
# Optional: S3 Gateway Endpoint
# Free, no ENIs, attaches to route tables.
# Handy since SSM agent/docker/git may pull
# artifacts that live behind S3.
############################################
resource "aws_vpc_endpoint" "s3" {
  count = var.create_s3_gateway_endpoint ? 1 : 0

  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.private_route_table_ids

  tags = merge(
    var.tags,
    { Name = "${var.name_prefix}-vpce-s3" }
  )
}
