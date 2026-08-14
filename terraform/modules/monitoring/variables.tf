variable "project_name" {
  type        = string
  description = "Name prefix for resources."
}

variable "autoscaling_group_name" {
  type        = string
  description = "Auto Scaling group name."
}

variable "load_balancer_arn_suffix" {
  type        = string
  description = "ALB ARN suffix for CloudWatch dimensions."
}

variable "target_group_arn_suffix" {
  type        = string
  description = "Target group ARN suffix for CloudWatch dimensions."
}

variable "database_instance_identifier" {
  type        = string
  description = "RDS instance identifier."
}

