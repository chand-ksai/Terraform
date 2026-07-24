aws_region  = "us-east-1"
name_prefix = "myapp"

vpc_cidr = "10.0.0.0/16"
azs      = ["us-east-1a", "us-east-1b"]

public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

tags = {
  Project     = "AWS-VPC"
  Environment = "default"
  Managed     = "terraform"
}
