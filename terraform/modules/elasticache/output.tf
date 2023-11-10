output "redis_url" {
  value = aws_elasticache_cluster.todo_redis.cache_nodes[0].address
}
