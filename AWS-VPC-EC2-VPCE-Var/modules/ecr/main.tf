############################################
# ECR Repositories
# One repository per entry in
# repository_names-ecr-mod (default:
# app, reports, db)
############################################
resource "aws_ecr_repository" "this" {
  for_each = toset(var.repository_names-ecr-mod)

  name                 = "${var.name_prefix-ecr-mod}-${each.value}"
  image_tag_mutability = var.image_tag_mutability-ecr-mod
  force_delete         = var.force_delete-ecr-mod

  image_scanning_configuration {
    scan_on_push = var.scan_on_push-ecr-mod
  }

  encryption_configuration {
    encryption_type = var.encryption_type-ecr-mod
    kms_key         = var.encryption_type-ecr-mod == "KMS" ? var.kms_key_arn-ecr-mod : null
  }

  tags = merge(
    var.tags-ecr-mod,
    { Name = "${var.name_prefix-ecr-mod}-${each.value}" }
  )
}

############################################
# Lifecycle policy (applied per repository)
# - expires untagged images after N days
# - keeps only the last N "v"-prefixed tagged images
############################################
resource "aws_ecr_lifecycle_policy" "this" {
  for_each   = var.enable_lifecycle_policy-ecr-mod ? aws_ecr_repository.this : {}
  repository = each.value.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images older than ${var.untagged_image_expiry_days-ecr-mod} days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = var.untagged_image_expiry_days-ecr-mod
        }
        action = { type = "expire" }
      },
      {
        rulePriority = 2
        description  = "Keep only the last ${var.max_image_count-ecr-mod} tagged (v*) images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]
          countType     = "imageCountMoreThan"
          countNumber   = var.max_image_count-ecr-mod
        }
        action = { type = "expire" }
      }
    ]
  })
}

############################################
# Optional repository policy (applied per
# repository) granting pull access to
# specific IAM principals (e.g. the EC2
# instance role or ECS cluster role)
############################################
resource "aws_ecr_repository_policy" "this" {
  for_each   = length(var.pull_principal_arns-ecr-mod) > 0 ? aws_ecr_repository.this : {}
  repository = each.value.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowPull"
        Effect    = "Allow"
        Principal = { AWS = var.pull_principal_arns-ecr-mod }
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
      }
    ]
  })
}

############################################
# ECS cluster IAM role
# Standard "ecsInstanceRole" pattern: trusted
# by EC2, attached to EC2 container instances
# that register with an ECS cluster. Grants
# the ECS agent permission to register/
# deregister the instance, pull images from
# ECR, and write logs.
############################################
resource "aws_iam_role" "ecs_cluster" {
  count = var.create_ecs_cluster_role-ecr-mod ? 1 : 0
  name  = "${var.name_prefix-ecr-mod}-${var.ecs_cluster_role_name-ecr-mod}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(
    var.tags-ecr-mod,
    { Name = "${var.name_prefix-ecr-mod}-${var.ecs_cluster_role_name-ecr-mod}" }
  )
}

resource "aws_iam_role_policy_attachment" "ecs_cluster" {
  count      = var.create_ecs_cluster_role-ecr-mod ? 1 : 0
  role       = aws_iam_role.ecs_cluster[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_cluster" {
  count = var.create_ecs_cluster_role-ecr-mod ? 1 : 0
  name  = "${var.name_prefix-ecr-mod}-${var.ecs_cluster_role_name-ecr-mod}-profile"
  role  = aws_iam_role.ecs_cluster[0].name
}
