data "aws_vpc" "selected_vpc" {
  default = true
}

resource "aws_security_group" "sample_app_redis" {
  name        = "sample-app-redis"
  description = "sample-app-redis"
  vpc_id      = data.aws_vpc.selected_vpc.id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_subnet_group" "sample_app_redis" {
  name       = "sample-app-redis"
  subnet_ids = ["subnet-0e9f505412d4431cd"]
}

resource "aws_elasticache_cluster" "sample_app_redis" {
  apply_immediately          = true
  cluster_id                 = "sample-app-redis"
  engine                     = "redis"
  node_type                  = "cache.t2.micro"
  num_cache_nodes            = 1
  parameter_group_name       = "default.redis7"
  engine_version             = "7.0"
  port                       = 6379
  az_mode                    = "single-az"
  auto_minor_version_upgrade = false
  security_group_ids         = [aws_security_group.sample_app_redis.id]
  subnet_group_name          = aws_elasticache_subnet_group.sample_app_redis.name
}
