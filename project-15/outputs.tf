output "user_arns"      { value = { for k, v in aws_iam_user.devs : k => v.arn } }
output "bucket_arns"    { value = { for k, v in aws_s3_bucket.buckets : k => v.arn } }
output "versioned_buckets" { value = keys(aws_s3_bucket_versioning.versioned) }
