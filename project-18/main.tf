terraform {
  required_version = ">= 1.5.0"
  required_providers { aws = { source = "hashicorp/aws", version = "~> 5.0" } }
}
provider "aws" { region = var.aws_region }

module "web_sg" {
  source        = "./modules/security-group"
  name          = "${var.project_name}-web-sg"
  ingress_rules = [
    { port = 80,  description = "HTTP",  cidr = "0.0.0.0/0" },
    { port = 443, description = "HTTPS", cidr = "0.0.0.0/0" }
  ]
}

module "web_server" {
  source            = "./modules/ec2-instance"
  instance_name     = "${var.project_name}-web"
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  security_group_id = module.web_sg.security_group_id
  environment       = var.environment
}
