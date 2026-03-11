output "app_bucket_name"  { value = aws_s3_bucket.app.bucket }
output "app_bucket_arn"   { value = aws_s3_bucket.app.arn }
output "logs_bucket_name" { value = aws_s3_bucket.logs.bucket }
output "region"           { value = var.aws_region }
output "bucket_urls" {
  value = {
    app  = "https://${aws_s3_bucket.app.bucket}.s3.amazonaws.com"
    logs = "https://${aws_s3_bucket.logs.bucket}.s3.amazonaws.com"
  }
}
