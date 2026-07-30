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

variable "enable_ecr_endpoints-vpce-mod" {
  description = "Whether to create the ECR (api + dkr) interface endpoints and the S3 gateway endpoint required for image layer pulls"
  type        = bool
  default     = true
}

variable "route_table_ids-vpce-mod" {
  description = "Route table IDs (from the vpc module) to associate with the S3 gateway endpoint. Required when enable_ecr_endpoints-vpce-mod is true"
  type        = list(string)
  default     = []
}
