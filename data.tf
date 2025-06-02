# Get the default route table for the VPC
data "aws_route_tables" "default" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "association.main"
    values = ["true"]
  }
}

# Add a route to the NAT Gateway in the default route table
resource "aws_route" "nat_gateway_route" {
  route_table_id         = data.aws_route_tables.default.ids[0]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.example.id
}


*********************

data "aws_vpc" "selected" {
  id = var.vpc_id
}

output "vpc_details" {
  value = data.aws_vpc.selected
}


 Tip: Use terraform console for Exploration
You can also explore resource attributes interactively:

terraform console
> data.aws_vpc.selected
> data.aws_vpc.selected.cidr_block
