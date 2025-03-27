variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for Nginx servers"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for Nginx servers"
  type        = string
}

variable "nginx_instance_type" {
  description = "Instance type for Nginx servers"
  type        = string
}

variable "app_target_group_arn" {
  description = "ARN of the application target group"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
} 

variable "ami_id" {
  default = "ami-03186794a6cfcc201"
}

variable "key_name" {
  type        = string
}