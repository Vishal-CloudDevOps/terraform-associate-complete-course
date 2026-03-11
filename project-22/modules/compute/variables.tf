variable "name_prefix"    { type = string }
variable "environment"    { type = string }
variable "vpc_id"         { type = string }
variable "subnet_ids"     { type = list(string) }
variable "instance_type"  { type = string; default = "t2.micro" }
variable "instance_count" { type = number; default = 1 }
variable "tags"           { type = map(string); default = {} }
variable "ingress_rules"  {
  type    = list(object({ description = string; port = number; cidr_blocks = list(string) }))
  default = [{ description = "HTTP"; port = 80; cidr_blocks = ["0.0.0.0/0"] }]
}
