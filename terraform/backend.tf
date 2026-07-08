# IMPORTANT: S3 backend for remote state management
#
# First run: Initialize without backend (comment this block out)
#   1. Run: terraform init
#   2. Run: terraform apply
#   3. Manually create an S3 bucket for Terraform state (e.g., "terraform-state-<account-id>")
#   4. Enable versioning and block public access on the state bucket
#
# Second run: Uncomment this block and migrate state to S3
#   1. Uncomment the backend block below
#   2. Run: terraform init -migrate-state
#   3. Confirm migration to S3 backend
#
# terraform {
#   backend "s3" {
#     bucket         = "terraform-state-<your-account-id>"
#     key            = "portfolio-site/terraform.tfstate"
#     region         = "ap-south-1"
#     encrypt        = true
#     dynamodb_table = "terraform-locks"
#   }
# }
