#!/bin/bash
# Classic import (all Terraform versions):
terraform import aws_s3_bucket.imported my-existing-bucket-name
terraform import aws_instance.web i-1234567890abcdef0
terraform import aws_iam_user.admin my-username
terraform import aws_vpc.main vpc-12345678
terraform import 'module.storage.aws_s3_bucket.app' my-bucket

# After import — verify:
terraform state list
terraform plan   # should show "No changes" if config matches

# Auto-generate config (Terraform 1.6+):
terraform plan -generate-config-out=generated.tf
