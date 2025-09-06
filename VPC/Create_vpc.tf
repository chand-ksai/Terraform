provider "aws" {
  profile = "ACG"
}

# Create a VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"
}

# Create subnets (2 public, 2 Private)

locals {
  subnets = {
    subnet1 = { cidr = "10.0.1.0/24", name = "Public-1" }
    subnet2 = { cidr = "10.0.2.0/24", name = "Public-2" }
    subnet3 = { cidr = "10.0.3.0/24", name = "Private-1" }
    subnet4 = { cidr = "10.0.4.0/24", name = "Private-2" }
  }
}


resource "aws_subnet" "main" {
  for_each = local.subnets

  vpc_id     = module.vpc.vpc_id
  cidr_block = each.value.cidr

  tags = {
    Name = each.value.name
  }
}

resource "aws_route_table" "Pub_RT" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "Pub_RT"
  }
}

#Associating public subnets to public route table

resource "aws_route_table_association" "public" {
  for_each = {
    for key, subnet in aws_subnet.main : key => subnet
    if subnet.tags["Name"] == "Public-1" || subnet.tags["Name"] == "Public-2"
  }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.Pub_RT.id
}

#Creating Internet gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "acg_vpc_igw"
  }
}

#Associating  Internet gateway to public subnets

resource "aws_route" "igw_association" {
  route_table_id         = aws_route_table.Pub_RT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


resource "aws_eip" "elastic_ip" {
 
}

#Creating NAT Gateway

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.main["subnet1"].id

  tags = {
    Name = "gw NAT"
  }
}


# Get the default route table details form the VPC

data "aws_route_tables" "default_rt" {
  depends_on = [module.vpc]

  filter {
    name   = "vpc-id"
    values = [module.vpc.vpc_id]
  }

  filter {
    name   = "association.main"
    values = ["true"]
  }
}

#Printing default route table details

output "rt_details" {
  value = data.aws_route_tables.default_rt.ids[0]
}

# Add a route to the NAT Gateway in the default route table

resource "aws_route" "nat_gateway_route" {
  route_table_id         = data.aws_route_tables.default_rt.ids[0]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}
