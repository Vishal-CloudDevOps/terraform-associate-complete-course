# Project 16 — Conditional Expressions

## 🎯 What You Will Learn
- The ternary operator `condition ? true_val : false_val`
- Using conditionals in `locals`
- `count = condition ? 1 : 0` — enable/disable resources
- Building environment-aware infrastructure

## 📖 Exam Domain
- Domain 8: Conditional expressions

---

## 🧠 Theory: Ternary Operator

```hcl
variable = condition ? value_if_true : value_if_false
```

```hcl
instance_type = var.environment == "prod" ? "t3.medium" : "t2.micro"
# prod  → "t3.medium"
# !prod → "t2.micro"
```

---

## 🧠 Theory: Conditional Resource Creation

```hcl
resource "aws_cloudwatch_metric_alarm" "cpu" {
  count = var.environment == "prod" ? 1 : 0
  # prod   → creates 1 alarm
  # dev    → creates 0 alarms (resource doesn't exist)
}

# Reference conditional resource safely:
output "alarm_arn" {
  value = var.environment == "prod" ? aws_cloudwatch_metric_alarm.cpu[0].arn : "N/A"
}
```

---

## 🧠 Theory: Nested Conditionals (for multiple options)

```hcl
instance_type = (
  var.environment == "prod"    ? "t3.large"  :
  var.environment == "staging" ? "t3.small"  :
  "t2.micro"                                   # default (dev)
)
```

Better with `lookup()`:
```hcl
instance_type = lookup({
  prod    = "t3.large"
  staging = "t3.small"
  dev     = "t2.micro"
}, var.environment, "t2.micro")
```

---

## 🚀 How to Run

```bash
terraform init

# Dev environment
terraform apply -var="environment=dev"
terraform output instance_count   # 1
terraform output alarm_created    # No

# Prod environment
terraform apply -var="environment=prod"
terraform output instance_count   # 3
terraform output alarm_created    # Yes

terraform destroy -var="environment=prod"
```

## ✅ Exam Tips
> `condition ? true : false` — ternary operator  
> `count = condition ? 1 : 0` → create or skip resource  
> Reference conditional resource: always check if count > 0 first  
> Locals are great for centralizing conditional logic  

## ➡️ Next Project
Project 17 covers dynamic blocks — generating repeated nested blocks.
