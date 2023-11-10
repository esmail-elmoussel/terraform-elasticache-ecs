data "aws_vpc" "selected_vpc" {
  default = true
}

resource "aws_security_group" "todo_redis_sg" {
  name        = "todo-redis-sg"
  description = "todo-redis-sg"
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

resource "aws_elasticache_subnet_group" "todo_redis_subnet_group" {
  name       = "todo-redis-subnet-group"
  subnet_ids = ["subnet-0e9f505412d4431cd"]
}

resource "aws_elasticache_cluster" "todo_redis" {
  apply_immediately          = true
  cluster_id                 = "todo-redis"
  engine                     = "redis"
  node_type                  = "cache.t2.micro"
  num_cache_nodes            = 1
  parameter_group_name       = "default.redis7"
  engine_version             = "7.0"
  port                       = 6379
  az_mode                    = "single-az"
  auto_minor_version_upgrade = false
  security_group_ids         = [aws_security_group.todo_redis_sg.id]
  subnet_group_name          = aws_elasticache_subnet_group.todo_redis_subnet_group.name
}
