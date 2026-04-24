#!/bin/bash
yum update -y

# ----------------------------
# INSTALL DOCKER
# ----------------------------
yum install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# ----------------------------
# DEPLOY APPLICATION
# ----------------------------
# The ASG launches this automatically, downloading the latest code pushed by Jenkins
docker pull pranavpatildevops/devops-capstone:latest
# Remove any existing container with the same name before starting the updated image
docker rm -f capstone || true
docker run -d --name capstone -p 80:5000 --restart unless-stopped pranavpatildevops/devops-capstone:latest
