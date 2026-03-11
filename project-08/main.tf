terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws    = { source = "hashicorp/aws",    version = "~> 5.0" }
    random = { source = "hashicorp/random", version = "~> 3.5" }
  }
}
provider "aws" { region = var.aws_region }
resource "random_id" "suffix" { byte_length = 4 }
resource "aws_s3_bucket" "demo" {
  bucket = "${var.project_name}-${random_id.suffix.hex}"
  tags   = { Name = var.project_name, Environment = var.environment }
}
