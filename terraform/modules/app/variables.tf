variable "project_name" {
  type        = string
  description = "Name prefix for resources."
}

variable "environment" {
  type        = string
  description = "Environment name."
}

variable "ami_id" {
  type        = string
  description = "AMI ID for app instances."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
}

variable "key_name" {
  type        = string
  description = "Optional EC2 key pair name."
  default     = null
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the target group."
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs for ALB."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for app instances."
}

variable "alb_security_group_id" {
  type        = string
  description = "ALB security group ID."
}

variable "app_security_group_id" {
  type        = string
  description = "App instance security group ID."
}
