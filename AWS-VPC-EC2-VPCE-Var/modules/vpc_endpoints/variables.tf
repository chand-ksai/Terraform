variable "name_prefix-vpce-mod" {
  description = "Prefix used to name all resources created by this module"
  type        = string
}

variable "vpc_id-vpce-mod" {
  description = "ID of the VPC (from the vpc module) the endpoints will be created in"
  type        = string
}

variable "vpc_cidr-vpce-mod" {
  description = "CIDR block of the VPC (from the vpc module), used to scope endpoint SG ingress"
  type        = string
}

variable "private_subnet_ids-vpce-mod" {
  description = "IDs of the private subnets (from the vpc module) the interface endpoints are deployed into"
  type        = list(string)
}

variable "tags-vpce-mod" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
