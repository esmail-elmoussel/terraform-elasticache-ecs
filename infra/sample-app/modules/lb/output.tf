output "lb_target_group_arn" {
  description = "The created target group ARN for the sample app!"
  value       = aws_lb_target_group.sample_app.arn
}

output "lb_dns_name" {
  description = "The created load balancer DNS name for the sample app!"
  value       = aws_lb.sample_app.dns_name
}
