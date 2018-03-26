# variable "alb_dns_name" {}
# variable "cname_record" {}

/**
 * Required Variables.
 */

variable "environment" {
  description = "Environment tag, e.g production"
}

variable "name" {
  description = "The service name"
}

variable "image" {
  description = "The docker image name, e.g node"
}

# variable "subnet_ids" {
#   description = "Comma separated list of subnet IDs that will be passed to the ELB module"
# }

# variable "security_groups" {
#   description = "Comma separated list of security group IDs that will be passed to the ELB module"
# }

variable "port" {
  description = "The container host port"
}

variable "cluster" {
  description = "The cluster name or ARN"
}

variable "zone_id" {
  description = "The zone ID to create the record in"
}

# variable "log_bucket" {
#   description = "The S3 bucket ID to use for the ELB"
# }

variable "vpc_id" {
  description = "The VPC ID"
}

variable "alb_arn" {
  description = "The ARN of the ALB for the service"
}

variable "alb_listener_arn" {
  description = "The ARN of the ALB listener for the service"
}

/**
 * Optional Variables
 */
variable "image_tag" {
  description = "The docker image tag. defaults to environment variable"
  default     = ""
}

variable "dns_name" {
  description = "The DNS name to use, e.g se-mobile-api, defaults to name variable"
  default     = ""
}

variable "domain_name" {
  description = "the internal DNS name to use with services"
  default     = "internal"
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

variable "container_port" {
  description = "The container port"
  default     = 8000
}

variable "command" {
  description = "The raw json of the task command"
  default     = "[]"
}

variable "env_vars" {
  description = "The raw json of the task env vars"
  default     = "[]"
}

variable "desired_count" {
  description = "The desired count"
  default     = 2
}

variable "memory" {
  description = "The number of MiB of memory to reserve for the container"
  default     = 256
}

variable "cpu" {
  description = "The number of cpu units to reserve for the container"
  default     = 128
}

variable "protocol" {
  description = "The ALB protocol, HTTP or TCP"
  default     = "HTTP"
}

variable "iam_role" {
  description = "IAM Role ARN to use"
  default     = ""
}

variable "deployment_minimum_healthy_percent" {
  description = "lower limit (% of desired_count) of # of running tasks during a deployment"
  default     = 100
}

variable "deployment_maximum_percent" {
  description = "upper limit (% of desired_count) of # of running tasks during a deployment"
  default     = 200
}

variable "awslogs_group" {
  description = "The awslogs group. defaults to var.environment/ecs/tasks"
  default     = ""
}

variable "awslogs_region" {
  description = "The awslogs group. defaults to var.region"
  default     = ""
}

variable "awslogs_stream_prefix" {
  description = "The awslogs stream prefix. defaults to var.cluster"
  default     = ""
}
