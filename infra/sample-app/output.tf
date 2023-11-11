output "dns_name" {
  description = "The DNS name for the created load balancer"
  value       = module.lb.lb_dns_name
}
