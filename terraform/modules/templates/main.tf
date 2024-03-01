resource "aws_launch_template" "app_template" {

  name = "${var.app_name}-instance"

  instance_type = var.instance_type

  image_id = var.ami_to_use

  key_name = var.key

  network_interfaces {
    security_groups = var.security_groups
    associate_public_ip_address = var.public
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name      = var.app_name
      ManagedBy = "Terraform"
    }
  }
}
