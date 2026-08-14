# Interview Guide

## Resume Bullet

Architected and automated a highly available AWS web platform using Terraform, VPC, ALB, Auto Scaling, EC2, RDS Multi-AZ, CloudWatch alarms, and CodePipeline, enabling repeatable deployments with rolling releases and health-check validation.

## Project Walkthrough

The business need was a web application that could stay available during instance failures and scale during traffic spikes. I built a two-AZ network with public, private, and database subnets. The ALB receives internet traffic and only forwards it to healthy EC2 instances in the Auto Scaling Group. The database runs privately with Multi-AZ enabled, and CloudWatch alarms track application and database health.

I then converted the architecture into Terraform modules so the environment can be reviewed with `terraform plan`, deployed consistently with `terraform apply`, and reused by changing variables. Finally, I added a pipeline that pulls source from GitHub, runs tests in CodeBuild, deploys with CodeDeploy, and relies on health checks before considering a release successful.

## Trade-Offs To Discuss

- EC2 and CodeDeploy were used to demonstrate compute, deployment agents, load balancer health checks, and rolling deployment mechanics. For less operational overhead, ECS or Elastic Beanstalk could be a good next iteration.
- NAT gateways improve private subnet patching and dependency access, but they add fixed cost. For a demo account, one NAT gateway can reduce cost; for production, one per AZ improves resilience.
- RDS Multi-AZ improves availability, but it increases database cost. For a short-lived portfolio demo, use a small instance class and destroy the stack afterward.
- The sample app is intentionally small so the infrastructure and delivery workflow remain the focus.

## Questions You Should Be Ready For

- Why did you separate public, private, and database subnets?
- How does the ALB decide whether an instance is healthy?
- What happens when CPU exceeds the scale-out threshold?
- How would you scale this architecture to support much higher traffic?
- What would you monitor first during a production incident?
- How would you make secrets management stronger?
- How would you reduce cost for a non-production environment?

