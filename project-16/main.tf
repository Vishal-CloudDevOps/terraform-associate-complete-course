terraform {
  required_version = ">= 1.5.0"
  required_providers { aws = { source = "hashicorp/aws", version = "~> 5.0" } }
}
provider "aws" { region = var.aws_region }
locals {
  is_prod       = var.environment == "prod"
  instance_type = local.is_prod ? "t3.medium" : "t2.micro"
  instance_count = local.is_prod ? 3 : 1
  name_prefix   = "${var.project_name}-${var.environment}"
}
resource "aws_instance" "app" {
  count         = local.instance_count
  ami           = var.ami_id
  instance_type = local.instance_type
  tags = {
    Name  = "${local.name_prefix}-server-${count.index + 1}"
    Tier  = local.is_prod ? "production" : "non-production"
  }
}
# Only create alarm in prod
resource "aws_cloudwatch_metric_alarm" "cpu" {
  count               = local.is_prod ? 1 : 0
  alarm_name          = "${local.name_prefix}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = var.cpu_threshold
  alarm_description   = "CPU > ${var.cpu_threshold}%"
  dimensions          = { InstanceId = aws_instance.app[0].id }
}
