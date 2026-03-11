# Project 04 — Complex Variable Types & terraform.tfvars

## 🎯 What You Will Learn
- `list`, `map`, `object` variable types
- Accessing elements in lists and maps
- Variable `validation` blocks
- `sensitive` variables
- The `terraform.tfvars` file — setting values outside of code

## 📖 Exam Domain
- Domain 3: Variable types
- Domain 8: Type constraints, sensitive variables

---

## 🧠 Theory: Complex Variable Types

### `list(type)` — Ordered, allows duplicates
```hcl
variable "regions" {
  type    = list(string)
  default = ["us-east-1", "us-west-2", "eu-west-1"]
}

# Access by index (starts at 0)
var.regions[0]   # "us-east-1"
var.regions[1]   # "us-west-2"
```

### `set(type)` — Unordered, NO duplicates
```hcl
variable "allowed_ips" {
  type    = set(string)
  default = ["10.0.0.1", "10.0.0.2"]
}
# Sets are unordered — you can't access by index
```

### `map(type)` — Key-value pairs, same value type
```hcl
variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Owner       = "team"
  }
}

# Access by key
var.tags["Environment"]   # "dev"
var.tags["Owner"]         # "team"
```

### `object({})` — Named attributes, each with their own type
```hcl
variable "db_config" {
  type = object({
    instance_class    = string
    allocated_storage = number
    multi_az          = bool
  })
}

# Access by attribute name
var.db_config.instance_class     # "db.t3.micro"
var.db_config.allocated_storage  # 20
var.db_config.multi_az           # false
```

### Type Comparison Table
| Type | Ordered | Unique Values | Mixed Types |
|---|---|---|---|
| `list` | ✅ | ❌ | ❌ |
| `set` | ❌ | ✅ | ❌ |
| `map` | ❌ | keys only | ❌ |
| `object` | N/A | N/A | ✅ |
| `tuple` | ✅ | ❌ | ✅ |

---

## 🧠 Theory: Variable Validation

Add `validation` blocks to enforce rules:
```hcl
variable "environment" {
  type    = string
  default = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Must be one of: dev, staging, prod."
  }
}
```

If the condition is false, Terraform will error with your message before touching any infrastructure.

---

## 🧠 Theory: Sensitive Variables

```hcl
variable "db_password" {
  type      = string
  sensitive = true
}
```

With `sensitive = true`:
- Value is **hidden** in `terraform plan` output: `(sensitive value)`
- Value is **hidden** in `terraform apply` output
- Value **IS** stored in the state file (state must be encrypted!)
- `terraform output` also shows `(sensitive value)`

---

## 🧠 Theory: terraform.tfvars

`terraform.tfvars` is a special file that **Terraform auto-loads** to set variable values:

```hcl
# terraform.tfvars
app_name    = "awesome-app"
environment = "dev"

tags = {
  Environment = "dev"
  Owner       = "your-name"
}
```

You can also have environment-specific files:
```bash
terraform apply -var-file="prod.tfvars"   # load specific file
```

Files named `*.auto.tfvars` are also auto-loaded (alphabetically).

---

## 🧠 Theory: Variable Precedence (Low → High)

```
1. Default in variable {} block
2. terraform.tfvars
3. *.auto.tfvars (alphabetical order)
4. -var-file="custom.tfvars"
5. -var="key=value"
6. TF_VAR_<n> environment variable  ← HIGHEST
```

Higher wins. `-var` on the command line always beats `terraform.tfvars`.

---

## 🚀 How to Run

```bash
terraform init

# Uses terraform.tfvars automatically
terraform apply

# Override specific values
terraform apply -var="environment=prod"

# Check what was generated
cat output/config.json

# Pass sensitive value securely
export TF_VAR_db_password="my-secure-password"
terraform apply

terraform destroy
```

---

## 📁 Folder Structure

```
project-04/
├── main.tf            ← Uses complex variables
├── variables.tf       ← list, map, object, validated, sensitive
├── terraform.tfvars   ← Variable values (auto-loaded)
├── output/
└── README.md
```

---

## ✅ Exam Tips
> `list` = ordered, allows duplicates; access by index `[0]`  
> `set` = unordered, unique values; cannot access by index  
> `map` = key-value pairs; access by key `["keyname"]`  
> `object` = named typed attributes; access by name `.attribute`  
> `sensitive = true` hides value in output but NOT in state  
> `terraform.tfvars` is **auto-loaded**; `*.auto.tfvars` also auto-loaded  
> Validation `condition` uses Terraform expressions  

## ➡️ Next Project
Project 05 introduces `outputs.tf` — exposing values from your config.
