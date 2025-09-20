# Variables for Kubernetes hard way infrastructure

variable "key_pair_name" {
  description = "Name of the AWS key pair to use for EC2 instances"
  type        = string
  # No default - must be provided in tfvars
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
  default     = "ap-south-1a"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "ami_id" {
  description = "AMI ID for Ubuntu Server 22.04 LTS"
  type        = string
  default     = "ami-0f5ee92e2d63afc18"
}

variable "project_name" {
  description = "Name of the project for resource tagging"
  type        = string
  default     = "kube-hard-way"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}