variable "name_prefix-ecr-mod" {
  description = "Prefix used to name all resources created by this module"
  type        = string
}

variable "repository_names-ecr-mod" {
  description = "Names of the ECR repositories to create (each is prefixed with name_prefix-ecr-mod). Must be lowercase per ECR naming rules"
  type        = list(string)
  default     = ["app", "reports", "db"]

  validation {
    condition     = alltrue([for n in var.repository_names-ecr-mod : n == lower(n)])
    error_message = "repository_names-ecr-mod entries must be lowercase (ECR repository names cannot contain uppercase characters)."
  }
}

variable "image_tag_mutability-ecr-mod" {
  description = "Whether image tags can be overwritten (MUTABLE or IMMUTABLE). Applies to all repositories"
  type        = string
  default     = "IMMUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability-ecr-mod)
    error_message = "image_tag_mutability-ecr-mod must be either \"MUTABLE\" or \"IMMUTABLE\"."
  }
}

variable "scan_on_push-ecr-mod" {
  description = "Whether images are scanned for vulnerabilities on push. Applies to all repositories"
  type        = bool
  default     = true
}

variable "encryption_type-ecr-mod" {
  description = "Encryption type for the repositories (AES256 or KMS)"
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type-ecr-mod)
    error_message = "encryption_type-ecr-mod must be either \"AES256\" or \"KMS\"."
  }
}

variable "kms_key_arn-ecr-mod" {
  description = "ARN of the KMS key to use when encryption_type-ecr-mod is \"KMS\". Ignored otherwise"
  type        = string
  default     = null
}

variable "force_delete-ecr-mod" {
  description = "Whether to delete a repository even if it still contains images (useful for dev/test)"
  type        = bool
  default     = false
}

variable "enable_lifecycle_policy-ecr-mod" {
  description = "Whether to attach a lifecycle policy that expires old/untagged images. Applies to all repositories"
  type        = bool
  default     = true
}

variable "untagged_image_expiry_days-ecr-mod" {
  description = "Number of days after which untagged images are expired by the lifecycle policy"
  type        = number
  default     = 7
}

variable "max_image_count-ecr-mod" {
  description = "Maximum number of tagged images (prefix \"v\") to retain per repository; older ones are expired by the lifecycle policy"
  type        = number
  default     = 10
}

variable "pull_principal_arns-ecr-mod" {
  description = "IAM principal ARNs (roles/users/accounts) granted pull access via a repository policy, applied to every repository. Leave empty to skip creating repository policies"
  type        = list(string)
  default     = []
}

############################################
# ECS cluster IAM role
############################################
variable "create_ecs_cluster_role-ecr-mod" {
  description = "Whether to create the IAM role (+ instance profile) used by EC2 container instances registering with an ECS cluster"
  type        = bool
  default     = true
}

variable "ecs_cluster_role_name-ecr-mod" {
  description = "Name suffix for the ECS cluster role (prefixed with name_prefix-ecr-mod)"
  type        = string
  default     = "ecs-cluster-role"
}

variable "tags-ecr-mod" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
