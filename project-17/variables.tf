variable "aws_region"   { type = string; default = "us-east-1" }
variable "project_name" { type = string; default = "tf-dynamic" }
variable "ingress_rules" {
  type = list(object({ description = string; port = number; cidr_blocks = list(string) }))
  default = [
    { description = "HTTP",  port = 80,  cidr_blocks = ["0.0.0.0/0"]   },
    { description = "HTTPS", port = 443, cidr_blocks = ["0.0.0.0/0"]   },
    { description = "SSH",   port = 22,  cidr_blocks = ["10.0.0.0/8"]  }
  ]
}
