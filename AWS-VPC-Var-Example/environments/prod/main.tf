terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # backend "s3" {
  #   bucket         = "my-terraform-state-bucket"
  #   key            = "aws-vpc/prod/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-lock-table"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = "us-east-1"
}

# NOTE: prod uses a different CIDR range (10.1.0.0/16) than dev
# (10.0.0.0/16) so the two VPCs don't overlap if you ever need to
# peer them or connect via Transit Gateway. Adjust as needed.
module "vpc" {
  source = "../../modules/vpc"

  name_prefix-child-mod = "prod"
  vpc_cidr-child-mod    = "10.1.0.0/16"
  azs-child-mod         = ["us-east-1a", "us-east-1b"]

  public_subnet_cidrs-child-mod  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnet_cidrs-child-mod = ["10.1.3.0/24", "10.1.4.0/24"]

  tags-child-mod = {
    Project     = "AWS-VPC"
    Environment = "prod"
    Managed     = "terraform"
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "nat_gateway_id" {
  value = module.vpc.nat_gateway_id
}
