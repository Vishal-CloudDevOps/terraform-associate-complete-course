terraform {
  required_version = ">= 1.5.0"
  required_providers { aws = { source = "hashicorp/aws", version = "~> 5.0" } }
}
provider "aws" { region = var.aws_region }
locals {
  ws      = terraform.workspace
  size    = lookup({ default="t2.micro", dev="t2.micro", staging="t2.small", prod="t3.medium" }, local.ws, "t2.micro")
  count_n = lookup({ default=1, dev=1, staging=1, prod=3 }, local.ws, 1)
  tags    = { Environment = local.ws, ManagedBy = "Terraform", Workspace = local.ws }
}
resource "aws_s3_bucket" "app" {
  bucket = "${var.project_name}-${local.ws}-app"
  tags   = local.tags
}
resource "aws_instance" "app" {
  count         = local.count_n
  ami           = var.ami_id
  instance_type = local.size
  tags          = merge(local.tags, { Name = "${var.project_name}-${local.ws}-server-${count.index+1}" })
}
