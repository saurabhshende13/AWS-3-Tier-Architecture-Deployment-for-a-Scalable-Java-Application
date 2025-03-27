output "db_instance_id" {
  description = "ID of the RDS instance"
  value       = aws_db_instance.main.id
}

output "db_instance_arn" {
  description = "ARN of the RDS instance"
  value       = aws_db_instance.main.arn
}

output "db_endpoint" {
  description = "Connection endpoint for the RDS instance"
  value       = aws_db_instance.main.endpoint
}

output "db_name" {
  description = "Name of the database"
  value       = aws_db_instance.main.db_name
}

output "db_port" {
  description = "Port of the database"
  value       = aws_db_instance.main.port
}

# output "read_replica_endpoints" {
#   description = "List of endpoints for the read replicas"
#   value       = aws_db_instance.read_replica[*].endpoint
# }

output "db_subnet_group_name" {
  description = "Name of the database subnet group"
  value       = aws_db_subnet_group.main.name
}

output "db_monitoring_role_arn" {
  value = aws_iam_role.rds_monitoring.arn
}

output "db_instance_status" {
  description = "Current status of the RDS instance"
  value       = aws_db_instance.main.status
}