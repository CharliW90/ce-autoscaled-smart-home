resource "aws_autoscaling_group" "asg" {
  name             = var.app_name
  min_size         = var.min
  max_size         = var.max
  desired_capacity = var.desired

  health_check_grace_period = 300
  health_check_type         = "ELB"

  launch_template {
    id      = var.template_id
    version = "$Latest"
  }

  vpc_zone_identifier = var.subnet_ids
}
