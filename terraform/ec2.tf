# Data source to get the latest Ubuntu 22.04 LTS AMI (as backup)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Public Web Server / Load Balancer
resource "aws_instance" "web_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  vpc_security_group_ids      = [aws_security_group.web_server.id]
  subnet_id                   = aws_subnet.public_2.id
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
  }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y curl wget vim nginx apt-transport-https ca-certificates gnupg
    
    # Install kubectl
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    apt-get update
    apt-get install -y kubectl
    
    # Configure nginx
    systemctl enable nginx
    systemctl start nginx
    hostnamectl set-hostname web-server
    echo "127.0.0.1 web-server" >> /etc/hosts
    # Create a simple index page
    echo "<h1>Kubernetes Load Balancer</h1><p>Server: $(hostname)</p>" > /var/www/html/index.html
  EOF

  tags = {
    Name        = "${var.project_name}-web-server"
    Role        = "web-server"
    Environment = var.environment
    Project     = var.project_name
  }
}

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

# API Server (Master Node)
resource "aws_instance" "apiserver" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  vpc_security_group_ids      = [aws_security_group.kubernetes_nodes.id]
  subnet_id                   = aws_subnet.private_1.id
  associate_public_ip_address = false

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
  }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y curl wget vim apt-transport-https ca-certificates gnupg socat conntrack ipset
    
    # Install kubectl
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    apt-get update
    apt-get install -y kubectl
    
    # Install additional tools for Kubernetes master
    wget -q --show-progress --https-only --timestamping \
      "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.28.0/crictl-v1.28.0-linux-amd64.tar.gz" \
      "https://github.com/opencontainers/runc/releases/download/v1.1.9/runc.amd64" \
      "https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz" \
      "https://github.com/containerd/containerd/releases/download/v1.7.8/containerd-1.7.8-linux-amd64.tar.gz"
    
    hostnamectl set-hostname apiserver
    echo "127.0.0.1 apiserver" >> /etc/hosts
  EOF

  tags = {
    Name        = "${var.project_name}-apiserver"
    Role        = "master"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Worker Node 1
resource "aws_instance" "node1" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  vpc_security_group_ids      = [aws_security_group.kubernetes_nodes.id]
  subnet_id                   = aws_subnet.private_1.id
  associate_public_ip_address = false

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
  }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y curl wget vim apt-transport-https ca-certificates gnupg socat conntrack ipset
    
    # Install kubectl
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    apt-get update
    apt-get install -y kubectl
    
    # Install additional tools for Kubernetes worker
    wget -q --show-progress --https-only --timestamping \
      "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.28.0/crictl-v1.28.0-linux-amd64.tar.gz" \
      "https://github.com/opencontainers/runc/releases/download/v1.1.9/runc.amd64" \
      "https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz" \
      "https://github.com/containerd/containerd/releases/download/v1.7.8/containerd-1.7.8-linux-amd64.tar.gz"
    
    hostnamectl set-hostname node1
    echo "127.0.0.1 node1" >> /etc/hosts
  EOF

  tags = {
    Name        = "${var.project_name}-node1"
    Role        = "worker"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Worker Node 2
resource "aws_instance" "node2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_pair_name
  vpc_security_group_ids      = [aws_security_group.kubernetes_nodes.id]
  subnet_id                   = aws_subnet.private_2.id
  associate_public_ip_address = false

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
  }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y curl wget vim apt-transport-https ca-certificates gnupg socat conntrack ipset
    
    # Install kubectl
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    apt-get update
    apt-get install -y kubectl
    
    # Install additional tools for Kubernetes worker
    wget -q --show-progress --https-only --timestamping \
      "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.28.0/crictl-v1.28.0-linux-amd64.tar.gz" \
      "https://github.com/opencontainers/runc/releases/download/v1.1.9/runc.amd64" \
      "https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz" \
      "https://github.com/containerd/containerd/releases/download/v1.7.8/containerd-1.7.8-linux-amd64.tar.gz"
    
    hostnamectl set-hostname node2
    echo "127.0.0.1 node2" >> /etc/hosts
  EOF

  tags = {
    Name        = "${var.project_name}-node2"
    Role        = "worker"
    Environment = var.environment
    Project     = var.project_name
  }
}