# 🔧 GitHub Repository Variables Setup

This guide explains how to configure the required GitHub repository variables for your OpenTofu EKS workflow.

## 📋 Required Variables (Minimal Setup)

Only **2 variables** are required for the workflow to function:

| Variable Name | Description | Example Value |
|---------------|-------------|---------------|
| `AWS_ROLE_ARN` | AWS IAM Role ARN for OIDC authentication | `arn:aws:iam::123456789012:role/github-actions-role` |
| `AWS_REGION` | AWS region for your resources | `ap-south-1` |

## 🚀 How to Set These Variables

### **Step 1: Go to Repository Settings**
1. Navigate to your GitHub repository
2. Click **Settings** tab
3. Click **Secrets and variables** in the left sidebar
4. Click **Variables** tab

### **Step 2: Add Required Variables**
Click **New repository variable** and add:

```
Name: AWS_ROLE_ARN
Value: arn:aws:iam::YOUR-ACCOUNT-ID:role/YOUR-ROLE-NAME

Name: AWS_REGION
Value: ap-south-1
```

That's it! No additional backend variables needed.

## 🔐 AWS IAM Role Setup

### **Required Permissions for the Role:**
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "dynamodb:*",
                "ec2:*",
                "eks:*",
                "iam:*",
                "vpc:*"
            ],
            "Resource": "*"
        }
    ]
}
```

### **Trust Policy for OIDC:**
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::YOUR-ACCOUNT-ID:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                },
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:YOUR-USERNAME/YOUR-REPO:*"
                }
            }
        }
    ]
}
```

## 🧪 Testing the Variables

### **Workflow Trigger:**
1. Go to **Actions** tab in your repository
2. Select **OpenTofu Plan - 🐘** workflow
3. Click **Run workflow**
4. Select **dev-working** branch
5. Click **Run workflow**

### **Expected Output:**
The workflow should:
- ✅ Authenticate to AWS successfully
- ✅ Use the `backend-config.tfvars` file for backend configuration
- ✅ Initialize OpenTofu with S3 backend
- ✅ Run plan successfully

## 🆘 Troubleshooting

### **Common Issues:**

1. **"Role ARN not found"**
   - Verify the role exists in AWS
   - Check the role ARN is correct
   - Ensure the role has proper trust policy

2. **"Access denied to S3"**
   - Verify the role has S3 permissions
   - Check if the S3 bucket exists
   - Ensure the role can access the bucket

3. **"DynamoDB table not found"**
   - Verify the table exists
   - Check the table name is correct
   - Ensure the role has DynamoDB permissions

### **Debug Commands:**
The workflow includes these debug steps:
- `aws sts get-caller-identity` - Shows who you're authenticated as
- Backend config is read from `backend-config.tfvars`
- Detailed OpenTofu output - Shows any initialization errors

## 🔄 Backend Configuration

Your backend configuration is stored in `terraform/backend-config.tfvars`:
```hcl
bucket         = "mahesh-eks-terraform-state"
key            = "aws-eks-stack/terraform.tfstate"
region         = "ap-south-1"
dynamodb_table = "mahesh-eks-terraform-locks"
encrypt        = true
```

**To change backend settings:**
1. Edit `terraform/backend-config.tfvars`
2. Commit and push the changes
3. The workflow will automatically use the new configuration

## 📚 Additional Resources

- [GitHub Actions Variables Documentation](https://docs.github.com/en/actions/learn-github-actions/variables)
- [AWS OIDC Provider Setup](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html)
- [OpenTofu Backend Configuration](https://opentofu.org/docs/language/settings/backends/configuration)

---

**Need help?** Check the workflow logs or AWS CloudTrail for detailed error information.
