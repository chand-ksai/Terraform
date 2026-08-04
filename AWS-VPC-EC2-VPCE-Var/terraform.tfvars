aws_region-root-mod  = "us-east-1"
name_prefix-root-mod = "myapp"

vpc_cidr-root-mod = "10.0.0.0/16"
azs-root-mod      = ["us-east-1a", "us-east-1b"]

public_subnet_cidrs-root-mod  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs-root-mod = ["10.0.3.0/24", "10.0.4.0/24"]

instance_type-root-mod = "t3.micro"

ecr_repository_names-root-mod   = ["app", "reports", "db"]
enable_ecr_endpoints-root-mod   = true
create_ecs_cluster_role-root-mod = true
enable_ecr_push_policy-root-mod  = true

tags-root-mod = {
  Project     = "AWS-VPC"
  Environment = "default"
  Managed     = "terraform"
}
