# ============================================================
# PROJECT 02 — Multiple Resources & References (Hardcoded)
# Learning: multiple resources, resource references,
#           implicit/explicit dependencies, path.module
# Still HARDCODED — no variables yet!
# ============================================================

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    local  = { source = "hashicorp/local",  version = "~> 2.4" }
    random = { source = "hashicorp/random", version = "~> 3.5" }
  }
}

provider "local"  {}
provider "random" {}

# Resource 1: generate a random ID
resource "random_id" "app_id" {
  byte_length = 4
}

# Resource 2: create a config file — REFERENCES random_id above
# When Terraform sees random_id.app_id.hex it automatically knows:
# "I must create random_id.app_id BEFORE local_file.config"
# This is called an IMPLICIT DEPENDENCY
resource "local_file" "config" {
  filename = "${path.module}/output/app-config.json"
  content  = jsonencode({
    app_name    = "my-terraform-app"
    app_id      = random_id.app_id.hex
    environment = "dev"
    version     = "1.0.0"
    created_by  = "terraform"
  })
}

# Resource 3: create a README — uses EXPLICIT dependency (depends_on)
# This file doesn't reference config directly, but we want it created after
resource "local_file" "readme" {
  filename = "${path.module}/output/README.txt"
  content  = <<-EOT
    Application Setup
    =================
    App ID   : ${random_id.app_id.hex}
    App Name : my-terraform-app
    Created  : by Terraform
  EOT

  # Explicit dependency — we want this AFTER config is created
  depends_on = [local_file.config]
}
