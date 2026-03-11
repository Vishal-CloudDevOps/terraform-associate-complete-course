terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws    = { source = "hashicorp/aws",    version = "~> 5.0" }
    random = { source = "hashicorp/random", version = "~> 3.5" }
  }
}
provider "aws" { region = var.aws_region }
resource "random_id" "suffix" { byte_length = 4 }

# count with a fixed number
resource "aws_iam_user" "team" {
  count = 3
  name  = "${var.project_name}-user-${count.index + 1}"
  tags  = { Index = tostring(count.index), Role = count.index == 0 ? "admin" : "member" }
}

# count driven by list length
resource "aws_s3_bucket" "env_buckets" {
  count  = length(var.environments)
  bucket = "${var.project_name}-${var.environments[count.index]}-${random_id.suffix.hex}"
  tags   = { Environment = var.environments[count.index], Index = tostring(count.index) }
}

# count with conditional (0 or 1 trick)
resource "aws_s3_bucket" "optional_bucket" {
  count  = var.create_optional ? 1 : 0
  bucket = "${var.project_name}-optional-${random_id.suffix.hex}"
}
