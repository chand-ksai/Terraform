variable "name_prefix" {
  description = "Prefix used to name all resources created by this module"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC (from the vpc module) instances are launched into"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC (from the vpc module), used to scope the security group"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID (from the vpc module) for the public instance"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID (from the vpc module) for the private instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for both instances"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID to use. Leave null to auto-select the latest Amazon Linux 2023 AMI"
  type        = string
  default     = null
}

variable "key_name" {
  description = "Optional EC2 key pair name for SSH access. Leave null to rely on SSM Session Manager only (recommended)"
  type        = string
  default     = null
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 20
}

variable "associate_public_ip_on_public_instance" {
  description = "Whether the public instance receives a public IP (the public subnet already auto-assigns one, this is an explicit override)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
