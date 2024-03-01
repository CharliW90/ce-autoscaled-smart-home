output "autoscalers" {
  value = [
    for group in aws_autoscaling_group.asg : {name = group.name, autoscaling_group = group.id, internal_only = group.tag}
  ]
}