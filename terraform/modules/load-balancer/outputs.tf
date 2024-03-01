output "id" {
  value = aws_lb.load_balancer.id
}

output "url_to_serve" {
  value = aws_lb.load_balancer.dns_name
}