resource "aws_autoscaling_group" "asg" {
    vpc_zone_identifier = [aws_subnet.private-subnet-1.id,aws_subnet.private-subnet-2.id, aws_subnet.private-subnet-3.id]
    name = "asg"
    max_size = 4
    min_size = 2
    health_check_type = "ELB"
    termination_policies = ["OldestInstance"]

    launch_template {
    id      = aws_launch_template.asg-lt.id
    version = "$Latest"
  }
   
   target_group_arns = [aws_lb_target_group.as-tg.arn]
  
}

# Create autoscaling policy scale-out
resource "aws_autoscaling_policy" "asg_scale_up" {
  name                   = "asg_scale_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

# Create cloudwatch scaleup alarm
resource "aws_cloudwatch_metric_alarm" "asg_cpu_alarm_up" {
  alarm_name                = "asg_cpu_alarm_up"
  threshold                 = 60
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
  
  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.asg_scale_up.arn]
}

# Create autoscaling policy scale-in
resource "aws_autoscaling_policy" "asg_scale_down" {
  name                   = "asg_scale_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

# Create cloudwatch scaledown alarm
resource "aws_cloudwatch_metric_alarm" "asg_cpu_alarm_down" {
  alarm_name                = "asg_cpu_alarm_down"
  threshold                 = 10
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
  
  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.asg_scale_down.arn]
}
