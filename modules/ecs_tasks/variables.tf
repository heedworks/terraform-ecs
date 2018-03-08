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
