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

variable "public_subnet_1_cidr" {
  description = "CIDR block for the first public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for the second public subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for the first private subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for the second private subnet"
  type        = string
  default     = "10.0.4.0/24"
}

variable "availability_zone_1" {
  description = "First availability zone"
  type        = string
  default     = "ap-south-1a"
}

variable "availability_zone_2" {
  description = "Second availability zone"
  type        = string
  default     = "ap-south-1b"
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