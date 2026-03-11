# ============================================================
# PROJECT 01 — Your First Terraform File (Hardcoded)
# Learning: terraform block, provider block, first resource
# EVERYTHING is hardcoded here intentionally.
# We will slowly move to variables in later projects.
# ============================================================

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

# This provider needs no API keys — perfect for learning!
provider "local" {}

# Our first resource: create a file on disk
resource "local_file" "hello" {
  filename = "${path.module}/hello.txt"
  content  = "Hello, Terraform! This file was created by Terraform."
}
