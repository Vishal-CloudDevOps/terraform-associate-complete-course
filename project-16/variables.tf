variable "aws_region"   { type = string; default = "us-east-1" }
variable "project_name" { type = string; default = "tf-conditional" }
variable "environment"  { type = string; default = "dev" }
variable "ami_id"       { type = string; default = "ami-0c02fb55956c7d316" }
variable "cpu_threshold"{ type = number; default = 80 }
