# CloudWatch log groups for each ECS service.

resource "aws_cloudwatch_log_group" "frontend" {
  name              = "/ecs/frontend"
  retention_in_days = 7

  tags = {
    Name = "${var.project_name}-${var.environment}-frontend-logs"
  }
}

resource "aws_cloudwatch_log_group" "backend" {
  name              = "/ecs/backend"
  retention_in_days = 7

  tags = {
    Name = "${var.project_name}-${var.environment}-backend-logs"
  }
}
