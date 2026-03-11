# Project 01 — Your First Terraform File

## 🎯 What You Will Learn
- What a Terraform file looks like
- The `terraform {}` block
- The `provider {}` block
- The `resource {}` block
- Running your first `terraform init`, `plan`, `apply`, `destroy`

## 📖 Exam Domain
- Domain 1: IaC concepts
- Domain 3: Terraform basics

---

## 🧠 Theory: What is Terraform?

**Terraform** is a tool that lets you describe infrastructure in text files, and then automatically creates that infrastructure for you.

Instead of clicking around in AWS, Azure, or Google Cloud — you write code, and Terraform does the clicking.

This is called **Infrastructure as Code (IaC)**.

### Why IaC?

| Old Way (Manual) | New Way (IaC with Terraform) |
|---|---|
| Click in AWS Console | Write a `.tf` file |
| Easy to forget what you did | Config is in Git — full history |
| Hard to recreate exactly | Run `terraform apply` → identical result |
| Different in dev vs prod | Same config, same result, every time |
| No review process | Pull request → code review → apply |

### Key Benefit: Idempotency
If you run `terraform apply` twice with the same config, the **second run does nothing** — because the infrastructure already matches what you described. This is called **idempotency**.

---

## 🧠 Theory: The Three Blocks

Every Terraform project has three fundamental blocks:

### Block 1: `terraform {}`
```hcl
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}
```
This block tells Terraform:
- Which **version of Terraform CLI** is required (`>= 1.5.0` means 1.5.0 or newer)
- Which **provider plugins** to download (like `local`, `aws`, `azure`)

### Block 2: `provider {}`
```hcl
provider "local" {}
```
This block **configures the provider**. A provider is a plugin that knows how to talk to a specific API or system (e.g., AWS, Azure, local filesystem).

### Block 3: `resource {}`
```hcl
resource "local_file" "hello" {
  filename = "hello.txt"
  content  = "Hello, Terraform!"
}
```
This is where you **describe the infrastructure** you want. The syntax is:
```
resource "<PROVIDER>_<TYPE>" "<YOUR_NAME>" {
  argument = value
}
```

---

## 🧠 Theory: What is a Provider?

A **provider** is a plugin that translates your Terraform config into API calls.

```
Your .tf file  →  Terraform Core  →  Provider Plugin  →  Real API
```

In this project we use the `local` provider — it creates files on your local filesystem. **No AWS account needed!** This is great for learning.

Later projects will use the `aws` provider to create real cloud resources.

---

## 🧠 Theory: HCL (HashiCorp Configuration Language)

Terraform uses **HCL** — HashiCorp Configuration Language. It looks like this:

```hcl
block_type "label_one" "label_two" {
  argument_name = "argument_value"
  number_arg    = 42
  bool_arg      = true
}
```

Rules:
- Use `=` to assign values
- Strings go in `"double quotes"`
- Comments: `#` single line, `/* */` multi-line
- Files end in `.tf`

---

## 🧠 Theory: The 5 Core Commands

```
terraform init    → Download providers
terraform validate → Check syntax
terraform plan    → Preview what will happen
terraform apply   → Make it happen
terraform destroy → Delete everything
```

Think of it like cooking:
- `init` = stock your kitchen (download ingredients/tools)
- `validate` = check the recipe makes sense
- `plan` = read the recipe, write the shopping list
- `apply` = cook the meal
- `destroy` = clean up everything

---

## 🧠 Theory: Important Files

| File | Purpose | Commit to Git? |
|---|---|---|
| `main.tf` | Your infrastructure code | ✅ Yes |
| `variables.tf` | Variable declarations | ✅ Yes |
| `outputs.tf` | Output declarations | ✅ Yes |
| `.terraform/` | Downloaded providers (auto-created) | ❌ No |
| `terraform.tfstate` | Live state of your infra | ❌ No (use remote backend) |
| `.terraform.lock.hcl` | Exact provider versions locked | ✅ Yes |

---

## 🚀 How to Run

```bash
# Step 1: Download the local provider
terraform init

# Step 2: Check syntax
terraform validate
# Expected: Success! The configuration is valid.

# Step 3: Preview — what WILL happen?
terraform plan
# You'll see: + resource "local_file" "hello" will be created

# Step 4: Do it!
terraform apply
# Type: yes
# A file called hello.txt is created!

# Step 5: Check your file
cat hello.txt
# Output: Hello, Terraform! This file was created by Terraform.

# Step 6: Run apply again (idempotency test)
terraform apply
# Output: No changes. Your infrastructure matches the configuration.

# Step 7: Clean up
terraform destroy
# The hello.txt file is deleted
```

---

## 📁 Folder Structure

```
project-01/
├── main.tf      ← Your Terraform configuration
└── README.md    ← This file
```

---

## ✅ Exam Tips
> `terraform init` must be run before any other command  
> The `local` provider is great for learning — no cloud account needed  
> Running apply twice with no changes = **no changes** (idempotency)  
> `.terraform.lock.hcl` → **commit to Git**  
> `terraform.tfstate` → **do NOT commit to Git**  
> HCL = HashiCorp Configuration Language  

---

## 💡 What Changed From Nothing to Project 01
- Created our first `.tf` file
- Used the `terraform {}`, `provider {}`, and `resource {}` blocks
- Everything is **hardcoded** — we'll improve this in the next projects

## ➡️ Next Project
Project 02 adds a second resource and shows how resources can reference each other.
