output "repository_urls-child-mod-ecr-op" {
  description = "Map of repository name (app/reports/db) to repository URL (used for docker push/pull)"
  value       = { for name, repo in aws_ecr_repository.this : name => repo.repository_url }
}

output "repository_arns-child-mod-ecr-op" {
  description = "Map of repository name to repository ARN"
  value       = { for name, repo in aws_ecr_repository.this : name => repo.arn }
}

output "repository_names-child-mod-ecr-op" {
  description = "List of full repository names (name_prefix-<name>) created"
  value       = [for repo in aws_ecr_repository.this : repo.name]
}

output "registry_id-child-mod-ecr-op" {
  description = "Registry ID (AWS account ID) that owns the repositories"
  value       = try(values(aws_ecr_repository.this)[0].registry_id, null)
}

output "ecs_cluster_role_arn-child-mod-ecr-op" {
  description = "ARN of the IAM role used by EC2 container instances joining the ECS cluster (null if create_ecs_cluster_role-ecr-mod is false)"
  value       = try(aws_iam_role.ecs_cluster[0].arn, null)
}

output "ecs_cluster_role_name-child-mod-ecr-op" {
  description = "Name of the IAM role used by EC2 container instances joining the ECS cluster (null if create_ecs_cluster_role-ecr-mod is false)"
  value       = try(aws_iam_role.ecs_cluster[0].name, null)
}

output "ecs_cluster_instance_profile_name-child-mod-ecr-op" {
  description = "Name of the instance profile for the ECS cluster role (null if create_ecs_cluster_role-ecr-mod is false)"
  value       = try(aws_iam_instance_profile.ecs_cluster[0].name, null)
}
