output "dns_name" {
  description = "The DNS name for the created load balancer"
  value       = module.lb.lb_dns_name
}

output "redis_url" {
  description = "The URL for the created Redis cluster"
  value       = module.elasticache.elasticache_cluster_redis_url
}
