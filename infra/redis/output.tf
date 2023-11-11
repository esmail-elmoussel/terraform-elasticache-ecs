output "redis_url" {
  description = "The URL for the created Redis cluster"
  value       = module.elasticache.elasticache_cluster_redis_url
}
