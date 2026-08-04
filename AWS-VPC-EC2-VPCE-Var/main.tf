module "vpc" {
  source = "./modules/vpc"

  name_prefix-child-mod          = var.name_prefix-root-mod
  vpc_cidr-child-mod             = var.vpc_cidr-root-mod
  azs-child-mod                  = var.azs-root-mod
  public_subnet_cidrs-child-mod  = var.public_subnet_cidrs-root-mod
  private_subnet_cidrs-child-mod = var.private_subnet_cidrs-root-mod
  tags-child-mod                 = var.tags-root-mod
}

############################################
# VPC Interface Endpoints for SSM access
# (deployed into the VPC's private subnets)
############################################
module "vpc_endpoints" {
  source = "./modules/vpc_endpoints"

  name_prefix-vpce-mod           = var.name_prefix-root-mod
  vpc_id-vpce-mod                = module.vpc.child-mod-op-child-mod-vpc-op
  vpc_cidr-vpce-mod              = module.vpc.vpc_cidr_block-child-mod-vpc-op
  private_subnet_ids-vpce-mod    = module.vpc.private_subnet_ids-child-mod-vpc-op
  tags-vpce-mod                  = var.tags-root-mod
  enable_ecr_endpoints-vpce-mod  = var.enable_ecr_endpoints-root-mod
  route_table_ids-vpce-mod = [
    module.vpc.public_route_table_id-child-mod-vpc-op,
    module.vpc.default_route_table_id-child-mod-vpc-op,
  ]
}

############################################
# ECR repositories (app, reports, db) +
# ECS cluster IAM role
############################################
module "ecr" {
  source = "./modules/ecr"

  name_prefix-ecr-mod             = var.name_prefix-root-mod
  repository_names-ecr-mod        = var.ecr_repository_names-root-mod
  create_ecs_cluster_role-ecr-mod = var.create_ecs_cluster_role-root-mod
  tags-ecr-mod                    = var.tags-root-mod
}

############################################
# EC2 instances (1 public, 1 private) - SSM
# managed, with git and docker installed
############################################
module "ec2" {
  source = "./modules/ec2"

  name_prefix-ec2-mod            = var.name_prefix-root-mod
  vpc_id-ec2-mod                 = module.vpc.child-mod-op-child-mod-vpc-op
  public_subnet_id-ec2-mod       = module.vpc.public_subnet_ids-child-mod-vpc-op[0]
  private_subnet_id-ec2-mod      = module.vpc.private_subnet_ids-child-mod-vpc-op[0]
  instance_type-ec2-mod          = var.instance_type-root-mod
  enable_ecr_push_policy-ec2-mod = var.enable_ecr_push_policy-root-mod
  tags-ec2-mod                   = var.tags-root-mod

  depends_on = [module.vpc_endpoints]
}
