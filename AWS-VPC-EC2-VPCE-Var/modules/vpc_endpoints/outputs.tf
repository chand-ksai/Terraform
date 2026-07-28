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
