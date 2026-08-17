# AWS Cloud Engineer Portfolio Projects

This repository demonstrates a production-style AWS workload built around a containerized portfolio application deployed on ECS Fargate. The stack emphasizes secure networking, container lifecycle management, infrastructure as code, and operational troubleshooting.

## Current Architecture

1. **Container platform**: Dockerized Node.js app deployed to ECS Fargate behind an Application Load Balancer.
2. **Networking**: public and private subnets, isolated database subnets, and VPC endpoints for ECR, CloudWatch Logs, Secrets Manager, and KMS.
3. **Data layer**: private MySQL RDS instance with credentials supplied via AWS Secrets Manager.
4. **Delivery and automation**: Terraform-managed infrastructure with environment variables and exact ECR image tags for controlled upgrades.
5. **Operations**: CloudWatch log groups, ALB health checks, and ECS deployment monitoring.

The goal is to demonstrate the full cloud engineering lifecycle: design, deploy, secure, troubleshoot, and iterate safely.

## Repository Layout

```text
app/                         Containerized Node.js web app and Docker build files
docs/                       Architecture and interview notes
terraform/
  environments/prod/        Production Terraform configuration
  modules/                  Reusable Terraform modules
```

## Prerequisites

- AWS account with permission to create VPCs, subnets, ALB, ECS, ECR, IAM, RDS, Secrets Manager, KMS, and CloudWatch resources
- Terraform 1.6 or newer
- AWS CLI configured locally
- Docker Desktop or Docker Engine with buildx support for amd64 image builds

## Deploy

```bash
cd terraform/environments/prod
terraform init
terraform plan -var-file=terraform.tfvars -out=tfplan
terraform apply -auto-approve tfplan
```

Set required values in `terraform.tfvars` or environment variables:

```hcl
project_name           = "cloud-portfolio"
environment            = "prod"
aws_region             = "us-east-1"
vpc_cidr               = "10.40.0.0/16"
frontend_image_uri     = "084847996020.dkr.ecr.us-east-1.amazonaws.com/cloud-portfolio-prod-frontend:20260817120000"
backend_image_uri      = "084847996020.dkr.ecr.us-east-1.amazonaws.com/cloud-portfolio-prod-backend:20260816221620"
db_name                = "appdb"
db_username            = "appadmin"
db_password            = "YourStrongPassword123!"
```

## Docker Image Note

For ECS Fargate on Linux, the frontend image must be built for `linux/amd64`:

```bash
cd app
aws ecr get-login-password --region us-east-1 --profile iamadmin-dev \
  | docker login --username AWS --password-stdin 084847996020.dkr.ecr.us-east-1.amazonaws.com

docker buildx build \
  --platform linux/amd64 \
  -t 084847996020.dkr.ecr.us-east-1.amazonaws.com/cloud-portfolio-prod-frontend:20260817120000 \
  --push .
```

## What This Proves

- **Architecture**: VPC isolation, public/private networking, ALB routing, Fargate task placement, and private database access.
- **Security**: secret delivery through AWS Secrets Manager instead of plaintext environment values, and VPC endpoints for AWS service access.
- **Automation**: repeatable infrastructure with Terraform, explicit image tags, and predictable environment configuration.
- **Operations**: ALB health checks, ECS deployment tracking, CloudWatch log review, and rapid issue isolation.

## Interview Summary

> I designed and automated a container-based AWS application using Terraform, VPC layering, ECS Fargate, Application Load Balancer routing, private RDS storage, and AWS Secrets Manager. The frontend and backend each run as independent tasks in private subnets, while the ALB exposes the public entry point and health verification confirms service availability. I also resolved a real deployment issue caused by an architecture mismatch in the frontend container, reinforcing the importance of production-safe image builds and operational validation.

## Cost Note

This project creates billable AWS resources. Destroy the environment when finished:

```bash
cd terraform/environments/prod
terraform destroy
```
