output "alb_dns_name" {
  description = "Public DNS name of the application load balancer."
  value       = module.app.alb_dns_name
}

output "cloudwatch_dashboard_name" {
  description = "CloudWatch dashboard for the project."
  value       = module.monitoring.dashboard_name
}

output "codepipeline_name" {
  description = "CodePipeline name for application delivery."
  value       = module.pipeline.pipeline_name
}

