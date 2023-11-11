output "database_url" {
  description = "The URL for the created RDS database"
  value       = aws_db_instance.sample_app_postgres.endpoint
}
