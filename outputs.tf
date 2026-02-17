output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value = [
    aws_subnet.public.id,
    aws_subnet.public_2.id
  ]
}

output "private_app_subnet_ids" {
  description = "IDs of private application subnets"
  value = [
    aws_subnet.private_app_1.id,
    aws_subnet.private_app_2.id
  ]
}

output "private_db_subnet_ids" {
  description = "IDs of private database subnets"
  value = [
    aws_subnet.private_db_1.id,
    aws_subnet.private_db_2.id
  ]
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.gw.id
}

output "environment" {
  description = "Environment name"
  value       = var.environment
}
