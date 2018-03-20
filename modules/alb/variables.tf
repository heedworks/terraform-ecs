# Required Variables

variable "environment" {
  description = "The name of the environment"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "subnet_ids" {
  type        = "list"
  description = "List of public subnet ids to place the loadbalancer in"
}

# Optional Variables

variable "name" {
  default     = "default"
  description = "The name of the loadbalancer"
}

# variable "port" {
#   default     = 80
#   description = "The default ingress port"
# }

variable "internal" {
  default     = true
  description = "List of public subnet ids to place the loadbalancer in"
}

# variable "target_group_port" {
#   default     = ""
#   description = "The port on which the default target group receive traffic, defaults to port"
# }


# variable "deregistration_delay" {
#   default     = "300"
#   description = "The default alb deregistration delay"
# }


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


# variable "allow_cidr_block" {
#   default     = "0.0.0.0/0"
#   description = "Specify cidr block that is allowd to access the LoadBalancer"
# }

