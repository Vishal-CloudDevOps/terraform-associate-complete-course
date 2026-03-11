# 🏗️ Terraform Associate Exam — Complete Study Course
## 22 Progressive Projects with Full Theory

---

## 📚 Course Overview

This course takes you from **zero to exam-ready** through 22 hands-on projects. Every topic on the HashiCorp Terraform Associate exam is covered with theory, code, and practice.

**Learning Philosophy:**
- Start with hardcoded values (Projects 01–02)
- Introduce variables slowly (Projects 03–05)
- Apply to real AWS resources (Projects 06–07)
- Cover all CLI tools (Projects 08–09)
- Advanced features (Projects 10–21)
- Capstone project (Project 22)

---

## 🗺️ Exam Domain Map

| Exam Domain | Projects |
|---|---|
| Domain 1: IaC Concepts | 01 |
| Domain 2: Terraform Purpose | 01 |
| Domain 3: Terraform Basics (providers, resources, variables, outputs) | 02–07 |
| Domain 4: Terraform CLI (fmt, validate, plan, apply, state, import, workspaces) | 08, 09, 12, 13, 19 |
| Domain 5: Modules | 18 |
| Domain 6: Core Workflow | 08 |
| Domain 7: State Management | 09, 12 |
| Domain 8: Configuration Language (locals, data, count, for_each, dynamic, conditionals, lifecycle, provisioners, moved, check) | 10–17, 20–21 |

---

## 📋 Project Index

| # | Title | Level | Key Concepts | Cloud? |
|---|---|---|---|---|
| 01 | Your First Terraform File | 🟢 Beginner | terraform block, provider, resource, init/plan/apply | ❌ Local only |
| 02 | Multiple Resources & References | 🟢 Beginner | Resource references, implicit/explicit deps, jsonencode | ❌ Local only |
| 03 | Introducing Variables | 🟢 Beginner | variable block, string/number/bool, var.name, defaults | ❌ Local only |
| 04 | Complex Variable Types + tfvars | 🟢 Beginner | list, map, object, validation, sensitive, tfvars | ❌ Local only |
| 05 | Outputs | 🟢 Beginner | output block, sensitive, -json, -raw | ❌ Local only |
| 06 | First AWS Resource (Hardcoded) | 🟡 Intermediate | aws provider, aws_s3_bucket, tags | ✅ AWS |
| 07 | AWS + Variables + Outputs + tfvars | 🟡 Intermediate | default_tags, random_id, conditional expression intro | ✅ AWS |
| 08 | Full CLI Workflow | 🟡 Intermediate | fmt, validate, plan flags, apply flags, exit codes | ✅ AWS |
| 09 | State Management | 🟡 Intermediate | state list/show/mv/rm/pull, locking, replace | ✅ AWS |
| 10 | Lifecycle Rules | 🟡 Intermediate | create_before_destroy, prevent_destroy, ignore_changes | ✅ AWS |
| 11 | Data Sources & Locals | 🟡 Intermediate | data blocks, aws_ami filter, locals, merge() | ✅ AWS |
| 12 | Remote Backend | 🟡 Intermediate | S3 backend, DynamoDB locking, -migrate-state | ✅ AWS |
| 13 | Workspaces | 🟡 Intermediate | workspace new/select/list, terraform.workspace, lookup() | ✅ AWS |
| 14 | count & count.index | 🔴 Advanced | count, count.index, splat [*], length(), count=0 trick | ✅ AWS |
| 15 | for_each with Maps & Sets | 🔴 Advanced | for_each, each.key/value, toset(), for expressions | ✅ AWS |
| 16 | Conditional Expressions | 🔴 Advanced | ternary operator, environment-based logic | ✅ AWS |
| 17 | Dynamic Blocks | 🔴 Advanced | dynamic, for_each, content{}, iterator | ✅ AWS |
| 18 | Modules | 🔴 Advanced | local modules, module{}, inputs/outputs, registry | ✅ AWS |
| 19 | Resource Import | 🔴 Advanced | terraform import, import{} block, -generate-config-out | ✅ AWS |
| 20 | Provisioners | 🔴 Advanced | local-exec, remote-exec, file, when=destroy | ✅ AWS |
| 21 | moved, check & Conditions | 🔴 Advanced | moved{}, check{}, precondition, postcondition | ✅ AWS |
| 22 | Capstone Full-Stack | 🔴 Advanced | ALL concepts combined | ✅ AWS |

