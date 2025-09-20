# 🚀 Terraform Backend Setup Guide - Clean Slate Edition

This guide will help you set up a secure S3 backend for your Terraform state management from scratch.

## 📋 Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform installed
- Access to create S3 buckets and DynamoDB tables
- **Willingness to start fresh** (existing resources will be removed)

## 🔧 Setup Steps

### 1. Clean Slate Setup

The setup script will automatically detect existing resources and offer to remove them:

```bash
# Make script executable
chmod +x setup-backend.sh

# Run the setup script (it will handle existing resources)
./setup-backend.sh
```

**What happens during setup:**
- 🔍 **Detects existing resources** (S3 bucket, DynamoDB table)
- 🧹 **Offers cleanup** if resources exist
- 📦 **Creates fresh S3 bucket** with security best practices
- 🔐 **Creates fresh DynamoDB table** for state locking
- 🔒 **Enables security features** (encryption, versioning, public access blocking)

### 2. Initialize Terraform with Backend

```bash
# Navigate to terraform directory
cd terraform

# Initialize with backend configuration
terraform init -backend-config=backend-config.tfvars
```

### 3. Verify Backend Configuration

```bash
# Check if backend is properly configured
terraform show

# You should see S3 backend information
```

## 🧹 Cleanup Options

### **Option A: Use the Cleanup Script**
```bash
chmod +x cleanup-backend.sh
./cleanup-backend.sh
```

### **Option B: Manual Cleanup**
```bash
# Remove S3 bucket
aws s3 rb s3://mahesh-eks-terraform-state --force

# Remove DynamoDB table
aws dynamodb delete-table --table-name mahesh-eks-terraform-locks --region ap-south-1
```

## 🔒 Security Features

Your backend includes:
- ✅ **Server-side encryption** (AES256)
- ✅ **Versioning enabled** for state file recovery
- ✅ **Public access blocked** for security
- ✅ **State locking** via DynamoDB to prevent concurrent modifications

## 📁 File Structure

```
terraform/
├── backend.tf                    # Backend configuration (empty, configured during init)
├── backend-config.tfvars         # Backend configuration values
├── setup-backend.sh              # Script to create AWS resources (clean slate)
├── cleanup-backend.sh            # Script to remove backend resources
├── BACKEND-SETUP.md              # This setup guide
├── main.tf                       # Main Terraform configuration
├── variables.tf                  # Variable definitions
└── modules/                      # Terraform modules
    ├── vpc/                      # VPC module
    └── eks/                      # EKS module
```

## 🚨 Important Notes

1. **Clean slate approach** - Existing resources will be removed
2. **State files deleted** - All Terraform state will be lost
3. **Infrastructure recreation** - You'll need to recreate any existing resources
4. **Never commit state files** to version control
5. **Use workspaces** if you need multiple environments
6. **Monitor costs** - DynamoDB table uses pay-per-request billing

## 🔄 Alternative: Keep Existing Resources

If you want to keep existing resources, you can:

1. **Modify the script** to use different names
2. **Update backend-config.tfvars** with your existing bucket/table names
3. **Skip the setup script** and configure manually

## 🆘 Troubleshooting

### Common Issues:

1. **Access Denied**: Check AWS credentials and permissions
2. **Bucket name taken**: Use different names or remove existing bucket
3. **Region mismatch**: Ensure all resources are in the same region
4. **State lock**: Check DynamoDB table for stuck locks

### Commands to check:

```bash
# Check AWS identity
aws sts get-caller-identity

# List S3 buckets
aws s3 ls

# Check DynamoDB tables
aws dynamodb list-tables --region ap-south-1

# Check backend status
terraform show
```

## 🎯 Next Steps

After backend setup:
1. `terraform plan` - Review changes
2. `terraform apply` - Apply infrastructure
3. Monitor your EKS cluster creation

## 🚨 Clean Slate Warning

**⚠️  IMPORTANT**: This approach will:
- Remove any existing S3 bucket with the same name
- Remove any existing DynamoDB table with the same name
- Delete all Terraform state files
- Require recreation of any existing infrastructure

**Only proceed if you're ready to start completely fresh!**

---

**Need help?** Check the Terraform documentation or AWS S3/DynamoDB guides.
