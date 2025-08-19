# 3-Tier Web Application Infrastructure

AWS 3-tier architecture with Terraform including web, application, and database layers.

## Architecture

- **Web Tier**: Public subnets with ALB and Auto Scaling Groups
- **App Tier**: Private subnets with internal ALB and Auto Scaling Groups  
- **Database Tier**: RDS MySQL in private subnets

## Prerequisites

- AWS CLI configured
- Terraform installed
- SSH key pair created

## Deployment

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