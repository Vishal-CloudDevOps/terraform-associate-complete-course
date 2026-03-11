# Project 21 — moved Blocks, check Blocks & Conditions

## 🎯 What You Will Learn
- `moved {}` block — rename resources without destroying them
- `check {}` block — non-fatal assertions
- `precondition` — validate before creation
- `postcondition` — validate after creation
- When to use each

## 📖 Exam Domain
- Domain 8: moved blocks, check blocks, conditions

---

## 🧠 Theory: moved Block (Terraform 1.1+)

When you rename a resource in your config, Terraform sees it as:
- Old name → **delete**
- New name → **create**

This destroys real infrastructure! Use `moved` to prevent this:

```hcl
moved {
  from = aws_s3_bucket.app         # old name in state
  to   = aws_s3_bucket.application # new name in config
}
```

Terraform then **moves** the state entry instead of delete+create.

**After applying:** remove the `moved` block (or leave it as documentation).

```hcl
# Also works for moving into/out of modules:
moved {
  from = aws_s3_bucket.app
  to   = module.storage.aws_s3_bucket.app
}
```

---

## 🧠 Theory: check Block (Terraform 1.5+)

A `check` block is a **non-fatal assertion** — it warns but doesn't stop apply:

```hcl
check "health_check" {
  data "http" "app" {
    url = "https://myapp.example.com/health"
  }

  assert {
    condition     = data.http.app.status_code == 200
    error_message = "App health check failed — status ${data.http.app.status_code}"
  }
}
```

Use for: post-deployment verification, HTTP health checks, value assertions.

---

## 🧠 Theory: Preconditions & Postconditions

**Precondition** — checked BEFORE the resource is created:
```hcl
resource "aws_instance" "app" {
  ami = var.ami_id

  lifecycle {
    precondition {
      condition     = data.aws_ami.selected.architecture == "x86_64"
      error_message = "AMI must be x86_64 architecture."
    }
  }
}
```

**Postcondition** — checked AFTER the resource is created:
```hcl
resource "aws_s3_bucket" "app" {
  bucket = var.bucket_name

  lifecycle {
    postcondition {
      condition     = self.bucket == var.bucket_name
      error_message = "Bucket name mismatch after creation."
    }
  }
}
```

---

## 🧠 Theory: Conditions Comparison

| Type | When | Fatal? | Use For |
|---|---|---|---|
| `validation` on variable | Before plan | ✅ Yes | Input value validation |
| `precondition` | Before resource creation | ✅ Yes | Pre-creation checks |
| `postcondition` | After resource creation | ✅ Yes | Post-creation validation |
| `check` block | During plan/apply | ❌ No (warning) | Non-critical assertions |

---

## 🚀 How to Run

```bash
terraform init

# Test variable validation
terraform plan -var="bucket_name=AB"   # fails: too short

# Normal run
terraform plan
terraform apply

# Test check block (change bucket name to uppercase)
terraform plan -var="bucket_name=MY-UPPERCASE-BUCKET"

terraform destroy
```

## ✅ Exam Tips
> `moved` block prevents destroy+create when renaming resources  
> `moved` works for modules: `from = resource.name`, `to = module.name.resource.name`  
> `check` block = non-fatal assertion (warning only)  
> `precondition` = fatal check BEFORE resource creation  
> `postcondition` = fatal check AFTER resource creation, uses `self`  
> `validation` on variable = earliest check, before anything happens  

## ➡️ Next Project
Project 22 is the capstone — all 22 concepts combined in a production-ready full-stack app.
