terraform {
  required_version = ">= 1.5.0"
  required_providers { aws = { source = "hashicorp/aws", version = "~> 5.0" } }
}
provider "aws" { region = var.aws_region }

# for_each with a SET of strings
resource "aws_iam_user" "devs" {
  for_each = toset(var.developer_names)
  name     = each.key
  tags     = { Role = "developer" }
}

# for_each with a MAP of objects
resource "aws_s3_bucket" "buckets" {
  for_each = var.buckets
  bucket   = each.value.bucket_name
  tags     = { Name = each.key, Environment = each.value.environment, Purpose = each.value.purpose }
}

# Conditional for_each (only versioned buckets)
resource "aws_s3_bucket_versioning" "versioned" {
  for_each = { for k, v in var.buckets : k => v if v.versioning }
  bucket   = aws_s3_bucket.buckets[each.key].id
  versioning_configuration { status = "Enabled" }
}
