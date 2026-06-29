##############################################################
# Root main.tf — Module Orchestration
# Calls: networking → security → alb → compute
##############################################################

module "networking" {
  source = "./modules/networking"

  vpc_cidr      = var.vpc_cidr
  public1_cidr  = var.public1_cidr
  public2_cidr  = var.public2_cidr
  private1_cidr = var.private1_cidr
  private2_cidr = var.private2_cidr
  az1           = var.az1
  az2           = var.az2
  env           = var.env
}

module "security" {
  source = "./modules/security"

  vpc_id   = module.networking.vpc_id
  ssh_cidr = var.ssh_cidr
  env      = var.env
}

module "alb" {
  source = "./modules/alb"

  vpc_id          = module.networking.vpc_id
  alb_sg_id       = module.security.alb_sg_id
  public_subnet_1 = module.networking.public_subnet_1
  public_subnet_2 = module.networking.public_subnet_2
  env             = var.env
}

module "compute" {
  source = "./modules/compute"

  instance_type       = var.instance_type
  ec2_sg_id           = module.security.ec2_sg_id
  public_subnet_1     = module.networking.public_subnet_1
  public_subnet_2     = module.networking.public_subnet_2
  target_group_arn    = module.alb.target_group_arn
  public_key          = var.public_key
  private_key_content = var.private_key_content
  asg_desired         = var.asg_desired
  asg_min             = var.asg_min
  asg_max             = var.asg_max
  cpu_target_value    = var.cpu_target_value
  env                 = var.env
}