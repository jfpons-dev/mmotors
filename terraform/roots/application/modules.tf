module "network" {
  source              = "../../modules/network"
  region              = var.region
  vpc_cidr_block      = var.vpc_cidr_block
  vpc_name            = var.vpc_name
  public_subnets      = var.public_subnets
  private_subnets_app = var.private_subnets_app
  private_subnets_db  = var.private_subnets_db
  private_subnets_dev = var.private_subnets_dev
}

