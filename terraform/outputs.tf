# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_1_id" {
  description = "ID of the first public subnet"
  value       = aws_subnet.public_1.id
}

output "public_subnet_2_id" {
  description = "ID of the second public subnet"
  value       = aws_subnet.public_2.id
}

output "private_subnet_1_id" {
  description = "ID of the first private subnet"
  value       = aws_subnet.private_1.id
}

output "private_subnet_2_id" {
  description = "ID of the second private subnet"
  value       = aws_subnet.private_2.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.main.id
}

output "elastic_ip" {
  description = "Elastic IP address for NAT Gateway"
  value       = aws_eip.nat.public_ip
}

# Web Server Outputs
output "web_server_public_ip" {
  description = "Public IP address of the web server"
  value       = aws_instance.web_server.public_ip
}

output "web_server_static_ip" {
  description = "Static IP (Elastic IP) address of the web server"
  value       = aws_eip.web_server.public_ip
}

output "web_server_instance_id" {
  description = "Instance ID of the web server"
  value       = aws_instance.web_server.id
}

output "web_server_dns" {
  description = "Public DNS name of the web server"
  value       = aws_instance.web_server.public_dns
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

# EC2 Instance Outputs
output "apiserver_private_ip" {
  description = "Private IP address of the API server"
  value       = aws_instance.apiserver.private_ip
}

output "apiserver_instance_id" {
  description = "Instance ID of the API server"
  value       = aws_instance.apiserver.id
}

output "node1_private_ip" {
  description = "Private IP address of node1"
  value       = aws_instance.node1.private_ip
}

output "node1_instance_id" {
  description = "Instance ID of node1"
  value       = aws_instance.node1.id
}

output "node2_private_ip" {
  description = "Private IP address of node2"
  value       = aws_instance.node2.private_ip
}

output "node2_instance_id" {
  description = "Instance ID of node2"
  value       = aws_instance.node2.id
}

# Security Group Output
output "security_group_id" {
  description = "ID of the Kubernetes security group"
  value       = aws_security_group.kubernetes_nodes.id
}

# SSH Connection Information
output "ssh_connection_info" {
  description = "SSH connection information for all instances"
  value = {
    # Direct SSH access to public web server
    web_server_ssh = "ssh -i ~/.ssh/your-key.pem ubuntu@${aws_eip.web_server.public_ip}"

    # Private K8s nodes - accessible via NAT Gateway for outbound, but no direct inbound SSH
    note                 = "K8s nodes are in private subnets without public IPs. They can reach internet via NAT Gateway but cannot be accessed directly from internet."
    apiserver_private_ip = aws_instance.apiserver.private_ip
    node1_private_ip     = aws_instance.node1.private_ip
    node2_private_ip     = aws_instance.node2.private_ip
    access_note          = "To access K8s nodes, you'll need a VPN connection or another method to reach private subnets"
  }
}

# Web Server Access Information
output "web_server_access" {
  description = "Web server access information"
  value = {
    http_url  = "http://${aws_eip.web_server.public_ip}"
    https_url = "https://${aws_eip.web_server.public_ip}"
    static_ip = aws_eip.web_server.public_ip
    note      = "Web server is accessible from the internet on ports 80 (HTTP) and 443 (HTTPS)"
  }
}