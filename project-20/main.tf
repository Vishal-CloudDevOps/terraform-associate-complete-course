terraform {
  required_version = ">= 1.5.0"
  required_providers { aws = { source = "hashicorp/aws", version = "~> 5.0" } }
}
provider "aws" { region = var.aws_region }

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  # local-exec: runs a command on the MACHINE RUNNING TERRAFORM
  provisioner "local-exec" {
    command = "echo 'Instance ${self.id} created with IP ${self.public_ip}' >> provisioned.log"
  }

  # local-exec on destroy
  provisioner "local-exec" {
    when    = destroy
    command = "echo 'Instance ${self.id} is being destroyed' >> provisioned.log"
  }

  # remote-exec: runs commands ON the remote instance via SSH
  # (Requires key_pair and instance to be reachable)
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

  tags = { Name = "${var.project_name}-web" }
}
