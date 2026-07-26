aws_region-root-mod  = "us-east-1"
name_prefix-root-mod = "myapp"

vpc_cidr-root-mod = "10.0.0.0/16"
azs-root-mod      = ["us-east-1a", "us-east-1b"]

public_subnet_cidrs-root-mod  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs-root-mod = ["10.0.3.0/24", "10.0.4.0/24"]

tags-root-mod = {
  Project     = "AWS-VPC"
  Environment = "default"
  Managed     = "terraform"
}
