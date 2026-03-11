# Project 22 — Capstone: Production-Ready Full-Stack AWS Infrastructure

## 🎯 What This Covers
Every concept from all 22 projects combined:
- ✅ Providers + version constraints
- ✅ Resources + lifecycle + depends_on
- ✅ Variables (all types) + outputs + tfvars
- ✅ Locals + data sources + merge()
- ✅ count + count.index
- ✅ for_each + each.key/value
- ✅ Dynamic blocks
- ✅ Modules (local, multi-env)
- ✅ Conditional expressions
- ✅ Remote backend
- ✅ Workspaces
- ✅ State management

## 📖 Architecture

```
project-22/
├── modules/
│   ├── networking/  ← VPC, subnets (count for multi-AZ), IGW, routes
│   └── compute/     ← EC2 (count + data source AMI), SG (dynamic blocks)
└── environments/
    ├── dev/         ← 1x t2.micro, smaller VPC
    └── prod/        ← 3x t3.medium, larger VPC
```

## 🚀 How to Run

```bash
# Dev
cd environments/dev
terraform init && terraform apply

# Prod
cd ../prod
terraform init && terraform apply
```

## ✅ Final Exam Checklist

| Concept | Project | Covered |
|---|---|---|
| IaC concepts | 01 | ✅ |
| Providers + versioning | 02 | ✅ |
| Resources + references | 03 | ✅ |
| Variables (primitive) | 03 | ✅ |
| Complex variables + tfvars | 04 | ✅ |
| Outputs | 05 | ✅ |
| First AWS resource | 06 | ✅ |
| Full AWS + default_tags | 07 | ✅ |
| CLI workflow | 08 | ✅ |
| State management | 09 | ✅ |
| Lifecycle rules | 10 | ✅ |
| Data sources + locals | 11 | ✅ |
| Remote backend | 12 | ✅ |
| Workspaces | 13 | ✅ |
| count + count.index | 14 | ✅ |
| for_each + maps | 15 | ✅ |
| Conditionals | 16 | ✅ |
| Dynamic blocks | 17 | ✅ |
| Modules | 18 | ✅ |
| Import | 19 | ✅ |
| Provisioners | 20 | ✅ |
| moved + check + conditions | 21 | ✅ |
| Capstone | 22 | ✅ |
