data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}


resource "aws_iam_role" "app_role" {
  name = "${var.environment}-app-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "app_profile" {
  name = "${var.environment}-app-profile"
  role = aws_iam_role.app_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_policy" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_ssm_parameter" "db_connection" {
  name        = "/${var.environment}/database/connection"
  description = "Database connection string"
  type        = "SecureString"
  value       = "jdbc:mysql://${var.db_endpoint}/${var.db_name}?user=${var.db_username}&password=${var.db_password}"
}

resource "aws_launch_template" "app" {
  name_prefix   = "${var.environment}-app-"
  image_id      = var.ami_id
  instance_type = var.app_instance_type
  key_name = var.key_name
  
  vpc_security_group_ids = [var.security_group_id]
}

resource "aws_autoscaling_group" "app2" {
  name                = "${var.environment}-app-asg"
  vpc_zone_identifier = var.subnet_ids
  desired_capacity    = 2
  min_size            = 2
  max_size            = 2
  
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
  
  health_check_grace_period = 300
  health_check_type         = "ELB"
  # target_group_arns         = [var.app_target_group_arn]
  
  tag {
    key                 = "Name"
    value               = "${var.environment}-app"
    propagate_at_launch = true
  }
  
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_policy" "app_scale_up" {
  name                   = "${var.environment}-app-scale-up"
  autoscaling_group_name = aws_autoscaling_group.app2.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
}

resource "aws_autoscaling_policy" "app_scale_down" {
  name                   = "${var.environment}-app-scale-down"
  autoscaling_group_name = aws_autoscaling_group.app2.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300
}

# Update the CloudWatch alarms to reference the correct policies
resource "aws_cloudwatch_metric_alarm" "app_cpu_high" {
  alarm_name          = "${var.environment}-app-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app2.name
  }
  
  alarm_description = "Scale up if CPU > 80% for 4 minutes"
  alarm_actions     = [aws_autoscaling_policy.app_scale_up.arn]  # Fixed reference
}

resource "aws_cloudwatch_metric_alarm" "app_cpu_low" {
  alarm_name          = "${var.environment}-app-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 20
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app2.name
  }
  
  alarm_description = "Scale down if CPU < 20% for 4 minutes"
  alarm_actions     = [aws_autoscaling_policy.app_scale_down.arn]  # Fixed reference
}