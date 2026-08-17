variable "github_owner" {
  description = "GitHub repository owner used by CodePipeline source action."
  type        = string
  default     = "user"
}

variable "github_repo" {
  description = "GitHub repository name used by CodePipeline source action."
  type        = string
  default     = "aws-cloud-engineer-projects"
}

variable "github_branch" {
  description = "GitHub branch to watch for CodePipeline source events."
  type        = string
  default     = "main"
}

variable "github_connection_arn" {
  description = "CodeStar connection ARN for GitHub access in CodePipeline."
  type        = string
  default     = "arn:aws:codeconnections:us-east-1:084847996020:connection/78aa534b-0983-44cc-b3d7-be3d5d5563b1"
}
