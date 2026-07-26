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

variable "tags-root-mod" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    Project = "AWS-VPC"
    Managed = "terraform"
  }
}
