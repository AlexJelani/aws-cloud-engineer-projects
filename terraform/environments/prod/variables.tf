variable "project_name" {
  type        = string
  description = "Name prefix for project resources."
  default     = "cloud-portfolio"
}

variable "environment" {
  type        = string
  description = "Deployment environment name."
  default     = "prod"
}

variable "aws_region" {
  type        = string
  description = "AWS region for deployment."
  default     = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
  default     = "10.40.0.0/16"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for application servers."
  default     = "t3.micro"
}

variable "ec2_key_name" {
  type        = string
  description = "Optional EC2 key pair name for SSH troubleshooting."
  default     = null
}

variable "db_username" {
  type        = string
  description = "RDS username."
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "RDS password."
  sensitive   = true
}

variable "github_owner" {
  type        = string
  description = "GitHub repository owner for CodePipeline."
}

variable "github_repo" {
  type        = string
  description = "GitHub repository name for CodePipeline."
}

variable "github_branch" {
  type        = string
  description = "GitHub branch watched by CodePipeline."
  default     = "main"
}

variable "github_connection_arn" {
  type        = string
  description = "CodeStar connection ARN for GitHub source integration."
}
