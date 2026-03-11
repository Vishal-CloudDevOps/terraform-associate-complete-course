#!/bin/bash
# ═══════════════════════════════════════════════════
# Terraform CLI Reference — Project 08
# ═══════════════════════════════════════════════════

# ── INIT ────────────────────────────────────────────
terraform init                       # standard init
terraform init -upgrade              # upgrade providers to latest allowed
terraform init -reconfigure          # force backend reconfiguration
terraform init -migrate-state        # migrate state to new backend
terraform init -backend=false        # skip backend init

# ── FORMAT ──────────────────────────────────────────
terraform fmt                        # format current directory
terraform fmt -recursive             # format all subdirectories
terraform fmt -check                 # exit code 1 if formatting needed (CI)
terraform fmt -diff                  # show what would change

# ── VALIDATE ────────────────────────────────────────
terraform validate                   # check syntax + consistency
terraform validate -json             # machine-readable output

# ── PLAN ────────────────────────────────────────────
terraform plan                             # standard plan
terraform plan -out=tfplan                 # save plan to file
terraform plan -var="env=prod"             # override variable
terraform plan -var-file="prod.tfvars"     # load var file
terraform plan -target=aws_s3_bucket.demo  # plan specific resource only
terraform plan -destroy                    # preview destroy
terraform plan -refresh=false              # skip state refresh (faster)
terraform plan -detailed-exitcode          # exit 0=no changes, 2=changes, 1=error

# ── APPLY ────────────────────────────────────────────
terraform apply                            # interactive prompt
terraform apply -auto-approve              # no prompt (CI/CD)
terraform apply tfplan                     # apply saved plan exactly
terraform apply -target=aws_s3_bucket.demo # apply specific resource
terraform apply -replace="aws_s3_bucket.demo"  # force recreation

# ── DESTROY ──────────────────────────────────────────
terraform destroy                          # interactive
terraform destroy -auto-approve            # no prompt
terraform destroy -target=aws_s3_bucket.demo

# ── OUTPUT ───────────────────────────────────────────
terraform output                           # all outputs
terraform output bucket_name               # specific output
terraform output -json                     # JSON format
terraform output -raw bucket_name          # raw value (no quotes)

# ── STATE ────────────────────────────────────────────
terraform state list                       # list resources in state
terraform state show aws_s3_bucket.demo    # show one resource
terraform state mv aws_s3_bucket.demo aws_s3_bucket.main  # rename in state
terraform state rm aws_s3_bucket.demo      # remove from state (does not destroy)
terraform state pull                       # download state JSON

# ── SHOW ─────────────────────────────────────────────
terraform show                             # current state (human readable)
terraform show tfplan                      # saved plan
terraform show -json                       # JSON

# ── VERSION / PROVIDERS ──────────────────────────────
terraform version                          # Terraform + provider versions
terraform providers                        # providers in config
terraform providers lock                   # update lock file
