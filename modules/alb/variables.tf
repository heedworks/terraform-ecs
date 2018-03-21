# Required Variables

variable "environment" {
  description = "The name of the environment"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "subnet_ids" {
  description = "List of subnet ids to place the load balancer in"
  type        = "list"
}

variable "security_groups" {
  description = "List of security groups to attach to the load balancer"
  type        = "list"
}

# Optional Variables

variable "name" {
  description = "The name of the loadbalancer"
  default     = "default"
}

variable "internal" {
  description = "List of public subnet ids to place the loadbalancer in"
  default     = true
}
