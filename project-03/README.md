# Project 03 — Introducing Variables

## 🎯 What You Will Learn
- Declaring variables with `variable {}` blocks
- The three primitive types: `string`, `number`, `bool`
- Using `var.<name>` in your config
- Variables with and without `default` values
- The `description` argument
- How to pass variable values at runtime

## 📖 Exam Domain
- Domain 3: Input variables
- Domain 8: Variable types and precedence

---

## 🧠 Theory: Why Variables?

In Project 01 and 02, everything was **hardcoded**:
```hcl
content = "my-terraform-app"   # ← hardcoded ❌
```

Problems:
- Can't reuse for dev, staging, prod
- Must edit the code to change a value
- Secrets end up in code

**Variables** solve all of this:
```hcl
content = var.app_name   # ← parameterized ✅
```

---

## 🧠 Theory: Variable Declaration Syntax

```hcl
variable "variable_name" {
  description = "What this variable is for"    # recommended
  type        = string                          # string | number | bool
  default     = "some-default-value"            # optional
}
```

A variable WITHOUT a default **must** be provided — Terraform will prompt you interactively if it's missing:
```
var.environment
  Deployment environment (dev, staging, prod)

  Enter a value:
```

---

## 🧠 Theory: The Three Primitive Types

| Type | Example Values | Use Case |
|---|---|---|
| `string` | `"hello"`, `"us-east-1"` | Names, regions, IDs |
| `number` | `1`, `42`, `3.14` | Counts, sizes, ports |
| `bool` | `true`, `false` | Flags, toggles |

```hcl
variable "region"  { type = string; default = "us-east-1" }
variable "count"   { type = number; default = 3 }
variable "enabled" { type = bool;   default = true }
```

---

## 🧠 Theory: Using Variables — `var.<name>`

Reference a variable anywhere in your config with `var.<name>`:

```hcl
resource "local_file" "config" {
  filename = "${path.module}/${var.app_name}-config.json"
  content  = var.app_name
}
```

Inside strings, use `${}` interpolation:
```hcl
filename = "${var.app_name}-${var.environment}.json"
# If app_name="myapp" and environment="dev" → "myapp-dev.json"
```

---

## 🧠 Theory: How to Provide Variable Values

There are multiple ways (in order of lowest → highest priority):

| Method | Example | Priority |
|---|---|---|
| Default in `variable {}` | `default = "dev"` | Lowest |
| `terraform.tfvars` file | `app_name = "myapp"` | ↑ |
| `*.auto.tfvars` files | `app_name = "myapp"` | ↑ |
| `-var-file` flag | `terraform apply -var-file="prod.tfvars"` | ↑ |
| `-var` flag | `terraform apply -var="app_name=myapp"` | ↑ |
| `TF_VAR_` env variable | `export TF_VAR_app_name=myapp` | Highest |

**Exam tip:** Higher priority **overrides** lower priority. `-var` flag wins over `terraform.tfvars`.

---

## 🚀 How to Run

```bash
terraform init

# Option 1: Terraform prompts for environment
terraform apply
# Enter a value: dev

# Option 2: Pass variable on command line
terraform apply -var="environment=staging"

# Option 3: Pass multiple variables
terraform apply -var="environment=prod" -var="app_name=mywebapp" -var="replica_count=3"

# Option 4: Check output file
cat output/my-app-config.json

terraform destroy
```

---

## 📁 Folder Structure

```
project-03/
├── main.tf        ← Uses var.xxx instead of hardcoded values
├── variables.tf   ← Variable declarations (new!)
├── output/        ← Output files
└── README.md
```

---

## ✅ Exam Tips
> Variables declared in `variable {}` blocks in `variables.tf` (by convention)  
> `var.<name>` to reference a variable  
> No `default` = Terraform prompts at runtime  
> `-var` flag has highest priority (overrides everything)  
> `TF_VAR_<name>` env vars work great for CI/CD pipelines  
> Primitive types: `string`, `number`, `bool`  

## ➡️ Next Project
Project 04 introduces complex variable types: lists, maps, and objects.
