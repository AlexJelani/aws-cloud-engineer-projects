data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

module "vpc" {
  source = "../../modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "security" {
  source = "../../modules/security"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  vpc_cidr     = var.vpc_cidr
}

module "database" {
  source = "../../modules/database"

  project_name               = var.project_name
  db_subnet_ids              = module.vpc.database_subnet_ids
  database_security_group_id = module.security.database_security_group_id
  db_username                = var.db_username
  db_password                = var.db_password
}

module "app" {
  source = "../../modules/app"

  project_name          = var.project_name
  environment           = var.environment
  ami_id                = data.aws_ami.amazon_linux.id
  instance_type         = var.instance_type
  key_name              = var.ec2_key_name
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  private_subnet_ids    = module.vpc.private_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  app_security_group_id = module.security.app_security_group_id
}

module "monitoring" {
  source = "../../modules/monitoring"

  project_name                 = var.project_name
  autoscaling_group_name       = module.app.autoscaling_group_name
  load_balancer_arn_suffix     = module.app.load_balancer_arn_suffix
  target_group_arn_suffix      = module.app.target_group_arn_suffix
  database_instance_identifier = module.database.db_instance_identifier
}

module "pipeline" {
  source = "../../modules/pipeline"

  project_name          = var.project_name
  github_owner          = var.github_owner
  github_repo           = var.github_repo
  github_branch         = var.github_branch
  github_connection_arn = var.github_connection_arn
  codedeploy_app_name   = module.app.codedeploy_app_name
  codedeploy_group_name = module.app.codedeploy_group_name
}
