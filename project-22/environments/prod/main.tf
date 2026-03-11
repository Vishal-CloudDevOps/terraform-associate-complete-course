terraform {
  required_version = ">= 1.5.0"
  required_providers { aws = { source = "hashicorp/aws", version = "~> 5.0" } }
}
provider "aws" { region = var.aws_region }

locals {
  env         = "prod"
  name_prefix = "${var.project_name}-${local.env}"
  tags        = { Project = var.project_name, Environment = local.env, ManagedBy = "terraform" }
}

module "networking" {
  source               = "../../modules/networking"
  name_prefix          = local.name_prefix
  vpc_cidr             = "10.1.0.0/16"
  public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnet_cidrs = ["10.1.10.0/24", "10.1.11.0/24"]
  tags                 = local.tags
}

module "compute" {
  source         = "../../modules/compute"
  name_prefix    = local.name_prefix
  environment    = local.env
  vpc_id         = module.networking.vpc_id
  subnet_ids     = module.networking.public_subnet_ids
  instance_type  = "t3.medium"
  instance_count = 3
  tags           = local.tags
}
