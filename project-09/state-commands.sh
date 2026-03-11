#!/bin/bash
# State Commands Reference

terraform state list                                    # List all resources
terraform state show aws_s3_bucket.app                  # Show resource details
terraform state show 'aws_s3_bucket.buckets[0]'         # Indexed resource
terraform state pull                                    # Download state JSON
terraform state pull > backup.tfstate                   # Save backup

# Rename resource in state (update .tf file too!)
terraform state mv aws_s3_bucket.app aws_s3_bucket.primary

# Move into a module
terraform state mv aws_s3_bucket.app module.storage.aws_s3_bucket.app

# Remove from state (does NOT destroy real resource)
terraform state rm aws_iam_user.svc

# Force recreation (replaces deprecated 'terraform taint')
terraform apply -replace="aws_s3_bucket.app"

# Force-unlock stuck state
terraform force-unlock LOCK_ID_HERE
