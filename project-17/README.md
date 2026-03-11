# Project 17 — Dynamic Blocks

## 🎯 What You Will Learn
- The `dynamic` block — generate repeated nested blocks from a list/map
- `for_each` inside dynamic blocks
- `content {}` block — defines what each iteration generates
- `<label>.value.<attribute>` — accessing iteration values
- When to use dynamic blocks vs for_each on resources

## 📖 Exam Domain
- Domain 8: Dynamic blocks

---

## 🧠 Theory: Why Dynamic Blocks?

Without dynamic blocks, you'd repeat yourself:
```hcl
# BAD: hardcoded, repetitive
resource "aws_security_group" "app" {
  ingress { from_port = 80;  to_port = 80;  protocol = "tcp"; ... }
  ingress { from_port = 443; to_port = 443; protocol = "tcp"; ... }
  ingress { from_port = 22;  to_port = 22;  protocol = "tcp"; ... }
}
```

With dynamic blocks, you generate them from a variable:
```hcl
# GOOD: data-driven
resource "aws_security_group" "app" {
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}
```

---

## 🧠 Theory: Dynamic Block Syntax

```hcl
dynamic "<BLOCK_TYPE>" {
  for_each = <COLLECTION>         # list or map to iterate over
  iterator = <ALIAS>              # optional: rename the iterator (default = block type name)
  content {
    # Define the block content
    # Access values with: <BLOCK_TYPE>.value.<attribute>
    # OR with iterator: <ALIAS>.value.<attribute>
  }
}
```

---

## 🧠 Theory: Dynamic Block Iterator

By default, the iterator variable is named after the block type:
```hcl
dynamic "ingress" {
  for_each = var.rules
  content {
    from_port = ingress.value.port   # "ingress" is the iterator
  }
}
```

Use `iterator` to rename it (useful for nested dynamics):
```hcl
dynamic "ingress" {
  for_each = var.rules
  iterator = rule                    # rename to "rule"
  content {
    from_port = rule.value.port      # now use "rule"
  }
}
```

---

## 🧠 Theory: Dynamic Block vs for_each on Resources

| | `for_each` on resource | `dynamic` block |
|---|---|---|
| Use for | Creating multiple separate resources | Creating multiple nested blocks in ONE resource |
| Each result | Separate resource in state | Nested block within a resource |
| Example | Multiple S3 buckets | Multiple ingress rules in one SG |

---

## 🚀 How to Run

```bash
terraform init
terraform plan   # See: 3 ingress rules generated
terraform apply

# Add a new port by modifying the variable
terraform apply -var='ingress_rules=[{"description":"HTTP","port":80,"cidr_blocks":["0.0.0.0/0"]},{"description":"Custom","port":8080,"cidr_blocks":["0.0.0.0/0"]}]'

terraform destroy
```

## ✅ Exam Tips
> `dynamic` generates repeated nested BLOCKS (not resources)  
> `for_each` on a resource creates multiple RESOURCES  
> Iterator name defaults to the block type name  
> Use `iterator` to rename the iterator variable  
> Works with: `ingress`, `egress`, `policy`, `setting`, etc.  

## ➡️ Next Project
Project 18 covers modules — packaging reusable infrastructure.
