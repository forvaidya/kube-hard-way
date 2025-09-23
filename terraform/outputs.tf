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

output "web_server_private_ip" {
  description = "Private IP address of the web server (fixed)"
  value       = aws_instance.web_server.private_ip
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
  description = "Private IP address of the API server (fixed)"
  value       = aws_instance.apiserver.private_ip
}

output "apiserver_instance_id" {
  description = "Instance ID of the API server"
  value       = aws_instance.apiserver.id
}

output "node1_private_ip" {
  description = "Private IP address of node1 (fixed)"
  value       = aws_instance.node1.private_ip
}

output "node1_instance_id" {
  description = "Instance ID of node1"
  value       = aws_instance.node1.id
}

output "node2_private_ip" {
  description = "Private IP address of node2 (fixed)"
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
    # Direct SSH access to web server via Elastic IP
    web_server_ssh = "ssh -i ~/.ssh/your-key.pem ubuntu@${aws_eip.web_server.public_ip}"
    
    # Private subnet instances accessible via SSM Session Manager or through bastion
    note = "API server and worker nodes are in private subnets with fixed private IPs but no public IPs"
    apiserver_private_ip  = aws_instance.apiserver.private_ip
    node1_private_ip      = aws_instance.node1.private_ip
    node2_private_ip      = aws_instance.node2.private_ip
    web_server_private_ip = aws_instance.web_server.private_ip
    
    access_note = "Use SSM Session Manager (aws ssm start-session --target <instance-id>) or SSH through web server as bastion to access private instances"
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

# IAM Role and Instance Profile Outputs
output "ec2_ssm_role_arn" {
  description = "ARN of the EC2 SSM IAM role"
  value       = aws_iam_role.ec2_ssm_role.arn
}

output "ec2_ssm_role_name" {
  description = "Name of the EC2 SSM IAM role"
  value       = aws_iam_role.ec2_ssm_role.name
}

output "ec2_ssm_instance_profile_arn" {
  description = "ARN of the EC2 SSM instance profile"
  value       = aws_iam_instance_profile.ec2_ssm_instance_profile.arn
}

output "ec2_ssm_instance_profile_name" {
  description = "Name of the EC2 SSM instance profile"
  value       = aws_iam_instance_profile.ec2_ssm_instance_profile.name
}

# SSM Session Manager Access Information
output "ssm_access_info" {
  description = "Information about accessing instances via SSM Session Manager"
  value = {
    note = "All EC2 instances have SSM agent installed and proper IAM permissions for Session Manager access"
    web_server_instance_id = aws_instance.web_server.id
    apiserver_instance_id  = aws_instance.apiserver.id
    node1_instance_id      = aws_instance.node1.id
    node2_instance_id      = aws_instance.node2.id
    access_command         = "aws ssm start-session --target <instance-id>"
  }
}

# Fixed IP Address Summary
output "fixed_ip_summary" {
  description = "Summary of all fixed IP addresses assigned to instances"
  value = {
    web_server = {
      private_ip = "10.0.2.10"
      public_ip  = aws_eip.web_server.public_ip
      instance_id = aws_instance.web_server.id
      subnet = "public"
    }
    apiserver = {
      private_ip = "10.0.3.10"
      public_ip  = "none (private subnet)"
      instance_id = aws_instance.apiserver.id
      subnet = "private"
    }
    node1 = {
      private_ip = "10.0.3.20"
      public_ip  = "none (private subnet)"
      instance_id = aws_instance.node1.id
      subnet = "private"
    }
    node2 = {
      private_ip = "10.0.4.20"
      public_ip  = "none (private subnet)"
      instance_id = aws_instance.node2.id
      subnet = "private"
    }
    note = "Web server has reserved public and private IPs. Private subnet instances have only fixed private IPs."
  }
}