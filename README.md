# 3-Tier Web Application Infrastructure

AWS 3-tier architecture with Terraform including web, application, and database layers.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                              VPC (10.0.0.0/16)                     │
├─────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐    ┌─────────────────┐                        │
│  │  Public Subnet  │    │  Public Subnet  │                        │
│  │ (10.0.101.0/24) │    │ (10.0.102.0/24) │                        │
│  │      ASG        │    │      ASG        │                        │
│  └─────────────────┘    └─────────────────┘                        │
│           │                       │                                 │
│           └───────────┬───────────┘                                 │
│                       │                                             │
│                 ┌─────────────┐                                     │
│                 │ Public ALB  │                                     │
│                 └─────────────┘                                     │
│                       │                                             │
│  ┌─────────────────┐  │  ┌─────────────────┐                       │
│  │ Private Subnet  │  │  │ Private Subnet  │                       │
│  │ (10.0.1.0/24)   │  │  │ (10.0.2.0/24)   │                       │
│  │      ASG        │  │  │      ASG        │                       │
│  └─────────────────┘  │  └─────────────────┘                       │
│           │            │           │                                │
│           └────────────┼───────────┘                                │
│                        │                                            │
│                 ┌─────────────┐                                     │
│                 │ Private ALB │                                     │
│                 └─────────────┘                                     │
│                        │                                            │
│  ┌─────────────────┐   │   ┌─────────────────┐                     │
│  │  DB Subnet 1    │   │   │  DB Subnet 2    │                     │
│  │ (10.0.3.0/24)   │   │   │ (10.0.4.0/24)   │                     │
│  └─────────────────┘   │   └─────────────────┘                     │
│           │             │             │                             │
│           └─────────────┼─────────────┘                             │
│                         │                                           │
│                   ┌─────────────┐                                   │
│                   │ RDS MySQL   │                                   │
│                   └─────────────┘                                   │
└─────────────────────────────────────────────────────────────────────┘
```

## Architecture

- **Web Tier**: Public subnets with ALB and Auto Scaling Groups
- **App Tier**: Private subnets with internal ALB and Auto Scaling Groups  
- **Database Tier**: RDS MySQL in private subnets

## Remote Backend

This project uses S3 remote backend for Terraform state management:
- **S3 Bucket**: Stores terraform.tfstate file
- **DynamoDB**: Provides state locking
- **Encryption**: State file encrypted at rest

## Prerequisites

- AWS CLI configured
- Terraform installed
- SSH key pair created

## Deployment

1. Configure remote backend:
```bash
cd remote_backend
terraform init
terraform apply
```

2. Deploy infrastructure:
```bash
terraform init
terraform plan
terraform apply
```

## Resources Created

- VPC with public/private subnets across 2 AZs
- Internet Gateway and NAT Gateway
- Security Groups for web, app, and database tiers
- Application Load Balancers (public and private)
- Auto Scaling Groups with Launch Templates
- RDS MySQL database

## Variables

- `env`: Environment name (default: "Dev")
- `instance_type`: EC2 instance type (default: "t2.micro")
- `instance_ami`: AMI ID for instances

## Cleanup

```bash
terraform destroy
```