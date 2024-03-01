output "template_details" {
  value = [
    for template in aws_launch_template.app_template : {template_app = template.name, template_id = template.id, public = template.tag_specifications[0].tags.Public}
  ]
}