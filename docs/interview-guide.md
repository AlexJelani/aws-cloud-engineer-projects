# Interview Guide

## Resume Bullet

Designed and automated a secure, production-style AWS application using Terraform, VPC networking, ECS Fargate, Application Load Balancer health checks, private RDS storage, ECR image management, and AWS Secrets Manager to deliver repeatable container deployments with strong operational safeguards.

## Project Walkthrough

The business need was a web application that could run reliably in a private AWS network while remaining publicly reachable and easy to update. I built a VPC with public subnets for the ALB, private subnets for containerized frontend and backend services, and isolated subnets for the database. The frontend and backend each run as ECS Fargate tasks, with the ALB routing requests and validating health before sending traffic.

I then moved the infrastructure to Terraform so the environment can be reviewed with `terraform plan`, deployed consistently with `terraform apply`, and changed safely by updating variables and image tags. For database credentials, I moved from plaintext values to AWS Secrets Manager and wired ECS task execution to retrieve them securely. I also validated the real-world deployment issue where the frontend image was built for the wrong architecture, proving the importance of Linux amd64 image builds and careful runtime validation in Fargate.

## Trade-Offs To Discuss

- ECS Fargate reduces EC2 patching and operating system management, but it changes how you think about instance-level tuning and autoscaling decisions compared with EC2-based architectures.
- VPC endpoints improve security and private network isolation, but they require more careful design and awareness of AWS service dependencies.
- Secrets Manager is safer than environment variables for sensitive values, though it adds a dependency on IAM and KMS permissions during task startup.
- Exact ECR image tags increase deployment traceability and rollback safety, but they require deliberate updates during release cycles.
- The example application stays small so the emphasis remains on architecture and operations rather than app complexity.

## Questions You Should Be Ready For

- Why did you separate public, private, and database subnets?
- How does the ALB decide whether a container is healthy?
- Why use ECS Fargate instead of EC2 for this workload?
- How do VPC endpoints help with private networking?
- What is the security benefit of retrieving database credentials from Secrets Manager?
- How would you handle a frontend container failing with an exec format error?
- What would you monitor first during a production incident?
- How would you reduce cost for a non-production environment?

