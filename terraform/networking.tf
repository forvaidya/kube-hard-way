# Fixed IP addresses for EC2 instances
# Web server gets both fixed private IP and Elastic IP (public)
# Private subnet instances (API server, nodes) get only fixed private IPs

# Elastic IP for Web Server (only public instance)
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