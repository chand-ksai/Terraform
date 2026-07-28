terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  # Credentials are picked up from the standard AWS provider chain:
  # environment variables (AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY),
  # shared credentials file (~/.aws/credentials), or an assumed IAM role.
  # Avoid hardcoding credentials here.
}
