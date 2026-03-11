terraform {
  required_version = ">= 1.5.0"
  required_providers { aws = { source = "hashicorp/aws", version = "~> 5.0" } }
}
provider "aws" { region = var.aws_region }

# DATA SOURCE: auto-discover latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter { name = "name";                values = ["amzn2-ami-hvm-*-x86_64-gp2"] }
  filter { name = "virtualization-type"; values = ["hvm"] }
}

# DATA SOURCE: get current AWS account info
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# DATA SOURCE: read existing default VPC
data "aws_vpc" "default" { default = true }

locals {
  account_id  = data.aws_caller_identity.current.account_id
  region      = data.aws_region.current.name
  name_prefix = "${var.project_name}-${var.environment}-${local.region}"
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Region      = local.region
    AccountId   = local.account_id
    ManagedBy   = "Terraform"
  }
}

resource "aws_instance" "app" {
  ami           = data.aws_ami.amazon_linux.id   # auto-discovered!
  instance_type = var.instance_type
  tags          = merge(local.common_tags, { Name = "${local.name_prefix}-server" })
}
