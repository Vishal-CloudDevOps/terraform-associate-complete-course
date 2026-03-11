# Project 10 — Lifecycle Meta-Arguments

## 🎯 What You Will Learn
- The `lifecycle` block on resources
- `create_before_destroy` — zero-downtime replacements
- `prevent_destroy` — protect critical resources
- `ignore_changes` — ignore external modifications
- `replace_triggered_by` — force replacement when dependencies change

## 📖 Exam Domain
- Domain 3: Resource meta-arguments
- Domain 8: Lifecycle customization

---

## 🧠 Theory: The lifecycle Block

The `lifecycle` block customizes how Terraform creates, updates, and destroys a resource:

```hcl
resource "aws_instance" "web" {
  # ...

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = true
    ignore_changes        = [tags, ami]
    replace_triggered_by  = [aws_security_group.web]
  }
}
```

---

## 🧠 Theory: create_before_destroy

**Default behavior:** Destroy old → Create new (causes downtime)
**With `create_before_destroy = true`:** Create new → Destroy old (zero downtime)

```hcl
resource "aws_instance" "web" {
  ami = var.new_ami

  lifecycle {
    create_before_destroy = true
  }
}
```

Use when:
- Replacing EC2 instances (avoid service interruption)
- Replacing SSL certificates
- Any resource where you can't afford a gap

---

## 🧠 Theory: prevent_destroy

```hcl
resource "aws_rds_cluster" "prod_db" {
  lifecycle {
    prevent_destroy = true
  }
}
```

If any `terraform plan` includes destroying this resource, Terraform will **error**:
```
Error: Instance cannot be destroyed
  on main.tf line 5, in resource "aws_rds_cluster" "prod_db":
    prevent_destroy = true
```

**Important:** `prevent_destroy = true` only blocks plans. You can still force-destroy by removing the lifecycle block first.

Use for: production databases, state buckets, critical IAM resources.

---

## 🧠 Theory: ignore_changes

```hcl
resource "aws_autoscaling_group" "app" {
  desired_capacity = 2

  lifecycle {
    ignore_changes = [desired_capacity]  # Autoscaler changes this — don't revert
  }
}
```

```hcl
lifecycle {
  ignore_changes = [tags, tags_all]  # List of attribute names
  # OR
  ignore_changes = all               # Ignore ALL changes (use very carefully!)
}
```

Use when external systems modify resource attributes you don't want Terraform to fight over.

---

## 🚀 How to Run

```bash
terraform init
terraform plan
terraform apply

# Try to destroy the critical bucket
terraform destroy -target=aws_s3_bucket.critical
# Should error: prevent_destroy = true

terraform destroy   # Full destroy (also blocked by prevent_destroy)
# To actually destroy, remove the lifecycle block first
```

## ✅ Exam Tips
> `create_before_destroy` = new resource before old is destroyed  
> `prevent_destroy = true` → Terraform ERRORS if destroy is in plan  
> `ignore_changes = [attr1, attr2]` → don't react to external changes  
> `ignore_changes = all` → ignore all changes (use carefully)  
> Lifecycle applies to the RESOURCE, not the whole config  

## ➡️ Next Project
Project 11 covers data sources — reading existing infrastructure.
