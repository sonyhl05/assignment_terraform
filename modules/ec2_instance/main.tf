provider "aws" {
  region = var.region
}

# Select CIDR block based on workspace
locals {
  environment = terraform.workspace
  vpc_cidr    = lookup(var.workspace_cidrs, local.environment, var.vpc_cidr)
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = local.vpc_cidr
}

# Create Security Group
resource "aws_security_group" "allow_ssh_http" {
  vpc_id = aws_vpc.main.id
  name   = "allow_ssh_http"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 Instance
resource "aws_instance" "web" {
  ami                    = "ami-023a307f3d27ea427" 
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  subnet_id              = element(aws_subnet.public[*].id, 0)
  key_name               = "aws-keypair"
  # Using a user_data script to install Ansible on boot
  user_data = <<-EOF
              #!/bin/bash
              # Update package list and install prerequisites
              apt-get update -y
              apt-get install -y software-properties-common

              # Add Ansible PPA and install Ansible
              apt-add-repository --yes --update ppa:ansible/ansible
              apt-get install -y ansible

              # Optionally, you could log the installation status
              echo "Ansible installed successfully" > /tmp/ansible_install.log
              EOF

  tags = {
    Name        = "web-server-${local.environment}"
    Environment = local.environment
  }
}

# Create a Public Subnet
resource "aws_subnet" "public" {
  count = 1
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(local.vpc_cidr, 8, 1)
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[0]
}

# Data source for availability zones
data "aws_availability_zones" "available" {}
