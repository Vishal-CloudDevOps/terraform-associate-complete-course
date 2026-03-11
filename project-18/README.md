# Project 18 — Terraform Modules

## 🎯 What You Will Learn
- Creating and calling local modules
- Module inputs (variables) and outputs
- `module.<name>.<output>` — reading child module outputs
- Module source types (local, registry, git)
- `terraform init` downloading modules
- The root module concept

## 📖 Exam Domain
- Domain 5: Modules (entire domain)

---

## 🧠 Theory: What is a Module?

A module is a **folder containing `.tf` files** that you call from another config. Every Terraform project is itself the **root module**.

```
project-18/         ← ROOT MODULE
├── main.tf
├── variables.tf
├── outputs.tf
└── modules/
    ├── security-group/   ← CHILD MODULE
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── ec2-instance/     ← CHILD MODULE
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## 🧠 Theory: Calling a Module

```hcl
module "web_sg" {
  source = "./modules/security-group"   # required

  # Pass values to the module's input variables
  name = "web-sg"
  ingress_rules = [...]
}
```

Reading the module's outputs:
```hcl
# module.<module_name>.<output_name>
resource "aws_instance" "web" {
  vpc_security_group_ids = [module.web_sg.security_group_id]
}
```

---

## 🧠 Theory: Module Sources

| Source | Example | Versioning |
|---|---|---|
| Local path | `"./modules/vpc"` | Not supported |
| Terraform Registry | `"hashicorp/consul/aws"` | Supported |
| GitHub | `"github.com/org/repo"` | `?ref=v1.0` |
| Git URL | `"git::https://..."` | `?ref=tag` |
| S3 | `"s3::https://..."` | Not supported |

---

## 🧠 Theory: `terraform init` and Modules

```bash
terraform init     # Downloads providers AND modules
terraform get      # Only download modules (no providers)
terraform get -update  # Update cached modules
```

Local modules are referenced by path. Remote modules are cached in `.terraform/modules/`.

---

## 🧠 Theory: Module Best Practices

1. Every module should have `variables.tf`, `outputs.tf`, `main.tf`
2. Add `README.md` to each module
3. Don't hardcode values inside modules — use variables
4. Keep modules focused (single responsibility)
5. Version pin registry modules: `version = "~> 5.0"`

---

## 🚀 How to Run

```bash
terraform init    # Downloads local modules (instantaneous for local)
terraform plan
terraform apply
terraform output
terraform destroy
```

## ✅ Exam Tips
> Root module = your working directory  
> Child module = any module called with `module {}` block  
> `module.<name>.<output>` accesses child module outputs  
> `terraform init` downloads both providers and modules  
> Local modules: relative path `"./modules/name"`  
> Registry modules need `version` constraint  
> `terraform get` downloads modules only  

## ➡️ Next Project
Project 19 covers import — bringing existing infra under Terraform control.
