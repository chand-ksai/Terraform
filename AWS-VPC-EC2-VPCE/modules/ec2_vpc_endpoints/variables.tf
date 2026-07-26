variable "name_prefix" {
  description = "Prefix used to name all resources created by this module"
  type        = string
}

variable "aws_region" {
  description = "AWS region the endpoints are created in (used to build service names)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC (from the vpc module) to attach the endpoints to"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC (from the vpc module), used to scope the endpoint SG"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs (from the vpc module) the interface endpoint ENIs are placed in - typically the private subnets"
  type        = list(string)
}

variable "create_s3_gateway_endpoint" {
  description = "Whether to also create a free S3 gateway endpoint (useful since docker/git pulls often traverse S3-backed registries, and it doesn't cost anything or consume ENIs)"
  type        = bool
  default     = true
}

variable "private_route_table_ids" {
  description = "Route table IDs to associate the S3 gateway endpoint with (only used if create_s3_gateway_endpoint = true)"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
