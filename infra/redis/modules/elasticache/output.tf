output "elasticache_cluster_redis_url" {
  description = "URL for the created redis instance!"
  value       = aws_elasticache_cluster.sample_app_redis.cache_nodes[0].address
}
