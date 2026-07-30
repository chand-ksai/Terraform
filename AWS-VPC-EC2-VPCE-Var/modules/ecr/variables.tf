variable "name_prefix-ecr-mod" {
  description = "Prefix used to name all resources created by this module"
  type        = string
}

variable "repository_name-ecr-mod" {
  description = "Name of the ECR repository (will be prefixed with name_prefix-ecr-mod)"
  type        = string
}

variable "image_tag_mutability-ecr-mod" {
  description = "Whether image tags can be overwritten (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "IMMUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability-ecr-mod)
    error_message = "image_tag_mutability-ecr-mod must be either \"MUTABLE\" or \"IMMUTABLE\"."
  }
}

variable "scan_on_push-ecr-mod" {
  description = "Whether images are scanned for vulnerabilities on push"
  type        = bool
  default     = true
}

variable "encryption_type-ecr-mod" {
  description = "Encryption type for the repository (AES256 or KMS)"
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
  description = "Whether to delete the repository even if it still contains images (useful for dev/test)"
  type        = bool
  default     = false
}

variable "enable_lifecycle_policy-ecr-mod" {
  description = "Whether to attach a lifecycle policy that expires old/untagged images"
  type        = bool
  default     = true
}

variable "untagged_image_expiry_days-ecr-mod" {
  description = "Number of days after which untagged images are expired by the lifecycle policy"
  type        = number
  default     = 7
}

variable "max_image_count-ecr-mod" {
  description = "Maximum number of tagged images (prefix \"v\") to retain; older ones are expired by the lifecycle policy"
  type        = number
  default     = 10
}

variable "pull_principal_arns-ecr-mod" {
  description = "IAM principal ARNs (roles/users/accounts) granted pull access via a repository policy. Leave empty to skip creating a policy"
  type        = list(string)
  default     = []
}

variable "tags-ecr-mod" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
