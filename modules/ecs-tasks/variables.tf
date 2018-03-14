variable "environment" {
  description = "The name of the environment"
}

variable "cluster" {
  default     = "default"
  description = "The name of the ECS cluster"
}

variable "default_alb_target_group" {
  description = "The default ALB target group"
}

variable "private_alb_target_group" {
  description = "The private ALB target group"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "deregistration_delay" {
  default     = "300"
  description = "The default deregistration delay"
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
