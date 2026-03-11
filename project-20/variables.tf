variable "aws_region"      { type = string; default = "us-east-1" }
variable "project_name"    { type = string; default = "tf-provisioner" }
variable "ami_id"          { type = string; default = "ami-0c02fb55956c7d316" }
variable "instance_type"   { type = string; default = "t2.micro" }
variable "key_pair_name"   { type = string; default = "" }
variable "private_key_path"{ type = string; default = "~/.ssh/id_rsa" }
