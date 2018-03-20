# Required Variables

variable "environment" {
  description = "The name of the environment"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "subnet_ids" {
  description = "List of public subnet ids to place the loadbalancer in"
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
