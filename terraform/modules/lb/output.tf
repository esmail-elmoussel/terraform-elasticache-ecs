output "target_group_arn" {
  value = aws_lb_target_group.todo_lb_tg.arn
}

output "lb_dns_name" {
  value = aws_lb.todo_lb.dns_name
}
