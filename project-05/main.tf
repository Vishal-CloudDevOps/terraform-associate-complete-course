terraform {
  required_version = ">= 1.5.0"
  required_providers {
    local  = { source = "hashicorp/local",  version = "~> 2.4" }
    random = { source = "hashicorp/random", version = "~> 3.5" }
  }
}
provider "local"  {}
provider "random" {}

resource "random_id" "app_id"   { byte_length = 4 }
resource "random_id" "token"    { byte_length = 16 }

resource "local_file" "config" {
  filename = "${path.module}/output/app.json"
  content  = jsonencode({
    app_name = var.app_name
    app_id   = random_id.app_id.hex
  })
}
