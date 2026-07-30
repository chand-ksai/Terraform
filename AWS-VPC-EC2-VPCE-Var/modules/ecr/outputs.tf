output "repository_url-child-mod-ecr-op" {
  description = "URL of the ECR repository (used for docker push/pull)"
  value       = aws_ecr_repository.this.repository_url
}

output "repository_arn-child-mod-ecr-op" {
  description = "ARN of the ECR repository"
  value       = aws_ecr_repository.this.arn
}

output "repository_name-child-mod-ecr-op" {
  description = "Name of the ECR repository"
  value       = aws_ecr_repository.this.name
}

output "registry_id-child-mod-ecr-op" {
  description = "Registry ID (AWS account ID) that owns the repository"
  value       = aws_ecr_repository.this.registry_id
}
