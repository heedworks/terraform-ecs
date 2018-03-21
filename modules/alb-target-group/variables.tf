variable "name" {
  description = "The name of the target group."
}

variable "environment" {
  description = "The name of the environment"
}

variable "vpc_id" {
  description = "The identifier of the VPC in which to create the target group."
}

variable "port" {
  description = "The default ingress port"
  default     = 80
}

variable "protocol" {
  description = "The protocol to use for routing traffic to the targets."
  default     = "HTTP"
}

variable "deregistration_delay" {
  description = "The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds."
  default     = "300"
}

variable "health_check_path" {
  description = "The default health check path"
  default     = "/"
}

variable "health_check_port" {
  description = "The port to use to connect with the target. Valid values are either ports 1-65536, or traffic-port."
  default     = "traffic-port"
}

variable "health_check_protocol" {
  description = "The protocol to use to connect with the target. Defaults to HTTP."
  default     = "HTTP"
}

variable "health_check_matcher" {
  description = "The HTTP codes to use when checking for a successful response from a target. You can specify multiple values (for example, 200,202) or a range of values (for example, 200-299)."
  default     = "200"
}
