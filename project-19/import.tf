# ── Declarative Import Block (Terraform 1.5+) ─────────────────
# Change the 'id' below to your real bucket name, then:
# terraform plan && terraform apply
import {
  to = aws_s3_bucket.imported
  id = "replace-with-your-existing-bucket-name"
}
