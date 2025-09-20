# 🚀 OpenTofu Workflows Guide

This guide explains how to use the separate OpenTofu workflows for planning and applying infrastructure changes.

## 📋 **Workflow Overview**

You now have two separate workflows:

1. **`OpenTofu Plan - 🦁`** - Creates execution plan and validates configuration
2. **`OpenTofu Apply - 🦁`** - Deploys infrastructure based on configuration

## 🎯 **How to Use**

### **Step 1: Plan Phase**
1. Go to **Actions** tab in your repository
2. Select **OpenTofu Plan - 🦁** workflow
3. Click **Run workflow**
4. Click **Run workflow**

**What happens:**
- ✅ Code checkout and AWS authentication
- ✅ OpenTofu initialization with backend
- ✅ Format checking and validation
- ✅ Plan generation and review
- ✅ **No artifacts saved** - clean and secure

### **Step 2: Apply Phase (Manual Control)**
1. Go to **Actions** tab in your repository
2. Select **OpenTofu Apply - 🦁** workflow
3. Click **Run workflow**
4. Click **Run workflow**

**What happens:**
- ✅ Code checkout and AWS authentication
- ✅ OpenTofu initialization with backend
- ✅ **Direct apply** with `-auto-approve`
- ✅ Infrastructure deployment
- ✅ Post-deployment instructions

## 🔄 **Workflow Flow**

```
Plan Workflow → Review Plan → Apply Workflow → Infrastructure Deployed
     ↓              ↓              ↓
  Validation    Manual Review   Deployment
  & Planning    & Approval      & Setup
```

## 🔒 **Security Features**

### **Separate Control:**
- **Plan workflow** - Safe to run anytime for validation
- **Apply workflow** - Requires explicit manual trigger
- **No automatic progression** - full human control
- **Clear separation** - plan vs apply responsibilities

### **Manual Approval:**
- **Plan first** - always validate before applying
- **Manual apply** - explicit decision to deploy
- **No accidental deployments** - separate workflows
- **Audit trail** - clear separation of actions

## ⚡ **Workflow Benefits**

### **1. Full Control:**
- **Plan independently** - validate anytime
- **Apply when ready** - manual trigger only
- **No dependencies** - each workflow is independent
- **Clear separation** - planning vs deployment

### **2. Safety:**
- **Plan won't deploy** - only validation
- **Apply requires intent** - explicit action needed
- **Review process** - plan output before applying
- **Rollback capability** - apply can be run multiple times

### **3. Flexibility:**
- **Run plan multiple times** - iterate on configuration
- **Apply when confident** - after thorough review
- **Team collaboration** - different people can plan vs apply
- **Environment control** - plan in dev, apply in prod

## 🚨 **Important Notes**

### **Plan Workflow:**
- **Safe to run anytime** - only validation and planning
- **Review output carefully** - ensure changes are expected
- **No infrastructure changes** - just planning and validation

### **Apply Workflow:**
- **Deploys infrastructure** - be certain before running
- **Uses `-auto-approve`** - no interactive prompts
- **Can be run multiple times** - idempotent operations
- **Requires manual trigger** - explicit decision needed

## 🔄 **Typical Workflow**

### **Development Cycle:**
1. **Make changes** to OpenTofu configuration
2. **Commit and push** changes to repository
3. **Run Plan workflow** - validate and review changes
4. **Review plan output** - ensure changes are expected
5. **Run Apply workflow** - deploy infrastructure
6. **Monitor deployment** - check logs and resources

### **Review Process:**
1. **Plan output** - review resource changes
2. **Cost implications** - understand resource usage
3. **Security review** - ensure no unintended access
4. **Team approval** - if required by your process

## 🆘 **Troubleshooting**

### **Plan Fails:**
- Check OpenTofu configuration syntax
- Verify backend configuration
- Review AWS permissions
- Check variable definitions

### **Apply Fails:**
- Review plan output for issues
- Check AWS service limits
- Verify resource dependencies
- Review security group configurations

### **Common Issues:**
- **Backend not initialized** - check init step
- **AWS authentication** - check IAM role permissions
- **Resource conflicts** - check for existing resources
- **Network issues** - verify VPC and subnet configurations

## 🎉 **Success Indicators**

### **Plan Success:**
- ✅ All resources planned successfully
- ✅ No errors or warnings
- ✅ Resource counts as expected
- ✅ Cost implications understood

### **Apply Success:**
- ✅ All resources created successfully
- ✅ EKS cluster running
- ✅ Worker nodes healthy
- ✅ kubectl configuration ready

## 📚 **Next Steps After Apply**

1. **Configure kubectl:**
   ```bash
   aws eks update-kubeconfig --region ap-south-1 --name eks-learning-cluster
   ```

2. **Verify cluster:**
   ```bash
   kubectl get nodes
   kubectl get pods --all-namespaces
   ```

3. **Deploy applications:**
   - Create Kubernetes manifests
   - Deploy to your cluster
   - Set up monitoring and logging

## 🎯 **When to Use Each Workflow**

### **Plan Workflow:**
- **Configuration changes** - validate syntax and logic
- **New features** - understand resource impact
- **Cost estimation** - see what will be created
- **Team review** - share planned changes

### **Apply Workflow:**
- **After successful plan** - deploy validated changes
- **Infrastructure deployment** - create resources
- **Environment setup** - staging, production
- **Disaster recovery** - recreate infrastructure

---

**Ready to use?** Start with the Plan workflow to validate your configuration, then use Apply when you're ready to deploy! 🚀
