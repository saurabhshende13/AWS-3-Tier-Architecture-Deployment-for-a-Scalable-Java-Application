output "alb_sg_id" {
  description = "ID of the Application Load Balancer security group"
  value       = aws_security_group.alb_sg.id
}

output "nginx_sg_id" {
  description = "ID of the Nginx servers security group"
  value       = aws_security_group.nginx_sg.id
}

output "bastion_sg_id" {
  description = "ID of the Bastion host security group"
  value       = aws_security_group.bastion_sg.id
}

output "app_sg_id" {
  description = "ID of the Application servers security group"
  value       = aws_security_group.app_sg.id
}

output "db_sg_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.db_sg.id
}