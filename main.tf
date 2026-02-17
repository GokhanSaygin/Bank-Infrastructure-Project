# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name        = "${var.environment}-bank-vpc"
    Environment = var.environment
    Project     = "Banking-Infrastructure"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}

# Public Subnet 1 (us-east-1a)
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  
  tags = {
    Name        = "${var.environment}-public-subnet-1a"
    Environment = var.environment
    Type        = "Public"
  }
}

# Public Subnet 2 (us-east-1b)
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2_cidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  
  tags = {
    Name        = "${var.environment}-public-subnet-1b"
    Environment = var.environment
    Type        = "Public"
  }
}

# Private Subnet 1 (Application Tier - us-east-1a)
resource "aws_subnet" "private_app_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_app_subnet_1_cidr
  availability_zone = "us-east-1a"
  
  tags = {
    Name        = "${var.environment}-private-app-subnet-1a"
    Environment = var.environment
    Type        = "Private-App"
  }
}

# Private Subnet 2 (Application Tier - us-east-1b)
resource "aws_subnet" "private_app_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_app_subnet_2_cidr
  availability_zone = "us-east-1b"
  
  tags = {
    Name        = "${var.environment}-private-app-subnet-1b"
    Environment = var.environment
    Type        = "Private-App"
  }
}

# Private Subnet 3 (Database Tier - us-east-1a)
resource "aws_subnet" "private_db_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_subnet_1_cidr
  availability_zone = "us-east-1a"
  
  tags = {
    Name        = "${var.environment}-private-db-subnet-1a"
    Environment = var.environment
    Type        = "Private-Database"
  }
}

# Private Subnet 4 (Database Tier - us-east-1b)
resource "aws_subnet" "private_db_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_subnet_2_cidr
  availability_zone = "us-east-1b"
  
  tags = {
    Name        = "${var.environment}-private-db-subnet-1b"
    Environment = var.environment
    Type        = "Private-Database"
  }
}

# Route Table - Public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  
  tags = {
    Name        = "${var.environment}-public-rt"
    Environment = var.environment
  }
}

# Route Table - Private (NAT Gateway olmadan)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name        = "${var.environment}-private-rt"
    Environment = var.environment
  }
}

# Route Table Association - Public Subnet 1
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Route Table Association - Public Subnet 2
resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# Route Table Association - Private App Subnet 1
resource "aws_route_table_association" "private_app_1" {
  subnet_id      = aws_subnet.private_app_1.id
  route_table_id = aws_route_table.private.id
}

# Route Table Association - Private App Subnet 2
resource "aws_route_table_association" "private_app_2" {
  subnet_id      = aws_subnet.private_app_2.id
  route_table_id = aws_route_table.private.id
}

# Route Table Association - Private DB Subnet 1
resource "aws_route_table_association" "private_db_1" {
  subnet_id      = aws_subnet.private_db_1.id
  route_table_id = aws_route_table.private.id
}

# Route Table Association - Private DB Subnet 2
resource "aws_route_table_association" "private_db_2" {
  subnet_id      = aws_subnet.private_db_2.id
  route_table_id = aws_route_table.private.id
}

# VPC Flow Logs (Security için - tüm network trafiği loglanır)
resource "aws_flow_log" "main" {
  iam_role_arn    = aws_iam_role.vpc_flow_log.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_log.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
  
  tags = {
    Name        = "${var.environment}-vpc-flow-logs"
    Environment = var.environment
  }
}

# CloudWatch Log Group for VPC Flow Logs
resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  name              = "/aws/vpc/${var.environment}-bank-vpc"
  retention_in_days = 7
  
  tags = {
    Name        = "${var.environment}-vpc-flow-logs"
    Environment = var.environment
  }
}

# IAM Role for VPC Flow Logs
resource "aws_iam_role" "vpc_flow_log" {
  name = "${var.environment}-vpc-flow-log-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })
  
  tags = {
    Name        = "${var.environment}-vpc-flow-log-role"
    Environment = var.environment
  }
}

# IAM Policy for VPC Flow Logs
resource "aws_iam_role_policy" "vpc_flow_log" {
  name = "${var.environment}-vpc-flow-log-policy"
  role = aws_iam_role.vpc_flow_log.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}