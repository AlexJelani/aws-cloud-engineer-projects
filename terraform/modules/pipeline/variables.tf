variable "project_name" {
  type        = string
  description = "Name prefix for resources."
}

variable "github_owner" {
  type        = string
  description = "GitHub repository owner."
}

variable "github_repo" {
  type        = string
  description = "GitHub repository name."
}

variable "github_branch" {
  type        = string
  description = "GitHub branch."
}

variable "github_connection_arn" {
  type        = string
  description = "CodeStar connection ARN for GitHub source integration."
}

variable "codedeploy_app_name" {
  type        = string
  description = "CodeDeploy application name."
}

variable "codedeploy_group_name" {
  type        = string
  description = "CodeDeploy deployment group name."
}
