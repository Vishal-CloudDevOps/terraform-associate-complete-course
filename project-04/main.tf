# ============================================================
# PROJECT 04 — Complex Variable Types + terraform.tfvars
# Learning: list, map, object variables, tfvars file
# ============================================================
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    local = { source = "hashicorp/local", version = "~> 2.4" }
  }
}
provider "local" {}

resource "local_file" "app_config" {
  filename = "${path.module}/output/config.json"
  content  = jsonencode({
    app_name    = var.app_name
    environment = var.environment
    tags        = var.tags
    db          = var.db_config
    regions     = var.regions
  })
}
