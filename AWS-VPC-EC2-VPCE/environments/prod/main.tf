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

  name_prefix = "prod"
  vpc_cidr    = "10.1.0.0/16"
  azs         = ["us-east-1a", "us-east-1b"]

  public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnet_cidrs = ["10.1.3.0/24", "10.1.4.0/24"]

  tags = {
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

module "ec2_vpc_endpoints" {
  source = "../../modules/ec2_vpc_endpoints"

  name_prefix    = "prod"
  aws_region     = "us-east-1"
  vpc_id         = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block
  subnet_ids     = module.vpc.private_subnet_ids

  create_s3_gateway_endpoint = true
  private_route_table_ids    = [module.vpc.default_route_table_id]

  tags = {
    Project     = "AWS-VPC"
    Environment = "prod"
    Managed     = "terraform"
  }
}

module "ec2" {
  source = "../../modules/ec2"

  name_prefix       = "prod"
  vpc_id            = module.vpc.vpc_id
  vpc_cidr_block    = module.vpc.vpc_cidr_block
  public_subnet_id  = module.vpc.public_subnet_ids[0]
  private_subnet_id = module.vpc.private_subnet_ids[0]

  instance_type = "t3.micro"
  key_name      = null

  tags = {
    Project     = "AWS-VPC"
    Environment = "prod"
    Managed     = "terraform"
  }

  depends_on = [module.ec2_vpc_endpoints]
}

output "public_instance_id" {
  value = module.ec2.public_instance_id
}

output "public_instance_public_ip" {
  value = module.ec2.public_instance_public_ip
}

output "private_instance_id" {
  value = module.ec2.private_instance_id
}

output "private_instance_private_ip" {
  value = module.ec2.private_instance_private_ip
}
