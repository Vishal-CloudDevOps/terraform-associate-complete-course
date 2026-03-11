# Project 14 — count & count.index

## 🎯 What You Will Learn
- `count` meta-argument — create N copies of a resource
- `count.index` — the current iteration number (0-based)
- Driving count with `length()` of a list
- The `count = 0` trick to conditionally create resources
- Splat expressions `[*]` to reference all instances

## 📖 Exam Domain
- Domain 8: count, count.index, splat expressions

---

## 🧠 Theory: count Meta-Argument

`count` creates multiple copies of a resource:

```hcl
resource "aws_iam_user" "team" {
  count = 3                                      # creates 3 users
  name  = "user-${count.index + 1}"             # user-1, user-2, user-3
}
```

- `count.index` starts at **0** (first = 0, second = 1, third = 2)
- Usually add `+ 1` for human-friendly naming

---

## 🧠 Theory: Referencing Counted Resources

With `count`, resources become **a list**:
```hcl
# Single instance (by index):
aws_iam_user.team[0].name   # "user-1"
aws_iam_user.team[1].name   # "user-2"

# All instances (splat expression):
aws_iam_user.team[*].name   # ["user-1", "user-2", "user-3"]

# In output:
output "all_users" {
  value = aws_iam_user.team[*].name   # outputs a list
}
```

---

## 🧠 Theory: count with list length

```hcl
variable "environments" {
  type    = list(string)
  default = ["dev", "staging", "prod"]
}

resource "aws_s3_bucket" "env_buckets" {
  count  = length(var.environments)         # 3
  bucket = "app-${var.environments[count.index]}"
  # Creates: app-dev, app-staging, app-prod
}
```

---

## 🧠 Theory: count = 0 Trick (Conditional Resource)

Use `count = 0` to completely skip creating a resource:

```hcl
resource "aws_cloudwatch_alarm" "cpu" {
  count = var.environment == "prod" ? 1 : 0  # only in prod!
  # ...
}
```

- `count = 1` → resource is created
- `count = 0` → resource is NOT created

---

## 🚀 How to Run

```bash
terraform init
terraform plan   # Notice: 3 users, 3 buckets, 1 optional
terraform apply

terraform output user_names     # ["user-1", "user-2", "user-3"]
terraform output first_user     # "user-1"

# Disable optional bucket
terraform apply -var="create_optional=false"

terraform destroy
```

## ✅ Exam Tips
> `count.index` is 0-based (first resource = index 0)  
> Splat `[*]` returns a list of all instances  
> `length(list)` = number of items  
> `count = 0` → resource not created; `count = 1` → created  
> Resources with `count` are addressed as `resource.name[N]`  
> Problem with `count`: if you remove middle item from list, all subsequent items are destroyed + recreated!  

## ➡️ Next Project
Project 15 introduces `for_each` which solves the count ordering problem.
