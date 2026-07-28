variable "name_prefix-child-mod" {
  description = "Prefix used to name all resources created by this module"
  type        = string
}

variable "vpc_cidr-child-mod" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs-child-mod" {
  description = "Availability zones to spread subnets across (index-aligned with the subnet CIDR lists)"
  type        = list(string)
}

variable "public_subnet_cidrs-child-mod" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs-child-mod" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
}

variable "tags-child-mod" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
