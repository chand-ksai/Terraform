variable "name_prefix-ec2-mod" {
  description = "Prefix used to name all resources created by this module"
  type        = string
}

variable "vpc_id-ec2-mod" {
  description = "ID of the VPC (from the vpc module) the instances will be deployed into"
  type        = string
}

variable "public_subnet_id-ec2-mod" {
  description = "ID of the public subnet (from the vpc module) the public EC2 instance is deployed into"
  type        = string
}

variable "private_subnet_id-ec2-mod" {
  description = "ID of the private subnet (from the vpc module) the private EC2 instance is deployed into"
  type        = string
}

variable "instance_type-ec2-mod" {
  description = "EC2 instance type to use for both instances"
  type        = string
  default     = "t3.micro"
}

variable "ami_id-ec2-mod" {
  description = "AMI ID to use for the instances. Leave null to auto-select the latest Amazon Linux 2023 AMI"
  type        = string
  default     = null
}

variable "tags-ec2-mod" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
