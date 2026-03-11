output "workspace"      { value = terraform.workspace }
output "instance_type"  { value = local.size }
output "instance_count" { value = local.count_n }
output "bucket_name"    { value = aws_s3_bucket.app.bucket }
