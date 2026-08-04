variable "aws_region-root-mod" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "name_prefix-root-mod" {
  description = "Prefix used to name all resources"
  type        = string
  default     = "myapp"
}

variable "vpc_cidr-root-mod" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs-root-mod" {
  description = "Availability zones to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs-root-mod" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs-root-mod" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "instance_type-root-mod" {
  description = "EC2 instance type used for the public and private instances"
  type        = string
  default     = "t3.micro"
}

variable "tags-root-mod" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    Project = "AWS-VPC"
    Managed = "terraform"
  }
}

variable "ecr_repository_names-root-mod" {
  description = "Names of the ECR repositories to create (each is prefixed with name_prefix-root-mod)"
  type        = list(string)
  default     = ["app", "reports", "db"]
}

variable "enable_ecr_endpoints-root-mod" {
  description = "Whether to create ECR (api + dkr) interface endpoints and the S3 gateway endpoint, so private-subnet instances can pull images without internet access"
  type        = bool
  default     = true
}

variable "create_ecs_cluster_role-root-mod" {
  description = "Whether to create the IAM role (+ instance profile) used by EC2 container instances registering with an ECS cluster"
  type        = bool
  default     = true
}

variable "enable_ecr_push_policy-root-mod" {
  description = "Whether to attach the AmazonEC2ContainerRegistryPowerUser managed policy to the EC2 SSM role, granting permission to push/pull Docker images to/from ECR"
  type        = bool
  default     = true
}
