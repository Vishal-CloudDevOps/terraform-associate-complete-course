output "state_bucket"    { value = aws_s3_bucket.state.bucket }
output "dynamodb_table"  { value = aws_dynamodb_table.lock.name }
output "backend_snippet" {
  value = <<-EOT
    backend "s3" {
      bucket         = "${aws_s3_bucket.state.bucket}"
      key            = "YOUR_PROJECT/terraform.tfstate"
      region         = "${var.aws_region}"
      encrypt        = true
      dynamodb_table = "${aws_dynamodb_table.lock.name}"
    }
  EOT
}
