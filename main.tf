provider "aws" {
  region  = "us-east-1"
  profile = "personal"
}

module "networking" {
  source = "./networking"
  aws_account_id = var.account
  env = var.env
  app_name = var.app
}

module "application" {
  source = "./application"
  app_name = var.app
  env = var.env
  private_subnets = module.networking.private_subnets
  public_subnets = module.networking.public_subnets
  vpc_id = module.networking.vpc_id
  depends_on = [module.networking]
}

