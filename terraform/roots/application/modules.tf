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

module "security" {
  source = "../../modules/security"
  vpc_id = module.network.vpc_id
}

module "registry" {
  source = "../../modules/registry"
}

module "ecs" {
  source                 = "../../modules/ecs"
  ecr_repository_url     = module.registry.ecr_repository_url
  private_subnet_app_ids = module.network.private_subnet_app_ids
  ecs_security_group_id  = module.security.ecs_security_group_id
  target_group_arn       = module.loadbalancer.target_group_arn
}

module "loadbalancer" {
  source                = "../../modules/loadbalancer"
  vpc_id                = module.network.vpc_id
  alb_security_group_id = module.security.alb_security_group_id
  public_subnet_ids     = module.network.public_subnet_ids
}