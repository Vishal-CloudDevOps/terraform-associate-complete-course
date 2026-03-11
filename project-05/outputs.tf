# Basic output
output "app_id" {
  description = "The unique application ID"
  value       = random_id.app_id.hex
}

# Output with expression
output "config_path" {
  description = "Full path to the config file"
  value       = local_file.config.filename
}

# Output a computed string
output "app_url" {
  description = "Simulated application URL"
  value       = "https://${var.app_name}.${var.environment}.example.com"
}

# Sensitive output — hidden in terminal
output "app_token" {
  description = "Secret app token — do not share"
  value       = random_id.token.hex
  sensitive   = true
}

# Output a map
output "app_info" {
  description = "Map of app metadata"
  value = {
    name        = var.app_name
    environment = var.environment
    id          = random_id.app_id.hex
  }
}
