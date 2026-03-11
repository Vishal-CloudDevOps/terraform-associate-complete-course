# Project 06 — First AWS Resource: S3 Bucket

## 🎯 What You Will Learn
- Setting up the AWS provider
- Creating your first real AWS resource (`aws_s3_bucket`)
- S3 bucket naming rules
- The `tags` argument (used on almost every AWS resource)
- Referencing resource attributes (`aws_s3_bucket.my_bucket.id`)

## 📖 Exam Domain
- Domain 2: Terraform purpose — managing real cloud resources
- Domain 3: Provider setup, resource creation

---

## 🧠 Theory: AWS Provider Setup

To create AWS resources, configure the AWS provider:

```hcl
provider "aws" {
  region = "us-east-1"
}
```

**Credentials:** Never put access keys in your `.tf` files! Use one of:
```bash
# Option 1: Environment variables (most common in CI/CD)
export AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"
export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
export AWS_DEFAULT_REGION="us-east-1"

# Option 2: AWS CLI (after running 'aws configure')
# Terraform reads ~/.aws/credentials automatically

# Option 3: IAM Instance Role (EC2 instances, ECS tasks)
# Terraform auto-detects when running in AWS
```

---

## 🧠 Theory: S3 Bucket Basics

```hcl
resource "aws_s3_bucket" "my_bucket" {
  bucket = "globally-unique-name-12345"

  tags = {
    Name        = "My Bucket"
    Environment = "dev"
  }
}
```

**S3 bucket naming rules:**
- 3–63 characters
- Lowercase letters, numbers, and hyphens only
- Must be **globally unique** across all AWS accounts
- Cannot start or end with a hyphen

---

## 🧠 Theory: Tags

Tags are key-value pairs attached to AWS resources for:
- Tracking costs (by environment, team, project)
- Finding resources (filter by tag in AWS Console)
- Security policies (IAM based on tags)
- Automation

```hcl
tags = {
  Name        = "my-bucket"     # Name tag is special — shows in AWS Console
  Environment = "dev"
  Team        = "platform"
  Project     = "webapp"
  ManagedBy   = "Terraform"     # Always good to have this!
}
```

---

## 🧠 Theory: The `id` Attribute

Every AWS resource has an `id` attribute — it's the primary identifier:

```hcl
resource "aws_s3_bucket_versioning" "v" {
  bucket = aws_s3_bucket.my_bucket.id   # uses the bucket's id
}
```

For S3, `id` = the bucket name. For EC2, `id` = the instance ID (`i-12345678`).

---

## 🚀 How to Run

```bash
# Configure AWS credentials first
aws configure   # or set environment variables

terraform init
terraform plan   # See what will be created (no charges yet!)
terraform apply

# Verify in AWS console or CLI:
aws s3 ls | grep my-first-terraform

terraform destroy   # Removes the bucket
```

---

## ⚠️ Cost Warning
S3 buckets themselves are free, but storing objects costs money. This project creates only an empty bucket.

## ✅ Exam Tips
> AWS provider needs credentials — never hardcode in `.tf` files  
> S3 bucket names are globally unique across ALL AWS accounts  
> `id` attribute is the primary identifier for any AWS resource  
> `tags` are key-value pairs, type `map(string)`  

## ➡️ Next Project
Project 07 moves region and bucket name to variables + adds outputs — applying lessons from Projects 03-05 to AWS.
