# Project 09 — State Management

## 🎯 What You Will Learn
- What the Terraform state file is and why it exists
- `terraform state list`, `show`, `mv`, `rm`, `pull`
- State locking — preventing concurrent modifications
- Why `terraform.tfstate` must NOT be in Git
- `terraform apply -replace` (replaces deprecated `taint`)

## 📖 Exam Domain
- Domain 7: Implement and maintain state
- Domain 4: State CLI commands

---

## 🧠 Theory: What is Terraform State?

Terraform keeps a **state file** (`terraform.tfstate`) that maps your config to real infrastructure:

```
Your config:              State:                Real AWS:
──────────────────────────────────────────────────────────
aws_s3_bucket.app    →   id: "my-bucket-abc1"  →  S3 Bucket "my-bucket-abc1"
aws_iam_user.svc     →   name: "my-svc-user"   →  IAM User "my-svc-user"
```

**Why state exists:**
- Terraform must know WHAT it manages (vs pre-existing resources)
- Enables `terraform plan` to compute a diff
- Tracks metadata (e.g., dependencies)
- Improves performance (avoids querying all APIs on every run)

---

## 🧠 Theory: The State File

The state file is **JSON**. Do NOT edit it manually unless you know exactly what you're doing.

```json
{
  "version": 4,
  "terraform_version": "1.6.0",
  "resources": [
    {
      "type": "aws_s3_bucket",
      "name": "app",
      "instances": [{
        "attributes": {
          "id": "my-bucket-abc123",
          "arn": "arn:aws:s3:::my-bucket-abc123"
        }
      }]
    }
  ]
}
```

**Critical rules:**
- Store state in a **remote backend** for team use (Project 12)
- **Never commit** `terraform.tfstate` to Git — it may contain secrets
- State files should be **encrypted at rest** (S3 with SSE)

---

## 🧠 Theory: State Commands

### `terraform state list`
Shows all resources Terraform is tracking:
```bash
terraform state list
# aws_s3_bucket.app
# aws_s3_bucket.logs
# aws_iam_user.svc
# random_id.suffix
```

### `terraform state show <address>`
Shows full details of one resource:
```bash
terraform state show aws_s3_bucket.app
# resource "aws_s3_bucket" "app" {
#   id     = "tf-state-demo-app-a1b2c3d4"
#   arn    = "arn:aws:s3:::tf-state-demo-app-a1b2c3d4"
#   bucket = "tf-state-demo-app-a1b2c3d4"
#   ...
# }
```

### `terraform state mv`
Rename a resource in state WITHOUT destroying it:
```bash
# When you rename a resource in .tf, use mv to avoid destroy+create
terraform state mv aws_s3_bucket.app aws_s3_bucket.primary
```

### `terraform state rm`
Remove a resource from state WITHOUT destroying the real resource:
```bash
terraform state rm aws_iam_user.svc
# Now Terraform forgets about this user
# The real IAM user still exists in AWS
```

### `terraform state pull`
Download the raw state as JSON:
```bash
terraform state pull > backup.tfstate
terraform state pull | python3 -m json.tool   # pretty print
```

---

## 🧠 Theory: State Locking

When Terraform runs `apply` or `plan`, it **locks** the state to prevent concurrent modifications:

```
User A: terraform apply  → acquires lock → working...
User B: terraform apply  → BLOCKED: "Error acquiring state lock"
```

- **Local state:** Creates a `.terraform.tfstate.lock.info` file
- **S3 backend:** Uses a DynamoDB item for locking
- **Terraform Cloud:** Manages locking automatically

If Terraform crashes with a lock held:
```bash
terraform force-unlock LOCK_ID
```

---

## 🧠 Theory: terraform apply -replace

Forces a resource to be **destroyed and recreated**:
```bash
terraform apply -replace="aws_instance.web"
```

This replaces the old `terraform taint` command which is now **deprecated**:
```bash
terraform taint aws_instance.web   # DEPRECATED — don't use
```

---

## 🚀 How to Run

```bash
terraform init
terraform apply -auto-approve

# Inspect state
terraform state list
terraform state show aws_s3_bucket.app

# Pull state JSON
terraform state pull | python3 -m json.tool

# Rename resource (also update main.tf!)
terraform state mv aws_s3_bucket.app aws_s3_bucket.primary

# Remove from state (doesn't destroy real resource)
terraform state rm aws_iam_user.svc

# Force recreate
terraform apply -replace="aws_s3_bucket.logs"

terraform destroy -auto-approve
```

## ✅ Exam Tips
> State file maps config to real infrastructure  
> Never commit `terraform.tfstate` to Git  
> `state mv` = rename in state, no destroy  
> `state rm` = untrack, no destroy  
> `state pull` = download state JSON  
> State locking prevents concurrent `apply` runs  
> `-replace` replaces deprecated `taint`  
> `force-unlock` releases stuck locks  

## ➡️ Next Project
Project 10 covers lifecycle rules: `prevent_destroy`, `create_before_destroy`, `ignore_changes`.
