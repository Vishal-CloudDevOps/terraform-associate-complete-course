# terraform.tfvars — override defaults here
# This file is AUTO-LOADED by Terraform
app_name    = "awesome-app"
environment = "dev"

regions = ["us-east-1", "eu-west-1", "ap-southeast-1"]

tags = {
  ManagedBy   = "Terraform"
  Environment = "dev"
  Owner       = "your-name"
  Project     = "project-04"
}

db_config = {
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  multi_az          = false
  engine_version    = "8.0"
}
