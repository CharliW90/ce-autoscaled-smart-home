resource "aws_lb_target_group" "primary-lb-target" {
  name = "${var.name}-lb-tg"

  protocol = var.target_protocol
  protocol_version = var.target_protocol_ver

  port = var.target_port

  vpc_id = var.vpc_id

  health_check {
    path = var.health_check_path
    protocol = var.health_check_protocol
  }

  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_lb" "load_balancer" {
  name               = "${var.name}-lb"
  load_balancer_type = "application"
  internal           = var.internal_only
  enable_deletion_protection = false

  security_groups    = var.internal_only ? var.private_security_groups : var.public_security_groups
  subnets            = var.internal_only ? var.private_subnets : var.public_subnets

  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  
  port              = var.listen_port
  protocol          = var.listen_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.primary-lb-target.arn
  }
}

resource "aws_autoscaling_attachment" "autoscale-listener" {
  autoscaling_group_name = var.autoscaling_group
  lb_target_group_arn    = aws_lb_target_group.primary-lb-target.arn
}