variable "vpc_cidr" {
  description = "VPC cidr block. Example: 10.0.0.0/16"
}

variable "environment" {
  description = "The name of the environment"
}

variable "name" {
  description = "Name tag, e.g se-app"
  default     = "se-app"
}

variable "destination_cidr_block" {
  default     = "0.0.0.0/0"
  description = "Specify all traffic to be routed either trough Internet Gateway or NAT to access the internet"
}

variable "internal_subnets" {
  type        = "list"
  description = "List of internal cidrs, for every avalibility zone you want you need one. Example: 10.0.0.0/24 and 10.0.1.0/24"
}

variable "external_subnets" {
  type        = "list"
  description = "List of external cidrs, for every avalibility zone you want you need one. Example: 10.0.0.0/24 and 10.0.1.0/24"
}

variable "availability_zones" {
  type        = "list"
  description = "List of avalibility zones you want. Example: eu-west-1a and eu-west-1b"
}

variable "depends_id" {}
