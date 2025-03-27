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
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
} 