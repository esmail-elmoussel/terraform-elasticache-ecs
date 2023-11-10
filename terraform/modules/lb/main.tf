data "aws_vpc" "selected_vpc" {
  default = true
}

resource "aws_security_group" "todo_lb" {
  name        = "todo-lb"
  description = "todo-lb"
  vpc_id      = data.aws_vpc.selected_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "todo" {
  name                             = "todo"
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.todo_lb.id]
  subnets                          = ["subnet-0e9f505412d4431cd", "subnet-0e5a6c54c57881bb5"]
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = false
}

resource "aws_lb_target_group" "todo" {
  name        = "todo"
  target_type = "ip"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.selected_vpc.id
}

resource "aws_lb_listener" "todo" {
  load_balancer_arn = aws_lb.todo.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.todo.arn
  }

  depends_on = [aws_lb_target_group.todo]
}
