# ============================================================
# PROJECT 12 — Remote Backend (S3 + DynamoDB State Locking)
#
# SETUP ORDER:
# 1. Comment out this backend block
# 2. terraform init && terraform apply  (creates S3 + DynamoDB)
# 3. Uncomment this block with your bucket name
# 4. terraform init -migrate-state
# ============================================================
terraform {
  backend "s3" {
    bucket         = "REPLACE-WITH-YOUR-STATE-BUCKET"
    key            = "project-12/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
