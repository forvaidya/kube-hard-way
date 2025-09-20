# S3 backend for Terraform state
# This backend will be configured during terraform init
# Use: terraform init -backend-config=backend-config.tfvars

terraform {
  backend "s3" {}
}
