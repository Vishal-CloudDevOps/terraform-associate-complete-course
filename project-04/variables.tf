variable "app_name"    { type = string; default = "my-app" }
variable "environment" { type = string; default = "dev" }

# LIST: ordered, same type, allows duplicates
variable "regions" {
  description = "List of AWS regions"
  type        = list(string)
  default     = ["us-east-1", "us-west-2"]
}

# MAP: key-value pairs, all same value type
variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default = {
    ManagedBy   = "Terraform"
    Environment = "dev"
    Owner       = "platform-team"
  }
}

# OBJECT: named attributes each with their own type
variable "db_config" {
  description = "Database configuration"
  type = object({
    instance_class    = string
    allocated_storage = number
    multi_az          = bool
    engine_version    = string
  })
  default = {
    instance_class    = "db.t3.micro"
    allocated_storage = 20
    multi_az          = false
    engine_version    = "8.0"
  }
}

# VALIDATION: constrain allowed values
variable "environment_validated" {
  description = "Environment with validation"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment_validated)
    error_message = "Must be one of: dev, staging, prod."
  }
}

# SENSITIVE: hides the value in logs and output
variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = "changeme-not-for-production"
}
