variable "name" {
  description = "The name of the security groups serves as a prefix, e.g se-app"
}

variable "vpc_id" {
  description = "The VPC ID"
}

variable "environment" {
  description = "The environment, used for tagging, e.g production"
}

variable "cidr" {
  description = "The cidr block to use for internal security groups"
}
