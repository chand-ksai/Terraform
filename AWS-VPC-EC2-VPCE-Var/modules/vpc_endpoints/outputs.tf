output "ssm_endpoint_id-child-mod-vpc_endpoints-op" {
  description = "ID of the SSM interface VPC endpoint"
  value       = aws_vpc_endpoint.ssm.id
}

output "ssmmessages_endpoint_id-child-mod-vpc_endpoints-op" {
  description = "ID of the SSM Messages interface VPC endpoint"
  value       = aws_vpc_endpoint.ssmmessages.id
}

output "ec2messages_endpoint_id-child-mod-vpc_endpoints-op" {
  description = "ID of the EC2 Messages interface VPC endpoint"
  value       = aws_vpc_endpoint.ec2messages.id
}

output "endpoint_security_group_id-child-mod-vpc_endpoints-op" {
  description = "ID of the security group attached to the interface endpoints"
  value       = aws_security_group.endpoints.id
}

output "ecr_api_endpoint_id-child-mod-vpc_endpoints-op" {
  description = "ID of the ECR API interface VPC endpoint (null if enable_ecr_endpoints-vpce-mod is false)"
  value       = try(aws_vpc_endpoint.ecr_api[0].id, null)
}

output "ecr_dkr_endpoint_id-child-mod-vpc_endpoints-op" {
  description = "ID of the ECR Docker Registry interface VPC endpoint (null if enable_ecr_endpoints-vpce-mod is false)"
  value       = try(aws_vpc_endpoint.ecr_dkr[0].id, null)
}

output "s3_endpoint_id-child-mod-vpc_endpoints-op" {
  description = "ID of the S3 gateway VPC endpoint (null if enable_ecr_endpoints-vpce-mod is false)"
  value       = try(aws_vpc_endpoint.s3[0].id, null)
}
