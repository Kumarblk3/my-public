# 🚀 GitHub Actions + AWS Deployment Practice

This repository demonstrates how to use **GitHub Actions** to connect securely to AWS and deploy resources using **Terraform** or AWS CLI.

---

## 📂 Workflows

### 🔹 Test AWS Connection
File: `.github/workflows/test-aws.yml`

- Trigger: Manual (`workflow_dispatch`)
- Purpose: Verify AWS credentials
- Steps:
  - Checkout repository
  - Configure AWS credentials from GitHub Secrets
  - Run `aws sts get-caller-identity`

### 🔹 Deploy to AWS
File: `.github/workflows/deploy.yml`

- Trigger: Push to `main` branch
- Purpose: Deploy resources with Terraform
- Steps:
  - Checkout repository
  - Configure AWS credentials
  - Setup Terraform
  - Initialize, plan, and apply Terraform configuration

---

## 🔑 GitHub Secrets Required

Add these secrets in your repository settings:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`

---

## 📦 Example Terraform Configurations

### S3 Bucket
```hcl
provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "practice_bucket" {
  bucket = "bhargav-practice-bucket-12345"
  acl    = "private"
}

variable "aws_region" {
  default = "ap-south-1"
}
