variable "aws_region"    { type = string; default = "us-east-1" }
variable "project_name"  { type = string; default = "tf-modules" }
variable "environment"   { type = string; default = "dev" }
variable "ami_id"        { type = string; default = "ami-0c02fb55956c7d316" }
variable "instance_type" { type = string; default = "t2.micro" }
