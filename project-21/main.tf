terraform {
  required_version = ">= 1.5.0"
  required_providers { aws = { source = "hashicorp/aws", version = "~> 5.0" } }
}
provider "aws" { region = var.aws_region }

resource "aws_s3_bucket" "application" {   # was "app" before — use moved block!
  bucket = var.bucket_name

  # POSTCONDITION: validate after creation
  lifecycle {
    postcondition {
      condition     = self.bucket == var.bucket_name
      error_message = "Bucket name does not match expected value."
    }
  }
}

variable "bucket_name" {
  type = string
  default = "tf-moved-check-demo-xyz789"

  # PRECONDITION on variable: validate before any resources are touched
  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "Bucket name must be 3-63 characters."
  }
}

variable "aws_region" { type = string; default = "us-east-1" }
variable "environment" { type = string; default = "dev" }

# CHECK BLOCK: non-fatal assertion — warns but doesn't fail
check "bucket_name_is_lowercase" {
  assert {
    condition     = var.bucket_name == lower(var.bucket_name)
    error_message = "Bucket name should be lowercase for S3 compatibility."
  }
}
