variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

# Public Subnet Variables
variable "public_subnet_cidr" {
  description = "CIDR block for public subnet in us-east-1a"
  type        = string
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for public subnet in us-east-1b"
  type        = string
}

# Private Application Subnet Variables
variable "private_app_subnet_1_cidr" {
  description = "CIDR block for private application subnet in us-east-1a"
  type        = string
}

variable "private_app_subnet_2_cidr" {
  description = "CIDR block for private application subnet in us-east-1b"
  type        = string
}

# Private Database Subnet Variables
variable "private_db_subnet_1_cidr" {
  description = "CIDR block for private database subnet in us-east-1a"
  type        = string
}

variable "private_db_subnet_2_cidr" {
  description = "CIDR block for private database subnet in us-east-1b"
  type        = string
}