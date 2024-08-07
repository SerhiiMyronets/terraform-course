resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_description   = "Monitors CPU utilization"
  alarm_name          = "high_cpu_alarm"
  alarm_actions       = [aws_autoscaling_policy.scale_out.arn]
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = 70
  evaluation_periods  = 2
  period              = 30
  statistic           = "Average"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_description   = "Monitors CPU utilization"
  alarm_name          = "low_cpu_alarm"
  alarm_actions       = [aws_autoscaling_policy.scale_in.arn]
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = 25
  evaluation_periods  = 2
  period              = 30
  statistic           = "Average"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}
