variable "cidr" {
  description = "VPC cidr block. Example: 10.0.0.0/16"
}

variable "environment" {
  description = "The name of the environment"
}

variable "name" {
  description = "Name tag, e.g se-app"
  default     = "se-app"
}
