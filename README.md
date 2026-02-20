# 🏦 Banking Infrastructure on AWS

<p align="center">
  <img src="https://img.shields.io/badge/AWS-Cloud-orange?style=for-the-badge&logo=amazon-aws" alt="AWS">
  <img src="https://img.shields.io/badge/Terraform-IaC-7B42BC?style=for-the-badge&logo=terraform" alt="Terraform">
  <img src="https://img.shields.io/badge/Jenkins-CI%2FCD-D24939?style=for-the-badge&logo=jenkins" alt="Jenkins">
  <img src="https://img.shields.io/badge/Status-Production%20Ready-success?style=for-the-badge" alt="Status">
</p>

<p align="center">
  <strong>Production-grade banking infrastructure built with Terraform, implementing multi-environment deployment strategy and GitOps workflow.</strong>
</p>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Technologies](#-technologies-used)
- [Features](#-features)
- [Infrastructure Details](#-infrastructure-details)
- [Environments](#-environments)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Security](#-security-features)
- [Cost Optimization](#-cost-optimization)
- [Screenshots](#-screenshots)
- [Getting Started](#-getting-started)
- [Challenges & Solutions](#-challenges--solutions)
- [Learning Outcomes](#-learning-outcomes)
- [Future Enhancements](#-future-enhancements)
- [Author](#-author)

---

## 🎯 Overview

This project demonstrates a **complete AWS infrastructure setup for a banking application**, following industry best practices for security, scalability, and reliability. The infrastructure supports multiple environments (Development, Staging, Production) with automated deployment through Jenkins CI/CD pipeline.

### Key Highlights

- ✅ **3-tier network architecture** (Public, Application, Database layers)
- ✅ **Multi-environment strategy** (dev, staging, production)
- ✅ **Infrastructure as Code** (100% Terraform)
- ✅ **GitOps workflow** (feature branches, pull requests, code reviews)
- ✅ **Automated CI/CD** (Jenkins multi-branch pipeline)
- ✅ **Comprehensive monitoring** (CloudWatch Alarms, SNS, Dashboards)
- ✅ **Security-first approach** (private subnets, security groups, VPC Flow Logs)
- ✅ **Cost-optimized** (Free Tier eligible resources)

---

## 🏗️ Architecture

### High-Level Architecture Diagram
```
┌─────────────────────────────────────────────────────────────────┐
│                          INTERNET                                │
└────────────────────────────┬────────────────────────────────────┘
                             │
                    ┌────────▼────────┐
                    │ Internet Gateway │
                    └────────┬────────┘
                             │
        ┌────────────────────┴────────────────────┐
        │         PUBLIC TIER (Future: ALB)       │
        │  ┌──────────────────────────────────┐   │
        │  │ Public Subnets (Multi-AZ)        │   │
        │  │ • us-east-1a: 10.x.1.0/24       │   │
        │  │ • us-east-1b: 10.x.2.0/24       │   │
        │  └──────────────────────────────────┘   │
        └────────────────────┬────────────────────┘
                             │ (Security Group)
        ┌────────────────────▼────────────────────┐
        │         APPLICATION TIER                 │
        │  ┌──────────────────────────────────┐   │
        │  │ Private App Subnets (Multi-AZ)   │   │
        │  │ • us-east-1a: 10.x.11.0/24      │   │
        │  │ • us-east-1b: 10.x.12.0/24      │   │
        │  │                                  │   │
        │  │ ┌──────────┐  ┌──────────┐     │   │
        │  │ │ EC2      │  │ EC2      │     │   │
        │  │ │ t3.micro │  │ t3.micro │     │   │
        │  │ │ Apache   │  │ Apache   │     │   │
        │  │ └──────────┘  └──────────┘     │   │
        │  └──────────────────────────────────┘   │
        └────────────────────┬────────────────────┘
                             │ (Security Group)
        ┌────────────────────▼────────────────────┐
        │          DATABASE TIER (Reserved)        │
        │  ┌──────────────────────────────────┐   │
        │  │ Private DB Subnets (Multi-AZ)    │   │
        │  │ • us-east-1a: 10.x.21.0/24      │   │
        │  │ • us-east-1b: 10.x.22.0/24      │   │
        │  │                                  │   │
        │  │ (Reserved for future RDS)        │   │
        │  └──────────────────────────────────┘   │
        └─────────────────────────────────────────┘

        ┌─────────────────────────────────────────┐
        │         MONITORING & LOGGING             │
        │  • CloudWatch Alarms (CPU, Status)      │
        │  • SNS Email Notifications              │
        │  • VPC Flow Logs                        │
        │  • CloudWatch Dashboards                │
        └─────────────────────────────────────────┘
```

### Network Topology

- **3 VPCs** (one per environment)
- **18 Subnets** across 2 Availability Zones
- **Complete network isolation** between tiers
- **No NAT Gateway** (cost optimization)

---

## 🛠️ Technologies Used

| Category | Technologies |
|----------|-------------|
| **Cloud Provider** | AWS (VPC, EC2, CloudWatch, IAM, SNS) |
| **Infrastructure as Code** | Terraform v1.x |
| **CI/CD** | Jenkins (Multi-branch Pipeline) |
| **Version Control** | Git, GitHub |
| **Monitoring** | CloudWatch, SNS |
| **Web Server** | Apache HTTP Server |
| **Operating System** | Amazon Linux 2023 |

---

## ✨ Features

### Infrastructure
- ✅ Multi-AZ deployment for high availability
- ✅ 3-tier network architecture (public, app, database)
- ✅ Automated infrastructure provisioning
- ✅ Immutable infrastructure (IaC)
- ✅ Environment-specific configurations

### Security
- ✅ Private subnets for application tier (no public IPs)
- ✅ Security Groups with least privilege principle
- ✅ VPC Flow Logs for network monitoring
- ✅ Encrypted EBS volumes
- ✅ IMDSv2 enabled on all EC2 instances
- ✅ IAM roles for EC2 (no hardcoded credentials)

### DevOps
- ✅ GitOps workflow (feature branches → develop → staging → main)
- ✅ Pull request-based code reviews
- ✅ Automated testing (terraform validate)
- ✅ Manual approval gates for staging and production
- ✅ Multi-environment deployment strategy

### Monitoring
- ✅ Real-time CloudWatch Alarms
- ✅ Email notifications via SNS
- ✅ Custom CloudWatch Dashboards
- ✅ EC2 health and performance monitoring

---

## 📦 Infrastructure Details

### Network Layer
| Resource | Count | Details |
|----------|-------|---------|
| VPCs | 3 | One per environment (dev, staging, prod) |
| Subnets | 18 | 2 public, 2 app, 2 database per VPC |
| Internet Gateways | 3 | One per VPC |
| Route Tables | 6 | Public and private per VPC |
| VPC Flow Logs | 3 | CloudWatch Logs integration |

### Compute Layer
| Resource | Count | Details |
|----------|-------|---------|
| EC2 Instances | 3 | t3.micro (Free Tier eligible) |
| IAM Roles | 3 | EC2 service roles |
| IAM Policies | 6 | CloudWatch Logs + SSM access |
| Key Pairs | 3 | SSH access (one per environment) |

### Security Layer
| Resource | Count | Details |
|----------|-------|---------|
| Security Groups | 9 | 3-tier isolation per environment |
| NACL Rules | Default | VPC-level network ACLs |

### Monitoring Layer
| Resource | Count | Details |
|----------|-------|---------|
| CloudWatch Alarms | 6 | CPU + Status Check per environment |
| SNS Topics | 3 | Email alert channels |
| Dashboards | 3 | Real-time metrics visualization |

**Total Resources: 60+ AWS resources managed by Terraform**

---

## 🌍 Environments

| Environment | VPC CIDR | Purpose | Approval Required |
|-------------|----------|---------|-------------------|
| **Development** | `10.1.0.0/16` | Developer testing, rapid iteration | ❌ Automatic |
| **Staging** | `10.2.0.0/16` | QA testing, pre-production validation | ✅ Manual |
| **Production** | `10.0.0.0/16` | Live banking application | ✅ Manual (CTO-level) |

### Environment-Specific Features

- **Separate AWS resources** (complete isolation)
- **Separate Terraform state files** (S3 backend)
- **Environment-specific variables** (CIDR ranges, tags)
- **Progressive deployment** (dev → staging → prod)

---

## 🔄 CI/CD Pipeline

### Pipeline Architecture
```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Feature    │────▶│   develop    │────▶│   staging    │────▶│     main     │
│   Branch     │ PR  │   (DEV)      │ PR  │  (STAGING)   │ PR  │    (PROD)    │
└──────────────┘     └──────────────┘     └──────────────┘     └──────────────┘
       │                    │                     │                     │
       │                    │                     │                     │
       ▼                    ▼                     ▼                     ▼
  Local Test          Auto Deploy          Manual Approve        Manual Approve
terraform validate    Jenkins CI/CD        Tech Lead/Senior      CTO/Manager
```

### Jenkins Pipeline Stages

1. **Checkout** - Fetch code from GitHub
2. **Terraform Init** - Initialize Terraform backend
3. **Terraform Validate** - Syntax and configuration check
4. **Terraform Plan** - Preview infrastructure changes
5. **Manual Approval** - Human review (staging/prod only)
6. **Terraform Apply** - Deploy infrastructure changes
7. **Post-Deploy Verification** - Validate deployment

### Workflow
```bash
# 1. Create feature branch
git checkout -b feature/new-component

# 2. Make changes and commit
git add .
git commit -m "feat: Add new component"
git push origin feature/new-component

# 3. Open Pull Request (feature → develop)
# 4. Code Review & Approval
# 5. Merge → Jenkins auto-deploys to DEV

# 6. Test in DEV, then promote
# Pull Request: develop → staging
# Manual approval → Deploy to STAGING

# 7. Test in STAGING, then promote
# Pull Request: staging → main
# Manual approval → Deploy to PRODUCTION
```

---

## 🔐 Security Features

### Network Security
- ✅ **Private Subnets** - Application tier has no public IPs
- ✅ **Security Groups** - Stateful firewall rules (3-tier isolation)
- ✅ **VPC Flow Logs** - Network traffic monitoring and audit
- ✅ **No NAT Gateway** - Cost optimization (outbound through proxy if needed)

### Instance Security
- ✅ **IAM Roles** - No hardcoded credentials
- ✅ **IMDSv2** - Metadata service protection
- ✅ **Encrypted EBS** - Data at rest encryption
- ✅ **Security Patches** - Amazon Linux 2023 (auto-updates)

### Access Control
- ✅ **SSH Keys** - Separate keys per environment
- ✅ **IAM Policies** - Least privilege principle
- ✅ **Session Manager** - Secure shell access without SSH keys (configured)

### Compliance
- ✅ **Audit Logs** - VPC Flow Logs, CloudWatch Logs
- ✅ **Tagging Strategy** - Resource tracking and cost allocation
- ✅ **Infrastructure as Code** - Version controlled, auditable changes

---

## 💰 Cost Optimization

### Current Cost (When Running)

| Resource | Monthly Cost | Notes |
|----------|--------------|-------|
| 3x EC2 t3.micro | $0 | Free Tier: 750 hours/month |
| VPC + Subnets + IGW | $0 | No charge |
| Security Groups | $0 | No charge |
| VPC Flow Logs | ~$3-5 | Data ingestion + storage |
| CloudWatch Alarms | $0 | First 10 alarms free |
| SNS Notifications | $0 | First 1,000 emails free |
| **Total (3 environments)** | **~$3-5/month** | ✅ **Highly optimized** |

### Cost Optimization Strategies

1. **No NAT Gateway** - Saved ~$32/month per environment (~$96/month total)
2. **t3.micro instances** - Free Tier eligible (vs. larger instances)
3. **gp3 volumes** - Cost-effective storage
4. **Destroy when not in use** - Infrastructure as Code allows quick rebuild
5. **Free Tier maximization** - All resources Free Tier eligible where possible

### Estimated Cost (When Destroyed)

| Resource | Monthly Cost |
|----------|--------------|
| S3 Backend (state files) | ~$0.01 |
| **Total** | **~$0.01/month** |

**💡 Pro Tip:** Deploy when needed, destroy when done. Rebuild takes only 10-15 minutes!

---

## 📸 Screenshots

### Infrastructure Overview

#### EC2 Instances - All Environments Running
![EC2 Instances](SCREENSHOT_URL_HERE)
*Three EC2 instances deployed across dev, staging, and production environments*

#### VPC Overview
![VPC Overview](SCREENSHOT_URL_HERE)
*Multi-environment VPC architecture with complete network isolation*

#### Security Groups
![Security Groups](SCREENSHOT_URL_HERE)
*3-tier security group configuration for network isolation*

### Monitoring & Observability

#### CloudWatch Dashboard
![CloudWatch Dashboard](SCREENSHOT_URL_HERE)
*Real-time monitoring of EC2 metrics (CPU, Network, Status Checks)*

#### CloudWatch Alarms
![CloudWatch Alarms](SCREENSHOT_URL_HERE)
*Automated alerting for CPU thresholds and instance health*

### CI/CD Pipeline

#### Jenkins Multi-Branch Pipeline
![Jenkins Pipeline](SCREENSHOT_URL_HERE)
*Automated deployment pipeline with manual approval gates*

---

## 🚀 Getting Started

### Prerequisites

- AWS Account (Free Tier eligible)
- Terraform >= 1.0
- AWS CLI configured
- Git
- (Optional) Jenkins for CI/CD

### Quick Deployment
```bash
# 1. Clone the repository
git checkout https://github.com/GokhanSaygin/Bank-Infrastructure-Project.git
cd Bank-Infrastructure-Project

# 2. Configure AWS credentials
aws configure

# 3. Initialize Terraform
terraform init

# 4. Set environment variables
export TF_VAR_environment="dev"
export TF_VAR_vpc_cidr="10.1.0.0/16"
export TF_VAR_public_subnet_cidr="10.1.1.0/24"
export TF_VAR_public_subnet_2_cidr="10.1.2.0/24"
export TF_VAR_private_app_subnet_1_cidr="10.1.11.0/24"
export TF_VAR_private_app_subnet_2_cidr="10.1.12.0/24"
export TF_VAR_private_db_subnet_1_cidr="10.1.21.0/24"
export TF_VAR_private_db_subnet_2_cidr="10.1.22.0/24"

# 5. Review the plan
terraform plan

# 6. Deploy infrastructure
terraform apply

# 7. When done, destroy to avoid costs
terraform destroy
```

### Jenkins CI/CD Setup

See [JENKINS_SETUP.md](docs/JENKINS_SETUP.md) for detailed CI/CD configuration.

---

## 🐛 Challenges & Solutions

### Challenge 1: RDS Free Tier Limitation

**Problem:** AWS Limited Free Plan didn't support RDS deployment via Terraform API.
```
Error: FreeTierRestrictionError: This instance size isn't available 
with free plan accounts.
```

**Solution:** 
- Adapted sprint priorities (agile methodology)
- Proceeded with EC2 deployment
- Reserved database tier for future enhancement
- **Learning:** Real-world constraint management and sprint re-prioritization

---

### Challenge 2: EC2 Instance Type Eligibility

**Problem:** t2.micro was not eligible for Free Tier in Limited Free Plan account.
```
Error: The specified instance type is not eligible for Free Tier.
```

**Solution:**
- Investigated alternative instance types
- Switched to t3.micro (newer generation)
- Successfully deployed with t3.micro
- **Learning:** Problem-solving and AWS account type awareness

---

### Challenge 3: Multi-Environment State Management

**Problem:** Managing separate Terraform states for 3 environments.

**Solution:**
- Implemented S3 backend with separate state files
- Branch-specific state keys: `bank-infra/{branch}.tfstate`
- Jenkins automatically configures correct backend per environment
- **Learning:** Terraform backend configuration and state isolation

---

## 🎓 Learning Outcomes

### Technical Skills Acquired

- ✅ **Infrastructure as Code (IaC)** - Terraform best practices
- ✅ **AWS Networking** - VPC, Subnets, Route Tables, IGW
- ✅ **AWS Compute** - EC2, IAM, User Data, AMI selection
- ✅ **AWS Monitoring** - CloudWatch, SNS, Alarms, Dashboards
- ✅ **CI/CD Pipelines** - Jenkins multi-branch, automated deployments
- ✅ **Git Workflow** - Feature branches, pull requests, code reviews
- ✅ **Security Best Practices** - Network isolation, least privilege, encryption

### Soft Skills Developed

- ✅ **Problem-Solving** - Overcame AWS account limitations
- ✅ **Agile Methodology** - Sprint planning and re-prioritization
- ✅ **Cost Optimization** - Free Tier maximization strategies
- ✅ **Documentation** - Comprehensive README and code comments
- ✅ **Real-World Constraints** - Working within platform limitations

---

## 🔮 Future Enhancements

### Phase 1: Load Balancing & Auto Scaling
- [ ] Application Load Balancer (ALB)
- [ ] Target Groups
- [ ] Auto Scaling Group
- [ ] Launch Templates

### Phase 2: Database Layer
- [ ] RDS PostgreSQL (Multi-AZ)
- [ ] Read Replicas
- [ ] Automated Backups
- [ ] Database Migration Scripts

### Phase 3: Advanced Monitoring
- [ ] Custom CloudWatch Metrics
- [ ] AWS X-Ray integration
- [ ] Log Aggregation (ELK Stack)
- [ ] Grafana Dashboards

### Phase 4: Security Enhancements
- [ ] AWS WAF (Web Application Firewall)
- [ ] AWS Shield (DDoS protection)
- [ ] AWS Secrets Manager
- [ ] AWS Certificate Manager (SSL/TLS)

### Phase 5: Additional Services
- [ ] Route53 (DNS management)
- [ ] CloudFront (CDN)
- [ ] S3 (Static assets)
- [ ] AWS Backup (Automated backups)

---

## 👨‍💻 Author

**Gokhan Saygin**  
Cloud Engineer | DevOps Enthusiast | AWS Certified (in progress)

- 🌐 Portfolio: [Your Website]
- 💼 LinkedIn: [Your LinkedIn]
- 📧 Email: [Your Email]
- 🐙 GitHub: [@GokhanSaygin](https://github.com/GokhanSaygin)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- AWS Free Tier for enabling hands-on learning
- HashiCorp Terraform documentation
- AWS Well-Architected Framework
- DevOps community for best practices

---

## ⚠️ Important Notice

**This infrastructure is currently destroyed for cost optimization.** All code is maintained in this repository and can be deployed at any time using Terraform. Deployment takes approximately 10-15 minutes.

To deploy: `terraform apply`  
To destroy: `terraform destroy`

---

<p align="center">
  <strong>⭐ If you find this project helpful, please consider giving it a star! ⭐</strong>
</p>

<p align="center">
  Made with ❤️ by Ahmet Gokhan Saygin
</p>
```

---

#