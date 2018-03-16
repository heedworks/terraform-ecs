variable "name" {
  description = ""
}

variable "vpc_id" {
  description = ""
}

variable "port" {
  default     = 80
  description = "The default ingress port"
}

variable "protocol" {
  default = "Target Protocol for the ALB Listener"
  default = "HTTP"
}

variable "deregistration_delay" {
  default     = "300"
  description = "The default alb deregistration delay"
}

variable "health_check_path" {
  default     = "/"
  description = "The default health check path"
}

variable "health_check_port" {
  default     = "traffic-port"
  description = "The default health check port"
}

variable "health_check_protocol" {
  default     = "HTTP"
  description = "The default health check protocol"
}

variable "allow_cidr_block" {
  default     = "0.0.0.0/0"
  description = "Specify cidr block that is allowd to access the LoadBalancer"
}
