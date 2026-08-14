# Architecture

## Production-Style AWS Project

```mermaid
flowchart TB
  user["Users"] --> alb["Application Load Balancer"]
  alb --> asg["Auto Scaling Group"]
  asg --> ec2a["EC2 app instance AZ A"]
  asg --> ec2b["EC2 app instance AZ B"]
  ec2a --> rds["RDS Multi-AZ database"]
  ec2b --> rds
  alb --> cw["CloudWatch metrics and alarms"]
  asg --> cw
  rds --> cw
  s3["S3 static assets bucket"] --> user
```

## Design Choices

- The VPC spans two availability zones to tolerate an AZ-level failure.
- Public subnets host the ALB and NAT gateways.
- Private application subnets host EC2 instances.
- Isolated database subnets host RDS.
- Security groups allow HTTP from the internet to the ALB, application traffic from the ALB to EC2, and database traffic from EC2 to RDS.
- Auto Scaling policies scale out near 70 percent CPU and scale in near 40 percent CPU.
- CloudWatch alarms surface unhealthy targets, high CPU, and database pressure.

## CI/CD Flow

```mermaid
sequenceDiagram
  participant Dev as Developer
  participant GH as GitHub
  participant CP as CodePipeline
  participant CB as CodeBuild
  participant CD as CodeDeploy
  participant ALB as ALB Health Checks

  Dev->>GH: Push application change
  GH->>CP: Source revision available
  CP->>CB: Run npm install and tests
  CB-->>CP: Build artifact
  CP->>CD: Start rolling deployment
  CD->>ALB: Validate service health
  ALB-->>CD: Healthy target response
  CD-->>CP: Deployment succeeded
```

