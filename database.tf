# ============================================================================
# DATABASE LAYER - RDS PostgreSQL
# ============================================================================
# NOTE: This database layer was designed but not deployed due to AWS Limited
# Free Plan constraints. The infrastructure code demonstrates best practices
# for RDS PostgreSQL deployment in a banking environment.
#
# If deployed, this would create:
# - RDS PostgreSQL 16.3 instance
# - Multi-AZ capability (configured for single-AZ to optimize costs)
# - Encrypted storage (gp2)
# - Automated backups (optional)
# - Private subnet deployment
# - Security group integration
# ============================================================================

# DB Subnet Group - Spans multiple AZs for Multi-AZ deployment
resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = [aws_subnet.private_db_1.id, aws_subnet.private_db_2.id]

  tags = {
    Name        = "${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

# RDS PostgreSQL Instance
resource "aws_db_instance" "main" {
  # Instance Configuration
  identifier     = "${var.environment}-bank-postgres"
  engine         = "postgres"
  engine_version = "16.3"
  instance_class = "db.t3.micro" # Free Tier eligible (750 hours/month)

  # Database Configuration
  db_name  = "bankdb"
  username = "bankadmin"
  password = "ChangeMe123!" # In production, use AWS Secrets Manager

  # Storage Configuration
  allocated_storage     = 20  # GB - Free Tier: up to 20GB
  max_allocated_storage = 100 # Auto-scaling limit
  storage_type          = "gp2"
  storage_encrypted     = true

  # Network Configuration
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db_tier.id]
  publicly_accessible    = false # Private subnet only

  # High Availability (Disabled for cost optimization)
  multi_az = false # Set to true for production

  # Backup Configuration
  backup_retention_period = 7    # Days (0 for Free Tier)
  backup_window           = "03:00-04:00"
  maintenance_window      = "mon:04:00-mon:05:00"
  skip_final_snapshot     = true # For development
  final_snapshot_identifier = "${var.environment}-bank-db-final"

  # Deletion Protection (Disabled for development)
  deletion_protection = false # Enable for production

  # Performance & Monitoring
  performance_insights_enabled = false # Not available in Free Tier
  monitoring_interval          = 0     # 0 disables enhanced monitoring
  enabled_cloudwatch_logs_exports = [
    "postgresql",
    "upgrade"
  ]

  # Automatic Updates
  auto_minor_version_upgrade = true
  apply_immediately          = true

  # Metadata
  tags = {
    Name        = "${var.environment}-bank-postgres"
    Environment = var.environment
    Workload    = "Banking-Database"
  }
}

# Output - Database Endpoint
output "database_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = aws_db_instance.main.endpoint
  sensitive   = false
}

output "database_name" {
  description = "Database name"
  value       = aws_db_instance.main.db_name
}

output "database_port" {
  description = "Database port"
  value       = aws_db_instance.main.port
}
