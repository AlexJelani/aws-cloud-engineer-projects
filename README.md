# AWS Cloud Engineer Portfolio Projects

This repository turns three resume projects into one deployable portfolio:

1. **Highly available AWS architecture**: VPC, public/private subnets, ALB, Auto Scaling, EC2, RDS, S3, CloudWatch.
2. **Terraform infrastructure automation**: reusable modules, variables, outputs, environment separation, repeatable deployment.
3. **CI/CD pipeline**: GitHub source, CodeBuild validation, CodeDeploy rolling deployments, health checks, rollback-ready structure.

The goal is to demonstrate the full cloud engineering lifecycle: design, deploy, automate, monitor, and ship changes safely.

## Repository Layout

```text
app/                         Sample web app and CodeDeploy hooks
docs/                        Architecture, interview notes, and diagrams
terraform/
  environments/prod/         Production-style environment composition
  modules/                   Reusable Terraform modules
.github/workflows/           Local validation workflow for app and Terraform
```

## Prerequisites

- AWS account with permission to create VPC, EC2, ALB, Auto Scaling, RDS, S3, IAM, CodeBuild, CodeDeploy, CodePipeline, and CloudWatch resources
- Terraform 1.6 or newer
- AWS CLI configured locally
- AWS CodeStar connection to GitHub for CodePipeline source integration
- An EC2 key pair if you want direct SSH access for troubleshooting

## Deploy

```bash
cd terraform/environments/prod
terraform init
terraform plan -out tfplan
terraform apply tfplan
```

Set required variables either in `terraform.tfvars`, environment variables, or your CI system:

```hcl
project_name             = "cloud-portfolio"
aws_region               = "us-east-1"
github_owner             = "your-github-user"
github_repo              = "aws-cloud-engineer-projects"
github_branch            = "main"
github_connection_arn    = "arn:aws:codestar-connections:us-east-1:123456789012:connection/example"
db_username              = "appadmin"
db_password              = "replace-with-a-long-secret"
ec2_key_name             = "optional-existing-keypair"
```

## What This Proves

- **Architecture**: multi-AZ networking, public/private subnet boundaries, managed database placement, load balancing, and scaling policies.
- **Automation**: repeatable infrastructure with modules, variables, outputs, and explicit dependencies.
- **Operations**: CloudWatch dashboards and alarms for unhealthy hosts, high CPU, and database CPU.
- **DevOps**: source-triggered build and deployment pipeline with health checks and rolling deployments.

## Interview Summary

> I designed and automated a production-style AWS web platform across two availability zones. The application runs behind an Application Load Balancer with an Auto Scaling Group, private RDS storage, CloudWatch monitoring, and a CodePipeline-based delivery workflow. Terraform modules make the environment repeatable, and the deployment strategy allows updates to roll out gradually while health checks protect availability.

## Cost Note

This project creates billable AWS resources. Destroy the environment when finished:

```bash
cd terraform/environments/prod
terraform destroy
```
