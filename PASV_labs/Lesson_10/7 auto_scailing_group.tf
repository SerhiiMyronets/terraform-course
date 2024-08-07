resource "aws_autoscaling_group" "web_asg" {
  launch_template {
    id      = aws_launch_template.web_lt.id
    version = aws_launch_template.web_lt.latest_version
  }
  vpc_zone_identifier = local.filtered_subnets
  target_group_arns   = [aws_lb_target_group.web_tg.arn]

  min_size         = 2
  max_size         = 5
  default_cooldown = 60

  health_check_type         = "ELB"
  health_check_grace_period = 60

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale_out"
  autoscaling_group_name = aws_autoscaling_group.web_asg.id
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 120

}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale_in"
  autoscaling_group_name = aws_autoscaling_group.web_asg.id
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
}




