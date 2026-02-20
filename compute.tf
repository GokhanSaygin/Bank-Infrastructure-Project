# Data source - Latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# IAM Role for EC2 instances
resource "aws_iam_role" "ec2_role" {
  name = "${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.environment}-ec2-role"
    Environment = var.environment
  }
}

# IAM Policy for CloudWatch Logs
resource "aws_iam_role_policy" "ec2_cloudwatch_policy" {
  name = "${var.environment}-ec2-cloudwatch-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_role.name

  tags = {
    Name        = "${var.environment}-ec2-profile"
    Environment = var.environment
  }
}

# EC2 Instance - App Tier
resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.micro" # FREE TIER!
  subnet_id              = aws_subnet.private_app_1.id
  vpc_security_group_ids = [aws_security_group.app_tier.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  key_name               = "bank-dev-key" # SSH key pair name

  # User data - Install Apache web server
  user_data = <<-EOF
              #!/bin/bash
              # Update system
              dnf update -y
              
              # Install Apache
              dnf install -y httpd
              
              # Create a simple web page
              cat > /var/www/html/index.html <<'HTML'
              <!DOCTYPE html>
              <html>
              <head>
                  <title>Banking App - ${var.environment}</title>
                  <style>
                      body {
                          font-family: Arial, sans-serif;
                          margin: 40px;
                          background-color: #f0f0f0;
                      }
                      .container {
                          background-color: white;
                          padding: 20px;
                          border-radius: 8px;
                          box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                      }
                      h1 { color: #2c3e50; }
                      .status { color: green; font-weight: bold; }
                      .info { background-color: #e8f4f8; padding: 10px; border-radius: 4px; margin: 10px 0; }
                  </style>
              </head>
              <body>
                  <div class="container">
                      <h1>🏦 Banking Application</h1>
                      <p class="status">✅ Application Server is Running!</p>
                      <div class="info">
                          <p><strong>Environment:</strong> ${var.environment}</p>
                          <p><strong>Instance ID:</strong> $(ec2-metadata --instance-id | cut -d " " -f 2)</p>
                          <p><strong>Availability Zone:</strong> $(ec2-metadata --availability-zone | cut -d " " -f 2)</p>
                          <p><strong>Private IP:</strong> $(ec2-metadata --local-ipv4 | cut -d " " -f 2)</p>
                      </div>
                      <p>This is the application tier running in a private subnet.</p>
                  </div>
              </body>
              </html>
HTML
              
              # Start Apache and enable on boot
              systemctl start httpd
              systemctl enable httpd
              
              # Create log file
              echo "Apache installed successfully on $(date)" > /var/log/app-init.log
              EOF

  # Root volume
  root_block_device {
    volume_size           = 8 # 8 GB (Free Tier: 30GB total)
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  # Metadata options (security best practice)
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # IMDSv2 (more secure)
    http_put_response_hop_limit = 1
  }

  tags = {
    Name        = "${var.environment}-app-server"
    Environment = var.environment
    Tier        = "Application"
    ManagedBy   = "Terraform"
  }
}

