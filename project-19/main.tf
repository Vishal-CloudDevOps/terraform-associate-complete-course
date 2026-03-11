terraform {
  required_version = ">= 1.5.0"
  required_providers { aws = { source = "hashicorp/aws", version = "~> 5.0" } }
}
provider "aws" { region = var.aws_region }

# This resource ALREADY EXISTS in AWS.
# Use the import block (or CLI) to bring it under Terraform management.
resource "aws_s3_bucket" "imported" {
  bucket = var.existing_bucket_name
  tags = { ManagedBy = "Terraform"; Imported = "true"; Environment = var.environment }
}
resource "aws_s3_bucket_versioning" "imported" {
  bucket = aws_s3_bucket.imported.id
  versioning_configuration { status = "Enabled" }
}
