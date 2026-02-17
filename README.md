# 🏦 Banking Infrastructure on AWS

Production-grade, secure, and scalable banking infrastructure deployed on AWS using Terraform and Jenkins CI/CD.

## 📊 Project Overview

This project implements a multi-environment banking infrastructure on AWS with:
- **Multi-tier network architecture** (public, private app, private database subnets)
- **High availability** across multiple Availability Zones
- **Security best practices** (VPC Flow Logs, private subnets, network isolation)
- **GitOps workflow** with automated CI/CD pipeline
- **Infrastructure as Code** using Terraform
- **Cost-optimized** for AWS Free Tier

## 🏗️ Architecture
```
┌─────────────────────────────────────────────────────────────┐
│                         AWS Cloud                            │
│  ┌────────────────────────────────────────────────────────┐ │
│  │                VPC (10.x.0.0/16)                       │ │
│  │                                                        │ │
│  │  ┌──────────────────┐    ┌──────────────────┐        │ │
│  │  │  Public Subnet   │    │  Public Subnet   │        │ │
│  │  │   (us-east-1a)   │    │   (us-east-1b)   │        │ │
│  │  │  - Future: ALB   │    │  - Future: ALB   │        │ │
│  │  └──────────────────┘    └──────────────────┘        │ │
│  │           │                       │                   │ │
│  │  ┌──────────────────┐    ┌──────────────────┐        │ │
│  │  │ Private Subnet   │    │ Private Subnet   │        │ │
│  │  │  (App Tier 1a)   │    │  (App Tier 1b)   │        │ │
│  │  │  - Future: EC2   │    │  - Future: EC2   │        │ │
│  │  └──────────────────┘    └──────────────────┘        │ │
│  │           │                       │                   │ │
│  │  ┌──────────────────┐    ┌──────────────────┐        │ │
│  │  │ Private Subnet   │    │ Private Subnet   │        │ │
│  │  │   (DB Tier 1a)   │    │   (DB Tier 1b)   │        │ │
│  │  │  - Future: RDS   │    │  - RDS Replica   │        │ │
│  │  └──────────────────┘    └──────────────────┘        │ │
│  │                                                        │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## 🌳 Branch Strategy
```
main (production)
├── staging (pre-production)
└── develop (development)
    ├── feature/infra-*
    ├── feature/database-*
    ├── feature/security-*
    └── feature/backend-*
```

### Branch Rules:
- **main**: Production environment - requires approval & PR reviews
- **staging**: Pre-production testing - requires approval
- **develop**: Development integration - PR required
- **feature/***: Feature branches - merge to develop via PR

## 🚀 Current Infrastructure

### ✅ Implemented:
- [x] VPC with DNS support
- [x] Internet Gateway
- [x] 2 Public Subnets (Multi-AZ)
- [x] 4 Private Subnets (2 for App tier, 2 for DB tier)
- [x] Route Tables (Public & Private)
- [x] VPC Flow Logs with CloudWatch integration
- [x] Multi-environment support (dev, staging, prod)
- [x] Jenkins CI/CD pipeline with manual approvals
- [x] Cost-optimized for AWS Free Tier

### 🔄 Planned:
- [ ] Security Groups (Web, App, Database tiers)
- [ ] RDS PostgreSQL (Multi-AZ, encrypted)
- [ ] EC2 Auto Scaling Groups
- [ ] Application Load Balancer
- [ ] Bastion Host
- [ ] CloudWatch Alarms & Dashboards
- [ ] AWS Secrets Manager
- [ ] KMS Encryption Keys

## 📋 Prerequisites

- AWS Account with Free Tier
- Terraform >= 1.0
- Jenkins (configured)
- GitHub repository
- AWS credentials configured in Jenkins

## 🔧 Environment Variables

The pipeline automatically configures different CIDR blocks for each environment:

| Environment | VPC CIDR     | Public Subnets      | Private App Subnets | Private DB Subnets |
|-------------|--------------|---------------------|---------------------|-------------------|
| **dev**     | 10.1.0.0/16  | 10.1.1.0/24, 10.1.2.0/24 | 10.1.11.0/24, 10.1.12.0/24 | 10.1.21.0/24, 10.1.22.0/24 |
| **staging** | 10.2.0.0/16  | 10.2.1.0/24, 10.2.2.0/24 | 10.2.11.0/24, 10.2.12.0/24 | 10.2.21.0/24, 10.2.22.0/24 |
| **prod**    | 10.0.0.0/16  | 10.0.1.0/24, 10.0.2.0/24 | 10.0.11.0/24, 10.0.12.0/24 | 10.0.21.0/24, 10.0.22.0/24 |

## 🔄 Workflow

### 1. Create Feature Branch
```bash
git checkout develop
git pull origin develop
git checkout -b feature/your-feature-name
```

### 2. Make Changes
```bash
# Edit Terraform files
terraform fmt
terraform validate
```

### 3. Commit & Push
```bash
git add .
git commit -m "feat: your feature description"
git push origin feature/your-feature-name
```

### 4. Create Pull Request
- Go to GitHub
- Create PR: feature/your-feature-name → develop
- Request review
- Wait for approval

### 5. Merge & Deploy
- After approval, merge to develop
- Jenkins automatically deploys to DEV environment
- Test in DEV
- Create PR: develop → staging (for staging deployment)
- Create PR: staging → main (for production deployment)

## 🔐 Security Features

- **VPC Flow Logs**: All network traffic logged to CloudWatch
- **Private Subnets**: Application and database servers not publicly accessible
- **Multi-AZ**: High availability across availability zones
- **Network Isolation**: 3-tier architecture (public, app, database)
- **Future**: Encryption, Security Groups, NACLs, IAM Roles

## 💰 Cost Optimization (AWS Free Tier)

- **VPC**: $0
- **Subnets (6)**: $0
- **Internet Gateway**: $0
- **Route Tables**: $0
- **VPC Flow Logs**: ~$1-2/month
- **NAT Gateway**: Not used (cost optimization!)

**Total: ~$1-2/month** ✅

### 💡 Cost Optimization Tips:
- Destroy dev environment when not in use
- Use t2.micro instances (free tier)
- Limit CloudWatch log retention
- No NAT Gateway (optimized for learning)

## 📊 Jenkins Pipeline Stages

1. **Checkout**: Pull code from GitHub
2. **Terraform Init**: Initialize backend
3. **Terraform Validate**: Validate syntax
4. **Terraform Plan**: Show planned changes
5. **Manual Approval** (staging/prod only)
6. **Terraform Apply**: Deploy infrastructure
7. **Post-Deploy Verification**: Show outputs

## 🧪 Testing
```bash
# Local testing
terraform init
terraform plan
terraform validate

# Format code
terraform fmt -recursive
```

## 📝 Contributing

1. Create feature branch from `develop`
2. Make changes
3. Create Pull Request
4. Get approval
5. Merge

## 👤 Author

**Gokhan Saygin**
- Cloud Engineering Journey
- Focus: AWS, Terraform, CI/CD, Banking Infrastructure

## 📄 License

This project is for educational purposes.

---

**⚠️ Important**: This is a learning project optimized for AWS Free Tier. Always review infrastructure changes before deploying to production!