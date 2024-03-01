resource "aws_autoscaling_group" "asg" {
  count = length(var.templates)
  name             = var.templates[count.index].template_app
  min_size         = var.min
  max_size         = var.max
  desired_capacity = var.desired

  health_check_grace_period = 300
  health_check_type         = "ELB"

  launch_template {
    id      = var.templates[count.index].template_id
    version = "$Latest"
  }

  tag {
    key = "Public"
    value = var.templates[count.index].public
    propagate_at_launch = true
  }

  vpc_zone_identifier = var.templates[count.index].public ? var.public_subnets : var.private_subnets
}
