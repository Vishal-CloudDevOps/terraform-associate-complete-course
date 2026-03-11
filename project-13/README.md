# Project 13 — Workspaces

## 🎯 What You Will Learn
- What Terraform workspaces are
- `terraform workspace new/select/list/show/delete`
- The built-in `terraform.workspace` value
- Using `lookup()` for workspace-based configs
- When to use workspaces vs directory-based environments

## 📖 Exam Domain
- Domain 4: Workspaces
- Domain 7: Workspace state isolation

---

## 🧠 Theory: What are Workspaces?

Workspaces provide **isolated state environments** within the same Terraform config. Each workspace has its **own state file**.

```
.terraform/
terraform.tfstate           ← default workspace
terraform.tfstate.d/
├── dev/terraform.tfstate   ← dev workspace
├── staging/terraform.tfstate
└── prod/terraform.tfstate
```

Same config, different data, different resources.

---

## 🧠 Theory: terraform.workspace

Built-in value — returns the current workspace name:
```hcl
resource "aws_s3_bucket" "app" {
  bucket = "my-app-${terraform.workspace}-bucket"
  # dev     → "my-app-dev-bucket"
  # prod    → "my-app-prod-bucket"
}
```

---

## 🧠 Theory: Workspace Commands

```bash
terraform workspace list              # List all workspaces (* = current)
terraform workspace show              # Show current workspace
terraform workspace new dev           # Create AND switch to 'dev'
terraform workspace select prod       # Switch to 'prod'
terraform workspace delete staging    # Delete workspace (must be empty)
```

---

## 🧠 Theory: Workspace vs Directory

| | Workspaces | Directories |
|---|---|---|
| State isolation | ✅ Each workspace = own state | ✅ Each dir = own state |
| Config shared | ✅ Yes | ❌ Copied per env |
| Config differences | ❌ Hard to vary significantly | ✅ Each dir can differ |
| Best for | Same infra, different sizes | Different configs per env |

---

## 🚀 How to Run

```bash
terraform init

# Dev workspace
terraform workspace new dev
terraform apply -auto-approve
terraform output instance_count    # 1

# Prod workspace
terraform workspace new prod
terraform apply -auto-approve
terraform output instance_count    # 3

# List workspaces
terraform workspace list
# default
# * dev    (current)
# prod

# Switch and check
terraform workspace select default
terraform workspace show

# Cleanup
terraform workspace select dev && terraform destroy -auto-approve
terraform workspace select prod && terraform destroy -auto-approve
```

## ✅ Exam Tips
> Default workspace is always named `default`  
> `terraform workspace new` creates AND switches  
> Each workspace has isolated state  
> `terraform.workspace` = built-in, returns workspace name  
> `lookup(map, key, default)` — returns map value or default if key missing  
> Workspaces store state locally in `terraform.tfstate.d/<workspace>/`  

## ➡️ Next Project
Project 14 covers the `count` and `count.index` meta-arguments.
