variable "project_name" {
  description = "Name prefix used for project resources."
  type        = string
  default     = "cloud-portfolio"
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "portfolio"
}

variable "aws_region" {
  description = "AWS region for the environment."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the main VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "frontend_image_uri" {
  description = "URI for the frontend container image in ECR."
  type        = string
}

variable "backend_image_uri" {
  description = "URI for the backend container image in ECR."
  type        = string
}

variable "db_name" {
  description = "The database name for the application."
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Database master username."
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "db_password" {
  description = "Database master password."
  type        = string
  sensitive   = true
}

variable "db_engine" {
  description = "Database engine to provision. Supported values: mysql or postgres."
  type        = string
  default     = "mysql"

  validation {
    condition     = contains(["mysql", "postgres"], var.db_engine)
    error_message = "db_engine must be either mysql or postgres."
  }
}

variable "multi_az" {
  description = "Set to true to enable RDS Multi-AZ."
  type        = bool
  default     = false
}

variable "app_cpu" {
  description = "CPU units for each Fargate task definition."
  type        = number
  default     = 256
}

variable "app_memory" {
  description = "Memory for each Fargate task definition in MiB."
  type        = number
  default     = 512
}

variable "frontend_desired_count" {
  description = "Desired number of frontend tasks."
  type        = number
  default     = 2
}

variable "backend_desired_count" {
  description = "Desired number of backend tasks."
  type        = number
  default     = 2
}
