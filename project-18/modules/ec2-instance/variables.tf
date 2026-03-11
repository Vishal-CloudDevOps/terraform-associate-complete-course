variable "instance_name"     { type = string }
variable "ami_id"            { type = string }
variable "instance_type"     { type = string; default = "t2.micro" }
variable "security_group_id" { type = string }
variable "environment"       { type = string; default = "dev" }
