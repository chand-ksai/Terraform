output "root-mod-op" {
  description = "ID of the VPC"
  value       = module.vpc.child-mod-op-child-mod-vpc-op
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids-child-mod-vpc-op
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids-child-mod-vpc-op
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id-child-mod-vpc-op
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = module.vpc.nat_gateway_id-child-mod-vpc-op
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = module.vpc.public_route_table_id-child-mod-vpc-op
}

output "default_route_table_id" {
  description = "ID of the default route table (used by private subnets)"
  value       = module.vpc.default_route_table_id-child-mod-vpc-op
}

############################################
# EC2 outputs
############################################
output "public_ec2_instance_id" {
  description = "ID of the EC2 instance deployed in the public subnet"
  value       = module.ec2.public_instance_id-child-mod-ec2-op
}

output "public_ec2_public_ip" {
  description = "Public IP address of the public-subnet EC2 instance"
  value       = module.ec2.public_instance_public_ip-child-mod-ec2-op
}

output "private_ec2_instance_id" {
  description = "ID of the EC2 instance deployed in the private subnet"
  value       = module.ec2.private_instance_id-child-mod-ec2-op
}

output "private_ec2_private_ip" {
  description = "Private IP address of the private-subnet EC2 instance"
  value       = module.ec2.private_instance_private_ip-child-mod-ec2-op
}

output "ec2_security_group_id" {
  description = "ID of the security group attached to both EC2 instances"
  value       = module.ec2.ec2_security_group_id-child-mod-ec2-op
}

############################################
# VPC Endpoint outputs
############################################
output "ssm_vpc_endpoint_id" {
  description = "ID of the SSM interface VPC endpoint"
  value       = module.vpc_endpoints.ssm_endpoint_id-child-mod-vpc_endpoints-op
}

output "ssmmessages_vpc_endpoint_id" {
  description = "ID of the SSM Messages interface VPC endpoint"
  value       = module.vpc_endpoints.ssmmessages_endpoint_id-child-mod-vpc_endpoints-op
}

output "ec2messages_vpc_endpoint_id" {
  description = "ID of the EC2 Messages interface VPC endpoint"
  value       = module.vpc_endpoints.ec2messages_endpoint_id-child-mod-vpc_endpoints-op
}

output "ecr_api_vpc_endpoint_id" {
  description = "ID of the ECR API interface VPC endpoint"
  value       = module.vpc_endpoints.ecr_api_endpoint_id-child-mod-vpc_endpoints-op
}

output "ecr_dkr_vpc_endpoint_id" {
  description = "ID of the ECR Docker Registry interface VPC endpoint"
  value       = module.vpc_endpoints.ecr_dkr_endpoint_id-child-mod-vpc_endpoints-op
}

output "s3_vpc_endpoint_id" {
  description = "ID of the S3 gateway VPC endpoint (used for ECR image layer pulls)"
  value       = module.vpc_endpoints.s3_endpoint_id-child-mod-vpc_endpoints-op
}

############################################
# ECR outputs
############################################
output "ecr_repository_url" {
  description = "URL of the ECR repository (used for docker push/pull)"
  value       = module.ecr.repository_url-child-mod-ecr-op
}

output "ecr_repository_arn" {
  description = "ARN of the ECR repository"
  value       = module.ecr.repository_arn-child-mod-ecr-op
}
