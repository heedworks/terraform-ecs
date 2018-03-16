variable "load_balancer_arn" {
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

variable "default_action" {
  default = "forward"
}

variable "target_group_arn" {
  description = "ARN of the Target Group for the Listener"
}
