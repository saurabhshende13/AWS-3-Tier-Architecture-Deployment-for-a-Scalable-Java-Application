data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_launch_template" "nginx" {
  name_prefix   = "${var.environment}-nginx-"
  image_id      = var.ami_id
  instance_type = var.nginx_instance_type
  key_name = var.key_name
  vpc_security_group_ids = [var.security_group_id]

  monitoring {
    enabled = true
  }
  
  tag_specifications {
    resource_type = "instance"
    
    tags = {
      Name = "${var.environment}-nginx"
    }
  }
}

resource "aws_autoscaling_group" "nginx" {
  name                = "${var.environment}-nginx-asg"
  vpc_zone_identifier = var.subnet_ids
  desired_capacity    = 2
  min_size            = 2
  max_size            = 2
  
  launch_template {
    id      = aws_launch_template.nginx.id
    version = "$Latest"
  }
  
  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns         = [var.app_target_group_arn]
  
  tag {
    key                 = "Name"
    value               = "${var.environment}-nginx"
    propagate_at_launch = true
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "nginx_scale_up" {
  name                   = "${var.environment}-nginx-scale-up"
  autoscaling_group_name = aws_autoscaling_group.nginx.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
}

resource "aws_cloudwatch_metric_alarm" "nginx_cpu_high" {
  alarm_name          = "${var.environment}-nginx-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 40
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.nginx.name
  }
  
  alarm_description = "Scale up if CPU > 80% for 4 minutes"
  alarm_actions     = [aws_autoscaling_policy.nginx_scale_up.arn]
}

resource "aws_autoscaling_policy" "nginx_scale_down" {
  name                   = "${var.environment}-nginx-scale-down"
  autoscaling_group_name = aws_autoscaling_group.nginx.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300
}

resource "aws_cloudwatch_metric_alarm" "nginx_cpu_low" {
  alarm_name          = "${var.environment}-nginx-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 20
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.nginx.name
  }
  
  alarm_description = "Scale down if CPU < 20% for 4 minutes"
  alarm_actions     = [aws_autoscaling_policy.nginx_scale_down.arn]
}