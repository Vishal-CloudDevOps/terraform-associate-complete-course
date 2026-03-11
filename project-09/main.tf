terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws    = { source = "hashicorp/aws",    version = "~> 5.0" }
    random = { source = "hashicorp/random", version = "~> 3.5" }
  }
}
provider "aws" { region = var.aws_region }
resource "random_id" "suffix" { byte_length = 4 }
resource "aws_s3_bucket" "app"  { bucket = "${var.project_name}-app-${random_id.suffix.hex}" }
resource "aws_s3_bucket" "logs" { bucket = "${var.project_name}-logs-${random_id.suffix.hex}" }
resource "aws_iam_user" "svc"   { name = "${var.project_name}-service-account" }
