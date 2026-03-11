variable "aws_region"   { type = string; default = "us-east-1" }
variable "project_name" { type = string; default = "tf-aws-demo" }
variable "environment"  { type = string; default = "dev"
  validation {
    condition     = contains(["dev","staging","prod"], var.environment)
    error_message = "Must be dev, staging, or prod."
  }
}
variable "enable_versioning" { type = bool; default = true }
variable "common_tags" {
  type = map(string)
  default = { ManagedBy = "Terraform"; Project = "project-07" }
}
