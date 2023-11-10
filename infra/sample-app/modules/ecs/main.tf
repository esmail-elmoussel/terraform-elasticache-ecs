data "aws_vpc" "selected_vpc" {
  default = true
}

resource "aws_security_group" "sample_app_ecs" {
  name        = "sample-app-ecs"
  description = "sample-app-ecs"
  vpc_id      = data.aws_vpc.selected_vpc.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" // allow all traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "sample_app_ecs_task_execution" {
  name = "sample-app-ecs-task-execution"

  assume_role_policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "sample_app_ecs" {
  name = "sample-app-ecs"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*"
      }
    ]
  })

}

resource "aws_iam_role_policy_attachment" "ecs_role_policy" {
  role       = aws_iam_role.sample_app_ecs_task_execution.name
  policy_arn = aws_iam_policy.sample_app_ecs.arn
}

resource "aws_ecs_cluster" "sample_app_cluster" {
  name = "sample-app-cluster"
}

resource "aws_ecs_task_definition" "sample_app" {
  family                   = "sample-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.sample_app_ecs_task_execution.arn
  cpu                      = 256
  memory                   = 512

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  container_definitions = jsonencode([
    {
      name  = "sample-app"
      image = "esmailelmoussel/sample-app:latest"
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ],
      environment : [
        {
          name  = "REDIS_URL"
          value = "redis://${var.redis_url}:6379"
        }
      ]
    },
  ])
}

resource "aws_ecs_service" "sample_app" {
  name             = "sample-app"
  cluster          = aws_ecs_cluster.sample_app_cluster.id
  task_definition  = aws_ecs_task_definition.sample_app.arn
  launch_type      = "FARGATE"
  platform_version = "LATEST"
  desired_count    = 1

  network_configuration {
    subnets          = ["subnet-0e9f505412d4431cd", "subnet-0e5a6c54c57881bb5"]
    security_groups  = [aws_security_group.sample_app_ecs.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "sample-app"
    container_port   = 3000
  }

  depends_on = [aws_ecs_task_definition.sample_app]
}
