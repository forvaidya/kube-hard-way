# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

# EC2 Instance Outputs
output "apiserver_public_ip" {
  description = "Public IP address of the API server"
  value       = aws_instance.apiserver.public_ip
}

output "apiserver_private_ip" {
  description = "Private IP address of the API server"
  value       = aws_instance.apiserver.private_ip
}

output "apiserver_instance_id" {
  description = "Instance ID of the API server"
  value       = aws_instance.apiserver.id
}

output "node1_public_ip" {
  description = "Public IP address of node1"
  value       = aws_instance.node1.public_ip
}

output "node1_private_ip" {
  description = "Private IP address of node1"
  value       = aws_instance.node1.private_ip
}

output "node1_instance_id" {
  description = "Instance ID of node1"
  value       = aws_instance.node1.id
}

output "node2_public_ip" {
  description = "Public IP address of node2"
  value       = aws_instance.node2.public_ip
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

# SSH Connection strings
output "ssh_connections" {
  description = "SSH connection commands for all instances"
  value = {
    apiserver = "ssh -i ~/.ssh/your-key.pem ubuntu@${aws_instance.apiserver.public_ip}"
    node1     = "ssh -i ~/.ssh/your-key.pem ubuntu@${aws_instance.node1.public_ip}"
    node2     = "ssh -i ~/.ssh/your-key.pem ubuntu@${aws_instance.node2.public_ip}"
  }
}