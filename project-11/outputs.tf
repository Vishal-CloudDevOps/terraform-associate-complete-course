output "ami_id"       { value = data.aws_ami.amazon_linux.id }
output "ami_name"     { value = data.aws_ami.amazon_linux.name }
output "account_id"   { value = local.account_id }
output "vpc_id"       { value = data.aws_vpc.default.id }
output "name_prefix"  { value = local.name_prefix }
output "instance_id"  { value = aws_instance.app.id }
