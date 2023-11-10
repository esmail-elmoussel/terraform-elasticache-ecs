output "lb_target_group_arn" {
  value = aws_lb_target_group.todo.arn
}

output "lb_dns_name" {
  value = aws_lb.todo.dns_name
}
