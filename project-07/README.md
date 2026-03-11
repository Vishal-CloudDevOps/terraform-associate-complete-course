# Project 07 — AWS Resources with Full Variables, Outputs & tfvars

## 🎯 What You Will Learn
- Applying variables, outputs, and tfvars to real AWS resources
- `provider "aws"` with `default_tags` (tags on ALL resources automatically)
- Using `random_id` to ensure unique bucket names
- Conditional expressions with bool variables
- Combining everything from Projects 03–06

## 📖 Exam Domain
- Domain 3: Full variable/output workflow with AWS

---

## 🧠 Theory: Provider `default_tags`

Instead of adding tags to every single resource, the AWS provider supports `default_tags`:

```hcl
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Environment = var.environment
    }
  }
}
```

These tags are **automatically applied to every resource** the provider creates. You can still override them per-resource.

---

## 🧠 Theory: Conditional Expressions (First Look)

The ternary operator: `condition ? value_if_true : value_if_false`

```hcl
status = var.enable_versioning ? "Enabled" : "Suspended"
# If enable_versioning=true  → "Enabled"
# If enable_versioning=false → "Suspended"
```

This is your first look at conditionals — Project 16 covers them in depth.

---

## 🧠 Theory: Using `random_id` for Unique Names

S3 bucket names must be globally unique. Using `random_id` solves this:

```hcl
resource "random_id" "suffix" {
  byte_length = 4   # generates 8 hex characters
}

resource "aws_s3_bucket" "app" {
  bucket = "${var.project_name}-app-${random_id.suffix.hex}"
  # e.g., "my-project-app-a1b2c3d4"
}
```

---

## 🚀 How to Run

```bash
# Edit terraform.tfvars — update project_name to something unique
terraform init
terraform plan
terraform apply
terraform output
terraform output -json
terraform destroy
```

## ✅ Exam Tips
> `default_tags` in provider block applies tags to ALL resources  
> Ternary: `condition ? true_val : false_val`  
> `random_id.name.hex` gives a random hex string  

## ➡️ Next Project
Project 08 covers the full CLI workflow — fmt, validate, plan flags, apply flags.
