provider "aws" {
  region = var.region
}

# ----------------------------
# Security Group
# ----------------------------
resource "aws_security_group" "devops_sg" {
  name        = "devops-sg"
  description = "Allow SSH and Jenkins"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
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

# ----------------------------
# EC2 with Docker + Jenkins Auto Install
# ----------------------------
resource "aws_instance" "devops_ec2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y

              # Install Docker
              apt install -y docker.io
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ubuntu

              # Run Jenkins Container
              docker run -d \
                --name jenkins \
                -p 8080:8080 \
                -p 50000:50000 \
                -v jenkins_home:/var/jenkins_home \
                -v /var/run/docker.sock:/var/run/docker.sock \
                jenkins/jenkins:lts-jdk17
              EOF

  tags = {
    Name = "DevOps-Capstone"
  }
}

# ----------------------------
# Output Public IP
# ----------------------------
output "ec2_public_ip" {
  value = aws_instance.devops_ec2.public_ip
}
