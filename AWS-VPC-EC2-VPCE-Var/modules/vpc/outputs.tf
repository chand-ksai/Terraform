output "child-mod-op-child-mod-vpc-op" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr_block-child-mod-vpc-op" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids-child-mod-vpc-op" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids-child-mod-vpc-op" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id-child-mod-vpc-op" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
}

output "nat_gateway_id-child-mod-vpc-op" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.this.id
}

output "nat_gateway_eip-child-mod-vpc-op" {
  description = "Public Elastic IP address of the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

output "public_route_table_id-child-mod-vpc-op" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "default_route_table_id-child-mod-vpc-op" {
  description = "ID of the default (main) route table used by private subnets"
  value       = aws_default_route_table.default.id
}