---

## 🧠 Full Theory Reference

### Chapter 1: Infrastructure as Code (IaC)

**What is IaC?**
Infrastructure as Code means managing infrastructure through machine-readable files instead of manual processes.

**Benefits:**
- **Automation** — no manual steps, reduces human error
- **Version Control** — track every change in Git
- **Idempotency** — running the same config twice produces the same result
- **Consistency** — dev, staging, prod are identical
- **Reusability** — modules share config across teams
- **Self-documenting** — config describes the infrastructure

**IaC Approaches:**
- **Declarative** — describe WHAT you want (Terraform, CloudFormation, Pulumi)
- **Imperative** — describe HOW to get there (Ansible, shell scripts)

**Terraform is declarative** — you describe the end state, Terraform figures out how to get there.

**Terraform vs Other Tools:**
| Tool | Type | Cloud | State |
|---|---|---|---|
| Terraform | Declarative | Multi-cloud | Yes (tfstate) |
| CloudFormation | Declarative | AWS only | Managed by AWS |
| Ansible | Mostly imperative | Multi | No |
| Pulumi | Declarative | Multi-cloud | Yes |

---

### Chapter 2: Core Terraform Concepts

**Providers** — plugins that communicate with APIs (AWS, Azure, GCP, local, etc.)
```hcl
terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}
provider "aws" { region = "us-east-1" }
```

**Resources** — the infrastructure objects you manage
```hcl
resource "aws_s3_bucket" "app" {
  bucket = "my-app-bucket"
}
```

**Variables** — parameterize your configuration
```hcl
variable "region" { type = string; default = "us-east-1" }
```

**Outputs** — expose values after apply
```hcl
output "bucket_arn" { value = aws_s3_bucket.app.arn }
```

**Data Sources** — read-only queries to existing infrastructure
```hcl
data "aws_vpc" "default" { default = true }
```

**Locals** — computed, reusable values
```hcl
locals { name_prefix = "${var.project}-${var.env}" }
```

**Modules** — reusable grouped configurations
```hcl
module "vpc" { source = "./modules/vpc"; cidr = "10.0.0.0/16" }
```

---

### Chapter 3: Version Constraints

| Operator | Meaning | Example |
|---|---|---|
| `= 5.0.0` | Exactly this version | `= 5.0.0` |
| `!= 5.0.0` | Any version except this | `!= 4.0.0` |
| `>= 5.0.0` | This version or newer | `>= 1.5.0` |
| `~> 5.0` | >= 5.0, < 6.0 (pessimistic) | `~> 5.0` |
| `~> 5.0.1` | >= 5.0.1, < 5.1 (patch only) | `~> 5.0.1` |

**`~>` is the pessimistic constraint operator** — most common in real-world use.

---

### Chapter 4: Variable Types Quick Reference

| Type | Example | Access |
|---|---|---|
| `string` | `"us-east-1"` | `var.name` |
| `number` | `42` | `var.count` |
| `bool` | `true` | `var.enabled` |
| `list(string)` | `["a","b","c"]` | `var.list[0]` |
| `set(string)` | `{"a","b","c"}` | Cannot index |
| `map(string)` | `{key = "val"}` | `var.map["key"]` |
| `object({})` | `{name=string}` | `var.obj.name` |
| `tuple([])` | `[string, number]` | `var.t[0]` |
| `any` | anything | varies |

**Variable Precedence (Low → High):**
1. Default in `variable {}` block
2. `terraform.tfvars`
3. `*.auto.tfvars` (alphabetical)
4. `-var-file` flag
5. `-var` flag
6. `TF_VAR_<n>` environment variable

---

### Chapter 5: The Core Workflow

```
terraform init        → Download providers/modules, configure backend
terraform fmt         → Format code to canonical style
terraform validate    → Check syntax and internal consistency
terraform plan        → Preview changes (-out=file to save)
terraform apply       → Execute changes (-auto-approve for CI)
terraform destroy     → Remove all managed resources
```

**Plan symbols:**
- `+` = will be created
- `-` = will be destroyed
- `~` = will be updated in place
- `-/+` = will be destroyed and recreated

**Exit codes (with -detailed-exitcode):**
- `0` = success, no changes
- `1` = error
- `2` = success, changes pending

