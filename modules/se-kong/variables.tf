variable "aws_account_key" {
  description = "The AWS_ACCOUNT_KEY value to set in each kong task, e.g. integration, sandbox, production"
}

variable "cluster" {
  description = "The name of the ECS cluster"
}

variable "region" {
  description = "The AWS region of the ECS cluster"
}

variable "environment" {
  description = "Environment tag, e.g prod"
}

variable "vpc_id" {
  description = "The VPC ID to use"
}

variable "zone_id" {
  description = "The zone ID to create the record in"
}

variable "db_subnet_ids" {
  description = "A list of subnet IDs"
  type        = "list"
}

variable "db_name" {
  description = "RDS instance name"
  default     = "se-kong-postgres"
}

variable "db_engine" {
  description = "Database engine: mysql, postgres, etc."
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Database version"
  default     = "10.1"
}

variable "db_port" {
  description = "Port for database to listen on"
  default     = 5432
}

variable "db_database" {
  description = "The database name for the RDS instance (if not specified, `var.db_name` will be used)"
  default     = "se_kong"
}

variable "db_username" {
  description = "The username for the RDS instance (if not specified, `var.db_name` will be used)"
  default     = "se_admin"
}

variable "db_password" {
  description = "Postgres user password"
}

variable "db_multi_az" {
  description = "If true, database will be placed in multiple AZs for HA"
  default     = false
}

variable "db_ingress_allow_security_groups" {
  description = "A list of security group IDs to allow traffic from"
  type        = "list"
  default     = []
}

variable "db_security_groups" {
  description = "Comma separated list of security group IDs to allow traffic from"
}

variable "ecr_domain" {
  description = "The domain name of the ECR registry, e.g account_id.dkr.ecr.region.amazonaws.com"
}

# variable "node_env" {
#   description = "The NODE_ENV value to set in each kong task, e.g. development, production"
# }

variable "image_version" {
  description = "The docker image version, e.g latest or 8.8-alpine (if not specified, var.aws_account_key will be used)"
  default     = ""
}

variable "configuration_image_version" {
  description = "The docker image version, e.g latest or 8.8-alpine (if not specified, var.aws_account_key will be used)"
  default     = ""
}

variable "configuration_cpu" {
  description = "The number of cpu units to reserve for the container"
  default     = 128
}

variable "configuration_command" {
  description = "The raw json of the task command"
  default     = "[]"
} # ["--key=foo","--port=bar"]

variable "configuration_memory" {
  description = "The number of MiB of memory to reserve for the container"
  default     = 128
}

variable "awslogs_group" {
  description = "The awslogs group. defaults to var.environment/ecs/tasks"
  default     = ""
}

variable "awslogs_region" {
  description = "The awslogs group. defaults to var.region"
  default     = "us-east-1"
}

variable "awslogs_stream_prefix" {
  description = "The awslogs stream prefix. defaults to var.cluster"
  default     = ""
}

variable "internal_alb_arn" {
  description = "The ARN of the ALB target group for se-kong-admin"
}

variable "internal_alb_listener_arn" {
  description = "The ARN of the ALB listener for se-kong-admin"
}

variable "external_alb_target_group_arn" {
  description = "The ARN of the ALB target group for se-kong-proxy"
}

variable "admin_port" {
  description = ""
  default     = "8022"
}

variable "admin_container_port" {
  description = ""
  default     = "8001"
}

variable "proxy_port" {
  description = ""
  default     = "8021"
}

variable "proxy_container_port" {
  description = ""
  default     = "8000"
}

variable "admin_desired_count" {
  description = "The desired count"
  default     = 2
}

variable "admin_deployment_minimum_healthy_percent" {
  description = "lower limit (% of desired_count) of # of running tasks during a deployment"
  default     = 100
}

variable "admin_deployment_maximum_percent" {
  description = "upper limit (% of desired_count) of # of running tasks during a deployment"
  default     = 200
}

variable "proxy_desired_count" {
  description = "The desired count"
  default     = 2
}

variable "proxy_deployment_minimum_healthy_percent" {
  description = "lower limit (% of desired_count) of # of running tasks during a deployment"
  default     = 100
}

variable "proxy_deployment_maximum_percent" {
  description = "upper limit (% of desired_count) of # of running tasks during a deployment"
  default     = 200
}
