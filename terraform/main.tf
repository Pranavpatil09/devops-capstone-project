provider "aws" {
  region = var.region
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get default subnet
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow SSH, Jenkins and HTTP"
  vpc_id      = data.aws_vpc.default.id

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

  ingress {
    description = "HTTP"
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

# EC2 Instance
resource "aws_instance" "jenkins_server" {
  ami                         = var.ami
  instance_type               = "t3.micro"
  key_name                    = var.key_name
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true

  # Increase root disk size
  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y

              # ----------------------------
              # INCREASE /tmp SIZE TO 2GB
              # ----------------------------
              echo "tmpfs /tmp tmpfs defaults,size=2G 0 0" >> /etc/fstab
              mount -o remount /tmp

              # ----------------------------
              # CREATE 2GB SWAP
              # ----------------------------
              fallocate -l 2G /swapfile
              chmod 600 /swapfile
              mkswap /swapfile
              swapon /swapfile
              echo '/swapfile swap swap defaults 0 0' >> /etc/fstab

              # Install Git
              yum install git -y

              # ----------------------------
              # INSTALL DOCKER
              # ----------------------------
              yum install docker -y
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ec2-user

              # ----------------------------
              # INSTALL JENKINS
              # ----------------------------
              wget -O /etc/yum.repos.d/jenkins.repo \
                https://pkg.jenkins.io/redhat-stable/jenkins.repo
              rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
              yum install java-17-amazon-corretto -y
              yum install jenkins -y

              systemctl enable jenkins
              systemctl start jenkins

              # Allow Jenkins to use Docker
              usermod -aG docker jenkins
              systemctl restart jenkins
              EOF

  tags = {
    Name = "Jenkins-Docker-Server"
  }
}

output "public_ip" {
  value = aws_instance.jenkins_server.public_ip
}
