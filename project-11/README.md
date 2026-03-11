# Project 11 — Data Sources & Local Values

## 🎯 What You Will Learn
- `data` blocks — read existing infrastructure
- Auto-discovering AMIs with `aws_ami` and filters
- `aws_caller_identity` — get your account ID
- `aws_region` — get current region
- `locals {}` block — computed, reusable local values
- `merge()` function — combine maps/tag sets

## 📖 Exam Domain
- Domain 8: Data sources, locals, built-in functions

---

## 🧠 Theory: Data Sources

A **data source** reads information about **existing** infrastructure. It does NOT create anything.

```hcl
# resource = CREATE something
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# data = READ something that already exists
data "aws_vpc" "existing" {
  id = "vpc-12345678"
}
```

Reference data source values: `data.<type>.<name>.<attribute>`
```hcl
subnet_id = data.aws_vpc.existing.id
```

---

## 🧠 Theory: aws_ami Data Source

Hard-coding AMI IDs is dangerous — they change per region and expire. Use a data source to auto-discover:

```hcl
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web" {
  ami = data.aws_ami.amazon_linux.id   # always the latest AMI!
}
```

---

## 🧠 Theory: locals Block

`locals` are **computed values** you want to reuse without repeating:

```hcl
locals {
  name_prefix = "${var.project_name}-${var.environment}"
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Use locals with local.<name>
resource "aws_instance" "app" {
  tags = merge(local.common_tags, { Name = "${local.name_prefix}-server" })
}
```

**Locals vs Variables:**
| | `variable` | `local` |
|---|---|---|
| Set by user | ✅ Yes | ❌ No |
| Computed from other values | ❌ No | ✅ Yes |
| Can reference resources | ❌ No | ✅ Yes |

---

## 🧠 Theory: merge() Function

`merge()` combines maps — later values override earlier ones:

```hcl
merge(
  { Name = "server", Env = "dev" },
  { Env = "prod", Owner = "team" }
)
# Result: { Name = "server", Env = "prod", Owner = "team" }
```

Perfect for combining base tags with resource-specific tags.

---

## 🚀 How to Run

```bash
terraform init
terraform plan    # See the auto-discovered AMI ID
terraform apply
terraform output ami_id    # Shows the discovered AMI
terraform output ami_name  # Shows the AMI name like "amzn2-ami-hvm-2.0.xxx"
terraform destroy
```

## ✅ Exam Tips
> `data` blocks are READ-only — they don't create resources  
> Reference: `data.<type>.<n>.<attribute>`  
> `locals` = computed/derived values; reference with `local.<n>`  
> `data "aws_caller_identity" "current" {}` → gets account ID  
> `merge()` combines maps, later keys override earlier ones  
> Never hardcode AMI IDs — use `data "aws_ami"` with filters  

## ➡️ Next Project
Project 12 covers the Remote Backend — storing state in S3 with locking.
