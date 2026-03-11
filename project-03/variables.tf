# ============================================================
# variables.tf — All variable declarations go here
# ============================================================

# String variable — basic text
variable "app_name" {
  description = "The name of the application"
  type        = string
  default     = "my-app"
}

# String variable — must be supplied (no default!)
variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  # No default → Terraform will ASK you for this when you run apply
  # Unless you set it in terraform.tfvars or with -var flag
}

# Number variable
variable "replica_count" {
  description = "How many replicas to run"
  type        = number
  default     = 1
}

# Boolean variable
variable "debug_mode" {
  description = "Enable debug logging"
  type        = bool
  default     = false
}
