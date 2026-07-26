############################################
# VPC
############################################
module "vpc" {
  source = "./modules/vpc"

  name_prefix          = var.name_prefix
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  tags                 = var.tags
}

############################################
# VPC Endpoints (SSM access for EC2)
############################################
module "ec2_vpc_endpoints" {
  source = "./modules/ec2_vpc_endpoints"

  name_prefix    = var.name_prefix
  aws_region     = var.aws_region
  vpc_id         = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block

  # Interface endpoint ENIs live in the private subnets
  subnet_ids = module.vpc.private_subnet_ids

  create_s3_gateway_endpoint = true
  private_route_table_ids    = [module.vpc.default_route_table_id]

  tags = var.tags
}

############################################
# EC2 Instances (public + private, SSM managed)
############################################
module "ec2" {
  source = "./modules/ec2"

  name_prefix       = var.name_prefix
  vpc_id            = module.vpc.vpc_id
  vpc_cidr_block    = module.vpc.vpc_cidr_block
  public_subnet_id  = module.vpc.public_subnet_ids[0]
  private_subnet_id = module.vpc.private_subnet_ids[0]

  instance_type = var.instance_type
  key_name      = var.key_name

  tags = var.tags

  depends_on = [module.ec2_vpc_endpoints]
}
