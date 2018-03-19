variable "name" {
  description = "Zone name, e.g stack.local"
}

variable "vpc_id" {
  description = "The VPC ID (omit to create a public zone)"
  default     = ""
}

variable "comment" {
  default     = "Managed by Terraform"
  description = "Zone comment, e.g Managed by Terraform"
}
