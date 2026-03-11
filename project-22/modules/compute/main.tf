data "aws_ami" "amazon_linux" {
  most_recent = true; owners = ["amazon"]
  filter { name = "name";                values = ["amzn2-ami-hvm-*-x86_64-gp2"] }
  filter { name = "virtualization-type"; values = ["hvm"] }
}
resource "aws_security_group" "app" {
  name   = "${var.name_prefix}-app-sg"
  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.port; to_port = ingress.value.port; protocol = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress { from_port = 0; to_port = 0; protocol = "-1"; cidr_blocks = ["0.0.0.0/0"] }
  tags = merge(var.tags, { Name = "${var.name_prefix}-sg" })
}
resource "aws_instance" "app" {
  count                  = var.instance_count
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids = [aws_security_group.app.id]
  tags = merge(var.tags, { Name = "${var.name_prefix}-server-${count.index + 1}", Role = count.index == 0 ? "primary" : "replica" })
}
