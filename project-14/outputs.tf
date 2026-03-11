output "user_names"          { value = aws_iam_user.team[*].name }
output "bucket_names"        { value = aws_s3_bucket.env_buckets[*].bucket }
output "first_user"          { value = aws_iam_user.team[0].name }
output "optional_bucket_created" { value = var.create_optional }
