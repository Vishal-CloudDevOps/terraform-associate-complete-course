# Project 08 — Full CLI Workflow & Commands

## 🎯 What You Will Learn
- Every important Terraform CLI command
- `terraform fmt` — formatting and why it matters
- `terraform validate` — catching errors before plan
- `terraform plan` flags: `-out`, `-target`, `-var`, `-refresh=false`
- `terraform apply` flags: `-auto-approve`, saved plans
- Exit codes for CI/CD pipelines

## 📖 Exam Domain
- Domain 4: Use the Terraform CLI
- Domain 6: Core workflow

---

## 🧠 Theory: The Workflow in Detail

```
Write .tf files
     ↓
terraform fmt        ← format code
     ↓
terraform init       ← download providers/modules
     ↓
terraform validate   ← check syntax
     ↓
terraform plan       ← preview changes
     ↓
terraform apply      ← make changes
     ↓
terraform destroy    ← clean up
```

---

## 🧠 Theory: terraform fmt

Terraform enforces a **canonical code style**. `terraform fmt` auto-formats your files:

```hcl
# Before fmt:
variable "name"{type="string"
default="hello"}

# After fmt:
variable "name" {
  type    = string
  default = "hello"
}
```

For **CI/CD**, use:
```bash
terraform fmt -check   # exits with code 1 if any file needs formatting
```

---

## 🧠 Theory: Saved Plans (Best Practice)

```bash
# Step 1: Create and save the plan
terraform plan -out=tfplan

# Step 2: Review the plan (in PR, code review, etc.)
terraform show tfplan

# Step 3: Apply EXACTLY what was reviewed — no re-planning
terraform apply tfplan
```

**Why this matters:** Without saved plans, a new `apply` re-plans and might do something different from what you reviewed. Saved plans guarantee what was reviewed = what gets applied.

---

## 🧠 Theory: Exit Codes

```bash
terraform plan -detailed-exitcode
echo $?
# 0 = success, no changes needed
# 1 = error
# 2 = success, changes are needed
```

This is used in CI/CD pipelines to detect whether infrastructure changes are pending.

---

## 🧠 Theory: -target Flag

```bash
terraform apply -target=aws_s3_bucket.demo
```

Applies changes to ONLY that resource (and its dependencies).

⚠️ **Warning:** Terraform will remind you this is not normal usage. Use `-target` only for emergency fixes, not regular workflow.

---

## 🚀 How to Run

```bash
# See badly formatted file
cat badly_formatted.tf

# Fix it
terraform fmt

# Initialize
terraform init

# Validate
terraform validate

# Plan with saved output
terraform plan -out=tfplan

# Show the saved plan
terraform show tfplan

# Apply the saved plan
terraform apply tfplan

# See all outputs
terraform output

# Clean up
terraform destroy -auto-approve
```

## ✅ Exam Tips
> `terraform fmt -check` for CI — fails if formatting needed  
> `terraform plan -out=file` + `terraform apply file` = reviewed plan applied exactly  
> `-auto-approve` skips the yes/no prompt  
> `-target` for emergencies only  
> Exit codes: 0=ok/no changes, 1=error, 2=changes pending (with `-detailed-exitcode`)  
> `terraform destroy` = `terraform apply -destroy`  

## ➡️ Next Project
Project 09 introduces state management — the most important internal concept.
