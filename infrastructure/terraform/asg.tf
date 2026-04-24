resource "aws_launch_template" "app_lt" {
  name_prefix   = "${var.project}-${var.env}-app-lt-"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      volume_type = "gp2"
    }
  }

  user_data = filebase64("${path.module}/../../scripts/install_app.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project}-${var.env}-app-server"
    }
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                = "${var.project}-${var.env}-app-asg"
  vpc_zone_identifier = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  min_size            = var.asg_min
  max_size            = var.asg_max
  desired_capacity    = var.asg_desired

  target_group_arns = [aws_lb_target_group.app_tg.arn]

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.project}-${var.env}-app-asg"
    propagate_at_launch = true
  }
}
