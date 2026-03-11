terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws    = { source = "hashicorp/aws",    version = "~> 5.0" }
    random = { source = "hashicorp/random", version = "~> 3.5" }
  }
}
provider "aws" { region = var.aws_region }
resource "random_id" "suffix" { byte_length = 4 }

# create_before_destroy: new resource created before old one is destroyed
resource "aws_s3_bucket" "blue_green" {
  bucket = "${var.project_name}-bg-${random_id.suffix.hex}"
  lifecycle {
    create_before_destroy = true
  }
}

# prevent_destroy: blocks any plan that would destroy this resource
resource "aws_s3_bucket" "critical" {
  bucket = "${var.project_name}-critical-${random_id.suffix.hex}"
  lifecycle {
    prevent_destroy = true
  }
}

# ignore_changes: Terraform won't react to external changes to these attributes
resource "aws_s3_bucket" "externally_tagged" {
  bucket = "${var.project_name}-ext-${random_id.suffix.hex}"
  tags   = { Name = "externally-tagged", Environment = var.environment }
  lifecycle {
    ignore_changes = [tags]   # External system modifies tags — Terraform ignores it
  }
}
