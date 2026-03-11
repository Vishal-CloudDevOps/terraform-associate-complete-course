# Project 19 — Resource Import

## 🎯 What You Will Learn
- `terraform import` CLI command (classic method)
- Declarative `import {}` block (Terraform 1.5+)
- Auto-generate config with `-generate-config-out` (1.6+)
- Importing into modules
- What import does NOT do

## 📖 Exam Domain
- Domain 4: terraform import

---

## 🧠 Theory: Why Import?

Before Terraform was adopted, teams created infrastructure manually in the AWS Console. Import brings those existing resources under Terraform management **without destroying and recreating them**.

---

## 🧠 Theory: Classic Import (CLI)

```bash
# Step 1: Write the resource block in main.tf (matching the real resource)
# Step 2: Run import
terraform import aws_s3_bucket.imported my-bucket-name

# Format: terraform import <resource_address> <resource_id>
```

Common import IDs:

| Resource | ID format |
|---|---|
| `aws_s3_bucket` | bucket name |
| `aws_instance` | instance ID (`i-xxxxxxxxx`) |
| `aws_iam_user` | username |
| `aws_vpc` | VPC ID (`vpc-xxxxxxxx`) |
| `aws_security_group` | SG ID (`sg-xxxxxxxx`) |
| `aws_db_instance` | DB identifier |

---

## 🧠 Theory: Declarative Import Block (Terraform 1.5+)

```hcl
import {
  to = aws_s3_bucket.imported    # target resource in your config
  id = "my-existing-bucket"      # real resource ID
}
```

Then just run:
```bash
terraform plan    # import shown in the plan
terraform apply   # import + any config changes applied
```

**Advantages:** Version-controlled, reviewable in PR, works in CI/CD.

---

## 🧠 Theory: -generate-config-out (1.6+)

```bash
terraform plan -generate-config-out=generated.tf
```

Terraform:
1. Fetches real resource attributes from AWS
2. Writes a complete `resource {}` block to `generated.tf`
3. You review, edit if needed, then apply

---

## 🧠 Theory: What Import Does NOT Do

- Does NOT import dependencies (each resource must be imported separately)
- Does NOT write `.tf` config files (you must write them, unless using `-generate-config-out`)
- Does NOT guarantee a clean plan — you must align config with reality

---

## 🚀 How to Run

```bash
# Classic method (works in any version):
terraform init
terraform import aws_s3_bucket.imported your-actual-bucket-name
terraform plan      # should show "No changes" if config matches

# Modern method (1.5+):
# Edit import.tf — set id = "your-actual-bucket-name"
# Also set existing_bucket_name in variables
terraform plan      # import shown here
terraform apply
```

## ✅ Exam Tips
> Classic: `terraform import <address> <id>`  
> Modern: `import {}` block is version-controlled (Terraform 1.5+)  
> `-generate-config-out` auto-generates HCL (1.6+)  
> Import does NOT auto-create `.tf` files (classic)  
> Import does NOT import dependencies  
> After import, always run `plan` — should show "No changes"  

## ➡️ Next Project
Project 20 covers provisioners — running scripts during resource lifecycle.
