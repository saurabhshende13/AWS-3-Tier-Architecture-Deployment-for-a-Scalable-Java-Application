# VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  public_subnets      = var.public_subnets
  app_private_subnets = var.app_private_subnets
  db_private_subnets  = var.db_private_subnets
  environment         = var.environment
}

# Security Module
module "security" {
  source = "./modules/security"

  vpc_id          = module.vpc.vpc_id
  ssh_allowed_ips = var.ssh_allowed_ips
  environment     = var.environment
}

# Bastion Host Module
module "bastion" {
  source = "./modules/bastion"

  vpc_id                = module.vpc.vpc_id
  subnet_id             = module.vpc.public_subnet_ids[0]
  security_group_id     = module.security.bastion_sg_id
  bastion_instance_type = var.bastion_instance_type
  bastion_ami           = var.bastion_ami
  key_name              = var.key_name
  environment           = var.environment
}

# Application Load Balancer Module
module "alb" {
  source = "./modules/alb"

  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  security_group_id   = module.security.alb_sg_id
  ssl_certificate_arn = var.ssl_certificate_arn
  environment         = var.environment
}

# Nginx Module
module "nginx" {
  source = "./modules/nginx"
  vpc_id               = module.vpc.vpc_id
  subnet_ids           = module.vpc.public_subnet_ids
  security_group_id    = module.security.nginx_sg_id
  nginx_instance_type  = var.nginx_instance_type
  app_target_group_arn = module.alb.app_target_group_arn
  environment          = var.environment
  key_name              = var.key_name
}

# Application Module
module "app" {
  source = "./modules/app"

  vpc_id               = module.vpc.vpc_id
  subnet_ids           = module.vpc.app_private_subnet_ids
  security_group_id    = module.security.app_sg_id
  app_instance_type    = var.app_instance_type
  app_min_size         = var.app_min_size
  app_max_size         = var.app_max_size
  app_desired_capacity = var.app_desired_capacity
  target_group_arn     = module.alb.app_target_group_arn
  db_endpoint          = module.rds.db_endpoint
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
  environment          = var.environment
  key_name             = var.key_name
}

# RDS Module
module "rds" {
  source = "./modules/rds"

  vpc_id               = module.vpc.vpc_id
  availability_zones   = var.availability_zones
  subnet_ids           = module.vpc.db_private_subnet_ids
  security_group_id    = module.security.db_sg_id
  db_instance_class    = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage
  db_engine            = var.db_engine
  db_engine_version    = var.db_engine_version
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
  environment          = var.environment
}