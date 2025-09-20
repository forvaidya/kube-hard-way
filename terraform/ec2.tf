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

# API Server (Master Node)
resource "aws_instance" "apiserver" {
  ami                     = var.ami_id
  instance_type           = var.instance_type
  key_name                = var.key_pair_name
  vpc_security_group_ids  = [aws_security_group.kubernetes_nodes.id]
  subnet_id               = aws_subnet.public.id
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
  }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y curl wget vim
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
  ami                     = var.ami_id
  instance_type           = var.instance_type
  key_name                = var.key_pair_name
  vpc_security_group_ids  = [aws_security_group.kubernetes_nodes.id]
  subnet_id               = aws_subnet.public.id
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
  }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y curl wget vim
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
  ami                     = var.ami_id
  instance_type           = var.instance_type
  key_name                = var.key_pair_name
  vpc_security_group_ids  = [aws_security_group.kubernetes_nodes.id]
  subnet_id               = aws_subnet.public.id
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
  }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y curl wget vim
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