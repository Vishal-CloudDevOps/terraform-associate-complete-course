output "environment"    { value = var.environment }
output "instance_type"  { value = local.instance_type }
output "instance_count" { value = local.instance_count }
output "alarm_created"  { value = local.is_prod ? "Yes" : "No — dev/staging only" }
