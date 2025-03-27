variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "key_name" {
  description = "Key Pair for Bastion"
  type        = string
}

variable "bastion_ami" {
  description = "AMI ID for bastion host"
  type        = string
}

variable "bastion_instance_type" {
  description = "Instance type for bastion host"
  type        = string
}

variable "nginx_instance_type" {
  description = "Instance type for Nginx servers"
  type        = string
}

variable "app_instance_type" {
  description = "Instance type for application servers"
  type        = string
}

variable "app_min_size" {
  description = "Minimum size of application ASG"
  type        = number
}

variable "app_max_size" {
  description = "Maximum size of application ASG"
  type        = number
}

variable "app_desired_capacity" {
  description = "Desired capacity of application ASG"
  type        = number
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS instance in GB"
  type        = number
}

variable "db_engine" {
  description = "Database engine"
  type        = string
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_username" {
  description = "Username for the database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "app_private_subnets" {
  description = "CIDR blocks for application private subnets"
  type        = list(string)
}

variable "db_private_subnets" {
  description = "CIDR blocks for database private subnets"
  type        = list(string)
}

variable "environment" {
  description = "Environment name (e.g. dev, staging, prod)"
  type        = string
}

variable "ssl_certificate_arn" {
  description = "ARN of SSL certificate for ALB"
  type        = string
}

variable "ssh_allowed_ips" {
  description = "List of IPs allowed to SSH to bastion"
  type        = list(string)
}
