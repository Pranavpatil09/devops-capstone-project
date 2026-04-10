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
              
