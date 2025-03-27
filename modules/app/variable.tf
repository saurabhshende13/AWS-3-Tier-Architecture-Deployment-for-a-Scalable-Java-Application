variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for application servers"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for application servers"
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

variable "target_group_arn" {
  description = "ARN of the application target group"
  type        = string
}

variable "db_endpoint" {
  description = "RDS database endpoint"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
} 

variable "ami_id" {
  default = "ami-02a3982f2d7d2b2e6"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}