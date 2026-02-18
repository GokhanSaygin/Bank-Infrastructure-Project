# Security Group - Web Tier (for future ALB)
resource "aws_security_group" "web_tier" {
  name        = "${var.environment}-web-tier-sg"
  description = "Security group for web tier (ALB)"
  vpc_id      = aws_vpc.main.id

  # HTTP from internet
  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS from internet
  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-web-tier-sg"
    Environment = var.environment
    Tier        = "Web"
  }
}

# Security Group - App Tier (for future EC2 instances)
resource "aws_security_group" "app_tier" {
  name        = "${var.environment}-app-tier-sg"
  description = "Security group for application tier (EC2)"
  vpc_id      = aws_vpc.main.id

  # Allow traffic from web tier only
  ingress {
    description     = "Traffic from web tier"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web_tier.id]
  }

  # Allow SSH from within VPC (for maintenance)
  ingress {
    description = "SSH from within VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-app-tier-sg"
    Environment = var.environment
    Tier        = "Application"
  }
}

# Security Group - Database Tier (for future RDS)
resource "aws_security_group" "db_tier" {
  name        = "${var.environment}-db-tier-sg"
  description = "Security group for database tier (RDS PostgreSQL)"
  vpc_id      = aws_vpc.main.id

  # PostgreSQL from app tier only
  ingress {
    description     = "PostgreSQL from app tier"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_tier.id]
  }

  # No outbound rules needed for RDS
  # (RDS doesn't initiate outbound connections in typical setup)
  egress {
    description = "Allow outbound for database maintenance"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-db-tier-sg"
    Environment = var.environment
    Tier        = "Database"
  }
}
