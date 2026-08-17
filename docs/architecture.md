# Architecture

## ECS Fargate Production Deployment

```mermaid
flowchart TB
  user["Users"] --> alb["Application Load Balancer"]
  alb --> frontend["Frontend ECS task\nprivate subnet"]
  alb --> api["Backend ECS task\nprivate subnet"]

  frontend --> rds["RDS MySQL\nisolated subnet"]
  api --> rds

  frontend --> logs["CloudWatch Logs\n/frontend"]
  api --> logs
  frontend --> ecr["ECR image repo"]
  api --> ecr

  secret["Secrets Manager\nDB credentials"] --> api
  vpc["VPC endpoints\nECR / Logs / Secrets / KMS"] --> frontend
  vpc --> api

  alb --> cw["CloudWatch monitoring"]
  rds --> cw
```

## Design Choices

- The VPC spans two availability zones for resilience and complete private networking.
- Public subnets host the ALB and internet-facing entry point.
- Private application subnets host ECS Fargate tasks for the frontend and backend.
- Isolated database subnets host the RDS instance to limit direct access.
- Security groups restrict ALB ingress, frontend-to-backend traffic, and database connectivity to required paths only.
- AWS Secrets Manager stores the database password instead of injecting plaintext credentials into container environment variables.
- VPC endpoints keep private tasks connected to ECR, CloudWatch Logs, Secrets Manager, and KMS without NAT gateways.
- ECS task definitions use exact ECR image tags so deployments remain stable and traceable.

## Deployment Flow

```mermaid
sequenceDiagram
  participant Dev as Developer
  participant ECR as ECR Repository
  participant TF as Terraform
  participant ECS as ECS Fargate
  participant ALB as Application Load Balancer
  participant RDS as RDS MySQL

  Dev->>ECR: Build and push Docker image
  Dev->>TF: Update image tag and apply
  TF->>ECS: Update task definition and service
  ECS->>ALB: Register healthy targets
  ALB->>ECS: Route frontend requests
  ECS->>RDS: Connect using Secrets Manager credentials
  ALB-->>Dev: Health and routing confirmation
```

