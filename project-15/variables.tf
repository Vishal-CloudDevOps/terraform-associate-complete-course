variable "aws_region" { type = string; default = "us-east-1" }
variable "developer_names" {
  type    = list(string)
  default = ["alice", "bob", "charlie"]
}
variable "buckets" {
  type = map(object({ bucket_name = string; environment = string; purpose = string; versioning = bool }))
  default = {
    "app-assets"  = { bucket_name = "myapp-assets-xyz123",  environment = "prod", purpose = "static",  versioning = false }
    "app-backups" = { bucket_name = "myapp-backups-xyz123", environment = "prod", purpose = "backups", versioning = true  }
    "app-logs"    = { bucket_name = "myapp-logs-xyz123",    environment = "dev",  purpose = "logging", versioning = false }
  }
}
