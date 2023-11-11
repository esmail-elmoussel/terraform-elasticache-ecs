resource "aws_db_instance" "sample_app_postgres" {
  engine                      = "postgres"
  engine_version              = "15.3"
  multi_az                    = false
  db_name                     = "sample"
  identifier                  = "sample"
  username                    = "postgres"
  manage_master_user_password = true
  instance_class              = "db.t3.micro"
  storage_type                = "gp2"
  allocated_storage           = 10
  skip_final_snapshot         = true
  auto_minor_version_upgrade  = false
  allow_major_version_upgrade = false
  publicly_accessible         = true
  vpc_security_group_ids      = [var.security_group_id]
  availability_zone           = "us-east-1a"
  parameter_group_name        = "default.postgres15"
}
