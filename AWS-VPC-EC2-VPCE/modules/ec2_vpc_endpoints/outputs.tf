output "endpoint_security_group_id" {
  description = "ID of the security group attached to the SSM interface endpoints"
  value       = aws_security_group.endpoints.id
}

output "ssm_endpoint_ids" {
  description = "Map of SSM-related interface endpoint IDs keyed by service (ssm, ssmmessages, ec2messages)"
  value       = { for k, v in aws_vpc_endpoint.ssm : k => v.id }
}

output "s3_gateway_endpoint_id" {
  description = "ID of the S3 gateway endpoint (null if not created)"
  value       = try(aws_vpc_endpoint.s3[0].id, null)
}
