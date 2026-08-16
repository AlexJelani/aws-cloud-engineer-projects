output "alb_dns_name" {
  description = "Public URL for the application load balancer."
  value       = aws_lb.this.dns_name
}

output "frontend_ecr_repo_url" {
  description = "Repository URL for the frontend ECR image."
  value       = aws_ecr_repository.frontend.repository_url
}

output "backend_ecr_repo_url" {
  description = "Repository URL for the backend ECR image."
  value       = aws_ecr_repository.backend.repository_url
}

output "rds_endpoint" {
  description = "Endpoint for the RDS database."
  value       = aws_db_instance.this.address
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster."
  value       = aws_ecs_cluster.this.name
}

