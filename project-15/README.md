# Project 15 — for_each: Map-Based Resource Creation

## 🎯 What You Will Learn
- `for_each` with sets and maps
- `each.key` and `each.value`
- `toset()` — converting list to set
- Filtered `for_each` with a `for` expression
- `for` expressions in outputs to transform results
- Why `for_each` is better than `count` for named resources

## 📖 Exam Domain
- Domain 8: for_each, each.key/value, for expressions

---

## 🧠 Theory: for_each vs count

The problem with `count`:
```hcl
# environments = ["dev", "staging", "prod"]
resource "aws_s3_bucket" "envs" {
  count  = length(var.environments)
  bucket = var.environments[count.index]
}
# If you remove "staging", Terraform sees:
# [0]=dev, [1]=prod ← was [2]
# Result: staging bucket deleted, prod bucket RECREATED (wrong!)
```

`for_each` uses **keys** (names), not positions:
```hcl
resource "aws_s3_bucket" "envs" {
  for_each = toset(["dev", "staging", "prod"])
  bucket   = each.key
}
# Remove "staging":
# dev   → unchanged ✅
# prod  → unchanged ✅
# staging → deleted ✅ (only staging)
```

---

## 🧠 Theory: for_each with Sets

```hcl
resource "aws_iam_user" "devs" {
  for_each = toset(["alice", "bob", "charlie"])
  name     = each.key   # each.key = each.value for sets
}
# Creates: alice, bob, charlie users
# Address: aws_iam_user.devs["alice"]
```

---

## 🧠 Theory: for_each with Maps

```hcl
variable "servers" {
  type = map(object({ type = string; count = number }))
  default = {
    "web" = { type = "t2.micro",  count = 2 }
    "db"  = { type = "t3.medium", count = 1 }
  }
}

resource "aws_instance" "servers" {
  for_each      = var.servers
  instance_type = each.value.type
  tags          = { Name = each.key }
}
# Address: aws_instance.servers["web"], aws_instance.servers["db"]
```

---

## 🧠 Theory: for Expressions (Transforming Collections)

`for` expressions create new collections:

```hcl
# List comprehension
[for s in ["a", "b", "c"] : upper(s)]
# → ["A", "B", "C"]

# Map comprehension
{ for k, v in aws_iam_user.devs : k => v.arn }
# → { alice = "arn:...", bob = "arn:...", charlie = "arn:..." }

# Filtered map
{ for k, v in var.buckets : k => v if v.versioning }
# → only buckets where versioning = true
```

---

## 🚀 How to Run

```bash
terraform init
terraform plan
terraform apply
terraform output user_arns       # map of name → ARN
terraform output bucket_arns     # map of logical name → ARN
terraform output versioned_buckets  # list of versioned bucket keys
terraform destroy
```

## ✅ Exam Tips
> `for_each` uses keys — removing one doesn't affect others  
> `count` uses indices — removing middle item shifts all subsequent  
> `each.key` = the map key or set value  
> `each.value` = the map value (for sets, same as each.key)  
> `toset()` converts list to set (removes duplicates, enables for_each)  
> Address format: `resource.name["key"]` (not `[index]`)  
> `for` expression: `{ for k, v in map : k => v if condition }`  

## ➡️ Next Project
Project 16 covers conditional expressions — environment-based logic.
