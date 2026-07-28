output "public_instance_id-child-mod-ec2-op" {
  description = "ID of the EC2 instance deployed in the public subnet"
  value       = aws_instance.public.id
}

output "public_instance_private_ip-child-mod-ec2-op" {
  description = "Private IP address of the public-subnet EC2 instance"
  value       = aws_instance.public.private_ip
}

output "public_instance_public_ip-child-mod-ec2-op" {
  description = "Public IP address of the public-subnet EC2 instance"
  value       = aws_instance.public.public_ip
}

output "private_instance_id-child-mod-ec2-op" {
  description = "ID of the EC2 instance deployed in the private subnet"
  value       = aws_instance.private.id
}

output "private_instance_private_ip-child-mod-ec2-op" {
  description = "Private IP address of the private-subnet EC2 instance"
  value       = aws_instance.private.private_ip
}

output "ec2_security_group_id-child-mod-ec2-op" {
  description = "ID of the security group attached to both EC2 instances"
  value       = aws_security_group.ec2.id
}

output "ec2_iam_role_arn-child-mod-ec2-op" {
  description = "ARN of the IAM role (with SSM managed policy) attached to both instances"
  value       = aws_iam_role.ssm_role.arn
}

output "ec2_iam_role_name-child-mod-ec2-op" {
  description = "Name of the IAM role attached to both instances"
  value       = aws_iam_role.ssm_role.name
}