---

### Chapter 6: State Management

State maps config → real infrastructure. Stored in `terraform.tfstate`.

**Never commit `terraform.tfstate` to Git** — use remote backend.
**Do commit `.terraform.lock.hcl`** — pins provider versions.

**State commands:**
```bash
terraform state list                    # list all resources
terraform state show <address>          # show one resource
terraform state mv <old> <new>          # rename (no destroy)
terraform state rm <address>            # untrack (no destroy)
terraform state pull                    # download as JSON
terraform apply -replace=<address>      # force recreation
terraform force-unlock <LOCK_ID>        # release stuck lock
```

**Remote Backend (S3):**
```hcl
terraform {
  backend "s3" {
    bucket         = "my-state-bucket"
    key            = "project/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
```

---

### Chapter 7: Lifecycle Meta-Arguments

```hcl
lifecycle {
  create_before_destroy = true   # new resource created before old destroyed
  prevent_destroy       = true   # error if plan includes destroy
  ignore_changes        = [tags] # ignore external changes to these attrs
  replace_triggered_by  = [...]  # replace when other resource changes
}
```

---

### Chapter 8: count vs for_each

| | `count` | `for_each` |
|---|---|---|
| Index by | Number (position) | Key (name) |
| Remove middle item | Destroys + recreates all after | Only removes that item |
| Best for | Identical copies | Named, distinct resources |
| Address | `resource.name[0]` | `resource.name["key"]` |
| Splat | `resource.name[*].attr` | `values(resource.name)[*].attr` |

---

### Chapter 9: Modules Quick Reference

```hcl
# Calling a module
module "vpc" {
  source  = "./modules/vpc"        # local path
  # OR
  source  = "hashicorp/vpc/aws"    # registry
  version = "~> 5.0"               # required for registry

  cidr_block = "10.0.0.0/16"       # input variable
}

# Reading module outputs
module.vpc.vpc_id                  # module.<name>.<output>
```

**Module structure:**
```
modules/my-module/
├── main.tf       ← resources
├── variables.tf  ← inputs
├── outputs.tf    ← outputs
└── README.md     ← documentation
```

---

### Chapter 10: Exam Quick-Fire Tips

> ✅ `terraform init` must run before any other command  
> ✅ `.terraform.lock.hcl` → commit to Git  
> ✅ `terraform.tfstate` → do NOT commit to Git  
> ✅ `~>` = pessimistic constraint operator  
> ✅ `sensitive = true` hides in output but NOT in state  
> ✅ `-auto-approve` skips yes/no prompt  
> ✅ `terraform destroy` = `terraform apply -destroy`  
> ✅ `-replace` replaces deprecated `taint`  
> ✅ `count.index` is 0-based  
> ✅ `for_each` with sets: `toset(list_var)`  
> ✅ `each.key` = key for maps, value for sets  
> ✅ `dynamic` generates nested blocks (not separate resources)  
> ✅ `moved {}` block prevents destroy+create on rename  
> ✅ `check {}` block = non-fatal assertion (warning only)  
> ✅ `precondition` = fatal, before creation  
> ✅ `postcondition` = fatal, after creation, uses `self`  
> ✅ Workspaces: `terraform.workspace` built-in value  
> ✅ S3 backend DynamoDB table needs `LockID` as hash key (type `S`)  
> ✅ Provisioners = last resort; prefer user_data, SSM, Packer  
> ✅ Import does NOT auto-generate `.tf` files (classic method)  
> ✅ `terraform plan -generate-config-out=file.tf` auto-generates config (1.6+)  

---

## 🚀 Getting Started

```bash
# Prerequisites
brew install terraform   # macOS
# OR
# Download from https://developer.hashicorp.com/terraform/downloads

# Verify installation
terraform version

# Start with Project 01 (no AWS needed!)
cd project-01
terraform init
terraform validate
terraform plan
terraform apply
cat hello.txt
terraform destroy
```

---

## 📝 Exam Registration

- **Exam:** HashiCorp Terraform Associate (003)
- **Duration:** 1 hour
- **Questions:** ~57 questions
- **Format:** Multiple choice, multi-select, true/false
- **Pass score:** ~70%
- **Register:** [https://www.hashicorp.com/certification/terraform-associate](https://www.hashicorp.com/certification/terraform-associate)
