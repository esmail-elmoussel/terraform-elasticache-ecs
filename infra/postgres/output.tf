output "database_url" {
  description = "The URL for the created RDS database"
  value       = module.rds.database_url
}
