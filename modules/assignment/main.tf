provider "aws" {
  region = "ap-south-1" // Replace with your desired AWS region
}

resource "aws_instance" "example" {
  ami           = "ami-023a307f3d27ea427" // Replace with the AMI ID you want to use
  instance_type = "t2.micro"
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
    Name = "my_ec2_instance"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ip_address.txt"
  }
}

output "instance_ip_addr" {
  value = aws_instance.example.public_ip
}
