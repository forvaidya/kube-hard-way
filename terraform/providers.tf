terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Default provider for Mumbai region (ap-south-1)
provider "aws" {
}

# Provider for us-east-1 (required for CloudFront, ACM, IAM, etc.)
provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
}
