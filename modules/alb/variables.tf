variable "alb_name" {
  default     = "default"
  description = "The name of the loadbalancer"
}

variable "environment" {
  description = "The name of the environment"
}

variable "port" {
  default     = 80
  description = "The default ingress port"
}

variable "subnet_ids" {
  type        = "list"
  description = "List of public subnet ids to place the loadbalancer in"
}

variable "internal" {
  default     = true
  description = "List of public subnet ids to place the loadbalancer in"
}

variable "vpc_id" {
  description = "The VPC id"
}

# variable "health_check_path" {
#   default     = "/"
#   description = "The default health check path"
# }

# variable "health_check_port" {
#   default     = "traffic-port"
#   description = "The default health check port"
# }

# variable "health_check_protocol" {
#   default     = "HTTP"
#   description = "The default health check protocol"
# }

variable "allow_cidr_block" {
  default     = "0.0.0.0/0"
  description = "Specify cidr block that is allowd to access the LoadBalancer"
}
