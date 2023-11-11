output "sample_app_postgres_security_group_id" {
  description = "The created security group ID for the sample app postgres instance!"
  value       = aws_security_group.sample_app_postgres.id
}
