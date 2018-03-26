variable "name" {
  description = ""
}

variable "aws_account_key" {
  description = ""
}

variable "cluster" {
  description = ""
}

variable "environment" {
  description = ""
}

variable "vpc_id" {
  description = ""
}

variable "zone_id" {
  description = ""
}

variable "port" {
  description = ""
}

variable "container_port" {
  description = ""
  default     = 8000
}

variable "image" {
  description = ""
}

variable "image_tag" {
  description = ""
}

variable "alb_arn" {
  description = ""
}

variable "alb_listener_arn" {
  description = ""
}

variable "awslogs_group" {
  description = ""
}

variable "awslogs_region" {
  description = ""
  default     = "us-east-1"
}

variable "wslogs_stream_prefix" {
  description = ""
  default     = ""
}

variable "se_env" {
  description = ""
  default     = ""
}

variable "node_env" {
  description = ""
  default     = ""
}

variable "mongo_connection_string" {
  description = ""
}

# -----------------------------------------------------------------------------
# ECS task and service for a Schedule Engine service
# -----------------------------------------------------------------------------
module "ecs_service" {
  source = "../ecs-service"

  name             = "${var.name}"
  cluster          = "${var.cluster}"
  environment      = "${var.environment}"
  vpc_id           = "${var.vpc_id}"
  image            = "${var.image}"
  image_tag        = "${var.aws_account_key}"
  port             = "${var.port}"
  container_port   = "${var.container_port}"
  zone_id          = "${var.zone_id}"
  alb_arn          = "${var.alb_arn}"
  alb_listener_arn = "${var.alb_listener_arn}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.awslogs_group}"
  awslogs_region        = "${var.awslogs_region}"
  awslogs_stream_prefix = "${coalesce(var.awslogs_stream_prefix, var.cluster)}"

  env_vars = <<EOF
    [
      { "name": "NODE_ENV",                "value": "${coalesce(var.node_env, var.environment)}" }, 
      { "name": "SE_ENV",                  "value": "${coalesce(var.se_env, var.environment)}" },
      { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
      { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
      { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
      { "name": "MONGO_CONNECTION_STRING", "value": "${var.mongo_connection_string}" }
    ]
    EOF
}
