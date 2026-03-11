# ── MOVED BLOCK ────────────────────────────────────────────────
# If you renamed a resource from "app" to "application",
# use a moved block instead of deleting + recreating:
moved {
  from = aws_s3_bucket.app          # old address
  to   = aws_s3_bucket.application  # new address
}
# After applying once, you can remove this moved block.
