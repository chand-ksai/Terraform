output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = module.vpc.nat_gateway_id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = module.vpc.public_route_table_id
}

output "default_route_table_id" {
  description = "ID of the default route table (used by private subnets)"
  value       = module.vpc.default_route_table_id
}

############################################
# EC2 Outputs
############################################
output "public_instance_id" {
  description = "ID of the public EC2 instance"
  value       = module.ec2.public_instance_id
}

output "public_instance_public_ip" {
  description = "Public IP of the public EC2 instance"
  value       = module.ec2.public_instance_public_ip
}

output "private_instance_id" {
  description = "ID of the private EC2 instance"
  value       = module.ec2.private_instance_id
}

output "private_instance_private_ip" {
  description = "Private IP of the private EC2 instance"
  value       = module.ec2.private_instance_private_ip
}

output "ec2_iam_role_name" {
  description = "IAM role name attached to the instances (has AmazonSSMManagedInstanceCore)"
  value       = module.ec2.ec2_iam_role_name
}

############################################
# VPC Endpoint Outputs
############################################
output "ssm_vpc_endpoint_ids" {
  description = "Map of SSM interface VPC endpoint IDs"
  value       = module.ec2_vpc_endpoints.ssm_endpoint_ids
}

output "s3_gateway_endpoint_id" {
  description = "ID of the S3 gateway VPC endpoint"
  value       = module.ec2_vpc_endpoints.s3_gateway_endpoint_id
}
