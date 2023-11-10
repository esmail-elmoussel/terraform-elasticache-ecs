output "lb_dns_name" {
  value = module.lb.lb_dns_name
}

output "redis_url" {
  value = module.elasticache.redis_url
}
