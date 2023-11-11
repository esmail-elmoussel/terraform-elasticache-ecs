data "aws_vpc" "selected_vpc" {
  default = true
}

resource "aws_security_group" "sample_app_postgres" {
  name        = "sample-app-postgres"
  description = "sample-app-postgres"
  vpc_id      = data.aws_vpc.selected_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
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
