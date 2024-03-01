module "vpc" {
  source = "./modules/vpc"
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  azs = var.availability_zones
}

module "security" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id
}

module "templates" {
  source = "./modules/templates"

  apps = var.apps
  public_security_groups = [module.security.public_facing_security_group]
  private_security_groups = [module.security.private_ssh_security_group]
  key = var.key_name
}

module "autoscaler" {
  source = "./modules/autoscaler"
  templates = module.templates.template_details
  min = 3
  max = 9
  desired = 3
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
}

module "load_balancer" {
  source = "./modules/load-balancer"

  count = length(module.autoscaler.autoscalers)
  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
  private_subnets = module.vpc.private_subnet_ids
  public_security_groups = [module.security.private_ssh_security_group]
  private_security_groups = [module.security.public_facing_security_group]
  name = module.autoscaler.autoscalers[count.index].name
  autoscaling_group = module.autoscaler.autoscalers[count.index].autoscaling_group
  internal_only = module.autoscaler.autoscalers[count.index].internal_only
}