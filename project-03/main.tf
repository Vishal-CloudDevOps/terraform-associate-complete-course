# ============================================================
# PROJECT 03 — Introducing Variables
# Learning: variable blocks, string/number/bool types,
#           using var.<name>, default values
# Moving from hardcoded to parameterized!
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

resource "random_id" "app_id" {
  byte_length = 4
}

# Now using var.app_name instead of hardcoded "my-terraform-app"
resource "local_file" "config" {
  filename = "${path.module}/output/${var.app_name}-config.json"
  content  = jsonencode({
    app_name    = var.app_name
    app_id      = random_id.app_id.hex
    environment = var.environment
    debug_mode  = var.debug_mode
    replicas    = var.replica_count
  })
}
