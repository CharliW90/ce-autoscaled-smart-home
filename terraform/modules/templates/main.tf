resource "aws_launch_template" "app_template" {
  count = length(var.apps)

  name = "${var.apps[count.index].app_name}-instance"

  instance_type = var.instance_type

  image_id = var.apps[count.index].image

  key_name = var.key

  network_interfaces {
    security_groups = var.apps.public ? var.public_security_groups : var.private_security_groups
    associate_public_ip_address = var.apps[count.index].public
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name      = var.apps[count.index].app_name
      ManagedBy = "Terraform"
      Public   = var.apps[count.index].public
    }
  }
}
