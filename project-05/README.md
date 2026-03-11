# Project 05 — Outputs: Exposing Values

## 🎯 What You Will Learn
- Declaring `output {}` blocks
- Viewing outputs after `apply`
- The `sensitive` output flag
- Using outputs in scripts with `-json` and `-raw`
- How outputs flow between modules

## 📖 Exam Domain
- Domain 3: Output values
- Domain 5: Module outputs

---

## 🧠 Theory: What Are Outputs?

**Outputs** are Terraform's way of **exposing values** after infrastructure is created. They're like return values from a function.

Use outputs when you want to:
1. **Display** information after apply (IPs, URLs, IDs)
2. **Pass data** to other modules
3. **Read values** in CI/CD scripts
4. **Connect stacks** using `terraform_remote_state`

---

## 🧠 Theory: Output Block Syntax

```hcl
output "output_name" {
  description = "What this output contains"
  value       = <EXPRESSION>
  sensitive   = false    # optional, default is false
}
```

---

## 🧠 Theory: Sensitive Outputs

```hcl
output "db_password" {
  value     = var.db_password
  sensitive = true
}
```

```
$ terraform output db_password
(sensitive value)

$ terraform output -raw db_password     # THIS reveals the value!
my-secret-password
```

---

## 🧠 Theory: Reading Outputs

```bash
terraform output                          # All outputs
terraform output app_id                   # Specific output
terraform output -json                    # All as JSON (great for scripts)
terraform output -raw app_id              # Raw value, no quotes
terraform output -json | jq '.app_id.value'  # Parse with jq
```

---

## 🚀 How to Run

```bash
terraform init && terraform apply

terraform output                   # See all outputs
terraform output app_id            # One output
terraform output app_token         # Shows "(sensitive value)"
terraform output -raw app_token    # Shows the actual value
terraform output -json             # JSON format
terraform destroy
```

---

## ✅ Exam Tips
> `sensitive = true` hides display but value IS in state file  
> `terraform output -json` great for automation  
> `terraform output -raw` for bare values (no quotes)  
> Module outputs: `module.<module_name>.<output_name>`  

## ➡️ Next Project
Project 06 introduces real AWS resources — our first cloud infrastructure!
