terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws    = { source = "hashicorp/aws",    version = "~> 5.0" }
    random = { source = "hashicorp/random", version = "~> 3.5" }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags { tags = var.common_tags }
}

resource "random_id" "suffix" { byte_length = 4 }

resource "aws_s3_bucket" "app" {
  bucket = "${var.project_name}-app-${random_id.suffix.hex}"
}

resource "aws_s3_bucket" "logs" {
  bucket = "${var.project_name}-logs-${random_id.suffix.hex}"
}

resource "aws_s3_bucket_versioning" "app" {
  bucket = aws_s3_bucket.app.id
  versioning_configuration { status = var.enable_versioning ? "Enabled" : "Suspended" }
}
