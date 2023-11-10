data "aws_vpc" "selected_vpc" {
  default = true
}

resource "aws_security_group" "sample_app_lb" {
  name        = "sample-app-lb"
  description = "sample-app-lb"
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

resource "aws_lb" "sample_app" {
  name                             = "sample-app"
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.sample_app_lb.id]
  subnets                          = ["subnet-0e9f505412d4431cd", "subnet-0e5a6c54c57881bb5"]
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = false
}

resource "aws_lb_target_group" "sample_app" {
  name        = "sample-app"
  target_type = "ip"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.selected_vpc.id
}

resource "aws_lb_listener" "sample_app" {
  load_balancer_arn = aws_lb.sample_app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sample_app.arn
  }

  depends_on = [aws_lb_target_group.sample_app]
}
