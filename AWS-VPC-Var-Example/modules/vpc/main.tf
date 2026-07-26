############################################
# VPC
############################################
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr-child-mod
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.tags-child-mod,
    { Name = "${var.name_prefix-child-mod}-vpc" }
  )
}

############################################
# Internet Gateway (for public subnets)
############################################
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags-child-mod,
    { Name = "${var.name_prefix-child-mod}-igw" }
  )
}

############################################
# Public Subnets
############################################
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs-child-mod)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs-child-mod[count.index]
  availability_zone       = var.azs-child-mod[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags-child-mod,
    { Name = "${var.name_prefix-child-mod}-public-subnet-${count.index + 1}" }
  )
}

############################################
# Private Subnets
############################################
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs-child-mod)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs-child-mod[count.index]
  availability_zone = var.azs-child-mod[count.index]

  tags = merge(
    var.tags-child-mod,
    { Name = "${var.name_prefix-child-mod}-private-subnet-${count.index + 1}" }
  )
}

############################################
# Elastic IP for NAT Gateway
############################################
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(
    var.tags-child-mod,
    { Name = "${var.name_prefix-child-mod}-nat-eip" }
  )

  depends_on = [aws_internet_gateway.this]
}

############################################
# NAT Gateway - placed in the first public subnet
############################################
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.tags-child-mod,
    { Name = "${var.name_prefix-child-mod}-nat-gw" }
  )

  depends_on = [aws_internet_gateway.this]
}

############################################
# Public Route Table (new, explicit) -> IGW
############################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(
    var.tags-child-mod,
    { Name = "${var.name_prefix-child-mod}-public-rt" }
  )
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

############################################
# Default (Main) Route Table -> used by private subnets
# Managed via aws_default_route_table so we control the
# VPC's automatically-created main route table instead of
# creating a brand new one, and add the NAT gateway route
# to it for private subnet internet access.
############################################
resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = merge(
    var.tags-child-mod,
    { Name = "${var.name_prefix-child-mod}-default-rt-private" }
  )
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_default_route_table.default.id
}
