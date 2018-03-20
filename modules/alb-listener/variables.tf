variable "load_balancer_arn" {
  description = "The ARN of the load balancer."
}

variable "port" {
  description = "The port on which the load balancer is listening."
  default     = "80"
}

variable "protocol" {
  default = "The protocol for connections from clients to the load balancer. Valid values are TCP, HTTP and HTTPS. Defaults to HTTP."
  default = "HTTP"
}

variable "default_action" {
  description = "The type of routing action. The only valid value is forward."
  default     = "forward"
}

variable "target_group_arn" {
  description = "The ARN of the Target Group to which to route traffic."
}
