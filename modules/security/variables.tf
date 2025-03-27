variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "ssh_allowed_ips" {
  description = "List of IPs allowed to SSH to bastion"
  type        = list(string)
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
} 