variable "project_name" {
  type        = string
  description = "Name prefix for resources."
}

variable "db_subnet_ids" {
  type        = list(string)
  description = "Private database subnet IDs."
}

variable "database_security_group_id" {
  type        = string
  description = "Database security group ID."
}

variable "db_username" {
  type        = string
  description = "Database username."
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "Database password."
  sensitive   = true
}
