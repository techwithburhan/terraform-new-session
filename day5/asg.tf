# ─── SECURITY GROUP ──────────────────────────────────────────────────
resource "aws_security_group" "ec2_sg" {
  name        = "day5-${local.workspace}-ec2-sg"
  description = "EC2 security group"
  vpc_id      = aws_vpc.main.id

  ingress {
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

  tags = { Name = "day5-${local.workspace}-ec2-sg" }
}

# ─── LAUNCH TEMPLATE ─────────────────────────────────────────────────
resource "aws_launch_template" "app" {
  name_prefix   = "day5-${local.workspace}-"
  image_id      = "ami-0c02fb55956c7d316"
  instance_type = local.config.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum install -y nginx
    echo "Hello from ${local.workspace}" > /usr/share/nginx/html/index.html
    systemctl start nginx
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "day5-${local.workspace}-instance" }
  }
}

# ─── AUTO SCALING GROUP ───────────────────────────────────────────────
resource "aws_autoscaling_group" "app" {
  name                = "day5-${local.workspace}-asg"
  min_size            = local.config.min_size
  max_size            = local.config.max_size
  desired_capacity    = local.config.desired
  vpc_zone_identifier = [aws_subnet.public_a.id, aws_subnet.public_b.id]

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Environment"
    value               = local.workspace
    propagate_at_launch = true
  }
}

# ─── CPU SCALE-OUT POLICY ────────────────────────────────────────────
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "day5-scale-out"
  autoscaling_group_name = aws_autoscaling_group.app.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "day5-${local.workspace}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70
  alarm_actions       = [aws_autoscaling_policy.scale_out.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app.name
  }
}
