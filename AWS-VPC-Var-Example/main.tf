module "vpc" {
  source = "./modules/vpc"

  name_prefix-child-mod          = var.name_prefix-root-mod
  vpc_cidr-child-mod             = var.vpc_cidr-root-mod
  azs-child-mod                  = var.azs-root-mod
  public_subnet_cidrs-child-mod  = var.public_subnet_cidrs-root-mod
  private_subnet_cidrs-child-mod = var.private_subnet_cidrs-root-mod
  tags-child-mod                 = var.tags-root-mod
}
