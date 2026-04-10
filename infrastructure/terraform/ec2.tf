data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "jenkins_server" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public_1.id
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

  # Increase root disk size
  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  user_data = filebase64("${path.module}/../../scripts/install_jenkins_docker.sh")

  tags = {
    Name = "${var.project}-${var.env}-jenkins-server"
  }
}
