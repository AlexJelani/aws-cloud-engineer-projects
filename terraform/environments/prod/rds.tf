# RDS database for the portfolio backend tier.

resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = [for subnet in aws_subnet.isolated : subnet.id]

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}

resource "aws_secretsmanager_secret" "db_password" {
  name        = "${var.project_name}-${var.environment}-db-password"
  description = "Database password for the ${var.project_name}-${var.environment} application"

  tags = {
    Name = "${var.project_name}-${var.environment}-db-password"
  }
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}

resource "aws_db_instance" "this" {
  identifier             = "${var.project_name}-${var.environment}-db"
  engine                 = var.db_engine
  engine_version         = var.db_engine == "mysql" ? "8.0" : "15.4"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = var.multi_az
  deletion_protection    = false

  tags = {
    Name = "${var.project_name}-${var.environment}-db"
  }
}
