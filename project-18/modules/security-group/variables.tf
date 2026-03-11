variable "name" { type = string }
variable "ingress_rules" {
  type    = list(object({ port = number; description = string; cidr = string }))
  default = []
}
