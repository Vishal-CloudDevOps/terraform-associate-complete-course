# ============================================================
# PROJECT 06 — First AWS Resource: S3 Bucket (Hardcoded)
# Learning: AWS provider, aws_s3_bucket, tags
# NOTE: Real AWS account needed from here on!
# ============================================================
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" {
  region = "us-east-1"   # hardcoded for now
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-first-terraform-bucket-abc12345"  # MUST be globally unique

  tags = {
    Name        = "my-first-terraform-bucket"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "my_versioning" {
  bucket = aws_s3_bucket.my_bucket.id  # implicit dependency

  versioning_configuration {
    status = "Enabled"
  }
}
