# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name = "${var.environment}-db-subnet-group"
  subnet_ids = [
    aws_subnet.private_db_1.id,
    aws_subnet.private_db_2.id
  ]

  tags = {
    Name        = "${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

# RDS PostgreSQL Instance (FREE TIER OPTIMIZED!)
resource "aws_db_instance" "main" {
  identifier = "${var.environment}-bank-postgres"

  # Engine
  engine         = "postgres"
  engine_version = "16.3"
  instance_class = "db.t2.micro" # FREE TIER! (750 hours/month)

  # Storage (FREE TIER: 20GB gp2)
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp2" # FREE TIER storage type!
  storage_encrypted     = true

  # Database
  db_name  = "bankdb"
  username = "bankadmin"
  password = "TempPassword123!" # Change after first login!
  port     = 5432

  # Network
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db_tier.id]
  publicly_accessible    = false # NEVER expose to internet!

  # Multi-AZ (Disabled for free tier)
  # Production: Set to true for high availability
  multi_az = false

  # Backup (FREE TIER: 7 days retention)
  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"

  # Snapshots
  skip_final_snapshot       = true
  final_snapshot_identifier = "${var.environment}-bank-db-final"
  copy_tags_to_snapshot     = true

  # Logs (FREE TIER compatible)
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  # Deletion protection (Disabled for learning)
  # Production: Set to true!
  deletion_protection = false

  # Apply changes immediately (for learning)
  # Production: Set to false (apply during maintenance window)
  apply_immediately = true

  tags = {
    Name        = "${var.environment}-bank-postgres"
    Environment = var.environment
    Workload    = "Banking-Database"
  }
}