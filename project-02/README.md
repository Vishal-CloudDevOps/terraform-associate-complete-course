# Project 02 — Multiple Resources & References

## 🎯 What You Will Learn
- Creating multiple resources
- How resources reference each other (implicit dependency)
- The `depends_on` meta-argument (explicit dependency)
- `path.module` — the current directory path
- `jsonencode()` — built-in function
- Heredoc strings (`<<-EOT`)

## 📖 Exam Domain
- Domain 3: Resource behavior, meta-arguments
- Domain 8: `depends_on`, built-in functions

---

## 🧠 Theory: Resource References

When you write `random_id.app_id.hex`, you're referencing another resource's **attribute**.

**Format:** `<resource_type>.<resource_name>.<attribute>`

```hcl
resource "random_id" "app_id" {
  byte_length = 4
}

resource "local_file" "config" {
  content = random_id.app_id.hex   # ← REFERENCE
}
```

Terraform sees this reference and automatically understands:
> "I must create `random_id.app_id` BEFORE `local_file.config`"

This is called an **implicit dependency** — Terraform figures it out automatically.

---

## 🧠 Theory: Implicit vs Explicit Dependencies

### Implicit (Preferred)
Terraform auto-detects the dependency from the attribute reference:
```hcl
resource "local_file" "config" {
  content = random_id.app_id.hex   # Terraform knows: create random_id first
}
```

### Explicit (`depends_on`)
Use when the dependency exists but **isn't visible** in the config:
```hcl
resource "local_file" "readme" {
  content    = "hello"
  depends_on = [local_file.config]  # Wait for config to be created first
}
```

**Rule of thumb:** Use implicit dependencies when possible. Use `depends_on` only when necessary.

**Exam tip:** `depends_on` accepts a **list** of resource references — not strings:
```hcl
depends_on = [aws_iam_role.example, aws_s3_bucket.app]  # ✅ correct
depends_on = ["aws_iam_role.example"]                    # ❌ wrong
```

---

## 🧠 Theory: The Dependency Graph

Terraform builds an internal **dependency graph** to determine creation order:

```
random_id.app_id
      │
      ▼
local_file.config  ←── depends_on ── local_file.readme
```

Resources with no dependencies are created in **parallel** (faster deploys!).

---

## 🧠 Theory: Built-in Functions

Terraform has many built-in functions. You've seen two:

### `jsonencode(value)`
Converts a Terraform value to a JSON string:
```hcl
content = jsonencode({
  name = "myapp"
  port = 8080
})
# Output: {"name":"myapp","port":8080}
```

### `path.module`
Returns the path of the **current module directory**:
```hcl
filename = "${path.module}/output/file.txt"
```

Other useful path expressions:
| Expression | Meaning |
|---|---|
| `path.module` | Directory of the current module |
| `path.root` | Directory of the root module |
| `path.cwd` | Current working directory |

---

## 🧠 Theory: Heredoc Strings

A heredoc lets you write multi-line strings cleanly:

```hcl
content = <<-EOT
  Line one
  Line two
  Line three
EOT
```

The `-` after `<<` strips leading whitespace (indentation). EOT is just a marker — you can use any word.

---

## 🚀 How to Run

```bash
terraform init
terraform plan
terraform apply

# Check the created files
cat output/app-config.json
cat output/README.txt

# Run apply again — nothing changes (idempotency)
terraform apply

terraform destroy
```

---

## 📁 Folder Structure

```
project-02/
├── main.tf        ← Two resources + random_id
├── output/        ← Files will be created here
└── README.md
```

---

## ✅ Exam Tips
> `resource_type.resource_name.attribute` — resource reference format  
> Implicit dependency = Terraform auto-detects from attribute references  
> `depends_on` = explicit dependency, accepts a list of resource addresses  
> `jsonencode()` converts HCL maps/objects to JSON strings  
> `path.module` = directory of the current module  

## ➡️ Next Project
Project 03 introduces `variables` to stop hardcoding values.
