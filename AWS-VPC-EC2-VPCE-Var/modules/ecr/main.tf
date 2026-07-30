############################################
# ECR Repository
############################################
resource "aws_ecr_repository" "this" {
  name                 = "${var.name_prefix-ecr-mod}-${var.repository_name-ecr-mod}"
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
    { Name = "${var.name_prefix-ecr-mod}-${var.repository_name-ecr-mod}" }
  )
}

############################################
# Lifecycle policy
# - expires untagged images after N days
# - keeps only the last N "v"-prefixed tagged images
############################################
resource "aws_ecr_lifecycle_policy" "this" {
  count      = var.enable_lifecycle_policy-ecr-mod ? 1 : 0
  repository = aws_ecr_repository.this.name

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
# Optional repository policy granting pull
# access to specific IAM principals (e.g.
# the EC2 instance role)
############################################
resource "aws_ecr_repository_policy" "this" {
  count      = length(var.pull_principal_arns-ecr-mod) > 0 ? 1 : 0
  repository = aws_ecr_repository.this.name

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
