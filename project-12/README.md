# Project 12 — Remote Backend with S3 + State Locking

## 🎯 What You Will Learn
- Why local state is bad for teams
- Configuring an S3 backend
- State locking with DynamoDB
- `terraform init -migrate-state`
- Backend configuration best practices

## 📖 Exam Domain
- Domain 7: Remote backends, state locking

---

## 🧠 Theory: Why Remote Backend?

**Local state** (`terraform.tfstate` on your laptop) has problems:
- Teammate can't run Terraform at the same time
- State gets lost if laptop breaks
- Can't share state information between pipelines
- No locking → two people apply at once → **state corruption**

**Remote backend** solves this:
- State stored in **S3** (durable, encrypted, versioned)
- State locked in **DynamoDB** (prevents concurrent applies)
- Anyone with permissions can run Terraform
- CI/CD pipelines work seamlessly

---

## 🧠 Theory: S3 Backend Configuration

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "project/terraform.tfstate"  # path within bucket
    region         = "us-east-1"
    encrypt        = true                          # SSE encryption
    dynamodb_table = "terraform-state-lock"        # locking table
  }
}
```

**The `key`** is the path where state is stored in S3. Different projects/environments use different keys:
```
bucket/
├── dev/terraform.tfstate
├── staging/terraform.tfstate
└── prod/terraform.tfstate
```

---

## 🧠 Theory: State Locking with DynamoDB

When Terraform starts `plan` or `apply`, it writes a lock record to DynamoDB:

```
DynamoDB Table: terraform-state-lock
Key: LockID = "my-bucket/project/terraform.tfstate"
```

If another process tries to run at the same time, it reads the lock and **waits or errors**.

When the operation completes, the lock is **released**.

---

## 🧠 Theory: Backend Initialization

After changing the backend configuration:
```bash
terraform init -migrate-state    # Move existing state to new backend
terraform init -reconfigure      # Reconfigure without migrating state
```

---

## 🚀 How to Run

```bash
# Step 1: Create the S3 + DynamoDB infrastructure
# (Comment out the backend block in backend.tf first)
terraform init
terraform apply -var="state_bucket_name=my-unique-state-bucket-xyz"

# Step 2: Note the bucket name from output
terraform output state_bucket

# Step 3: Update backend.tf with your bucket name
# Step 4: Migrate state
terraform init -migrate-state
# Terraform asks: "Do you want to copy existing state?" → yes

# Step 5: Verify state is now in S3
aws s3 ls s3://YOUR-BUCKET-NAME/project-12/

terraform destroy
```

## ✅ Exam Tips
> Remote backend stores state in S3, locks in DynamoDB  
> `encrypt = true` enables server-side encryption  
> `dynamodb_table` = name of DynamoDB table for locking (must have `LockID` hash key)  
> `-migrate-state` moves existing state to new backend  
> State locking prevents concurrent `apply` corruption  
> DynamoDB table must have `LockID` as the hash key (type `S`)  

## ➡️ Next Project
Project 13 covers workspaces — managing multiple environments.
