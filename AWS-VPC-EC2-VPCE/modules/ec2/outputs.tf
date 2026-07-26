output "public_instance_id" {
  description = "ID of the public EC2 instance"
  value       = aws_instance.public.id
}

output "public_instance_private_ip" {
  description = "Private IP of the public EC2 instance"
  value       = aws_instance.public.private_ip
}

output "public_instance_public_ip" {
  description = "Public IP of the public EC2 instance"
  value       = aws_instance.public.public_ip
}

output "private_instance_id" {
  description = "ID of the private EC2 instance"
  value       = aws_instance.private.id
}

output "private_instance_private_ip" {
  description = "Private IP of the private EC2 instance"
  value       = aws_instance.private.private_ip
}

output "ec2_security_group_id" {
  description = "ID of the shared security group attached to both instances"
  value       = aws_security_group.ec2.id
}

output "ec2_iam_role_name" {
  description = "Name of the IAM role attached to both instances (has AmazonSSMManagedInstanceCore)"
  value       = aws_iam_role.ec2_ssm.name
}

output "ami_id_used" {
  description = "AMI ID actually used for the instances"
  value       = local.ami_id
}
