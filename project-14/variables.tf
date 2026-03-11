variable "aws_region"      { type = string; default = "us-east-1" }
variable "project_name"    { type = string; default = "tf-count" }
variable "environments"    { type = list(string); default = ["dev", "staging", "prod"] }
variable "create_optional" { type = bool; default = true }
