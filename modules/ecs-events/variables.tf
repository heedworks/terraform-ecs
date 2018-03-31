variable "environment" {
  description = "The name of the environment"
}

variable "region" {
  description = "The region of the ECS cluster"
  default     = "us-east-1"
}

variable "cluster" {
  description = "The name of the ECS cluster"
  default     = "default"
}
