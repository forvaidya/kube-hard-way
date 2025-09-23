# Fixed IP addresses for all EC2 instances
# This file manages Elastic IPs for fixed external addressing

# Elastic IP for Web Server
resource "aws_eip" "web_server" {
  instance = aws_instance.web_server.id
  domain   = "vpc"

  tags = {
    Name        = "${var.project_name}-web-server-eip"
    Environment = var.environment
    Project     = var.project_name
  }

  depends_on = [aws_internet_gateway.main]
}

# Elastic IP for API Server
resource "aws_eip" "apiserver" {
  instance = aws_instance.apiserver.id
  domain   = "vpc"

  tags = {
    Name        = "${var.project_name}-apiserver-eip"
    Environment = var.environment
    Project     = var.project_name
  }

  depends_on = [aws_internet_gateway.main]
}

# Elastic IP for Node1
resource "aws_eip" "node1" {
  instance = aws_instance.node1.id
  domain   = "vpc"

  tags = {
    Name        = "${var.project_name}-node1-eip"
    Environment = var.environment
    Project     = var.project_name
  }

  depends_on = [aws_internet_gateway.main]
}

# Elastic IP for Node2
resource "aws_eip" "node2" {
  instance = aws_instance.node2.id
  domain   = "vpc"

  tags = {
    Name        = "${var.project_name}-node2-eip"
    Environment = var.environment
    Project     = var.project_name
  }

  depends_on = [aws_internet_gateway.main]
}