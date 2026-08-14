output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.this.name
}

output "load_balancer_arn_suffix" {
  value = aws_lb.this.arn_suffix
}

output "target_group_arn_suffix" {
  value = aws_lb_target_group.this.arn_suffix
}

output "codedeploy_app_name" {
  value = aws_codedeploy_app.this.name
}

output "codedeploy_group_name" {
  value = aws_codedeploy_deployment_group.this.deployment_group_name
}

