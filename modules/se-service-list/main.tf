variable "cluster" {
  description = ""
  default     = "se-app"
}

variable "region" {
  description = ""
  default     = "us-east-1"
}

variable "environment" {
  description = ""
}

variable "node_env" {
  description = "The default NODE_ENV environment variable, defaults to environment variable"
  default     = ""
}

variable "se_env" {
  description = "The default SE_ENV environment variable, defaults to environment variable"
  default     = ""
}

variable "service_port_map" {
  description = ""
  type        = "map"

  default = {}
}

#------------------------------------------------------------------------------
# Service Override Maps
#------------------------------------------------------------------------------
variable "service_container_port_map" {
  description = ""
  type        = "map"

  default = {}
}

variable "service_image_tag_map" {
  description = ""
  type        = "map"

  default = {}
}

variable "service_se_env_map" {
  description = ""
  type        = "map"

  default = {}
}

variable "service_node_env_map" {
  description = ""
  type        = "map"

  default = {}
}

# variable "desired_count_service_map" {
#   description = ""
#   type        = "map"

#   default = {}
# }

# variable "deployment_minimum_healthy_percent_service_override" {
#   description = ""
#   type        = "map"

#   default = {}
# }

# variable "service_deployment_maximum_percent_override" {
#   description = ""
#   type        = "map"

#   default = {}
# }

variable "kong_db_password" {
  description = "Postgres user password"
}

variable "aws_account_key" {}
variable "vpc_id" {}
variable "zone_id" {}
variable "aws_account_name" {}
variable "aws_account_id" {}
variable "ecr_domain" {}

variable "ecs_cluster_security_group_id" {}

variable "internal_alb_security_group_id" {}
variable "external_alb_security_group_id" {}

# variable "external_ssh_security_group_id" {}

variable "internal_subnet_ids" {}
variable "external_subnet_ids" {}

variable "kong_db_security_groups" {}
variable "internal_alb_arn" {}
variable "external_alb_target_group_arn" {}
variable "internal_alb_listener_arn" {}
variable "ecs_tasks_cloudwatch_log_group" {}

# 
variable "mongo_connection_string_template" {
  description = ""
}

# -----------------------------------------------------------------------------
# Kong Admin and Proxy services and tasks
# -----------------------------------------------------------------------------
module "se_kong" {
  source = "../se-kong"

  aws_account_key = "${var.aws_account_key}"
  cluster         = "${var.cluster}"
  region          = "${var.region}"
  environment     = "${var.environment}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"
  ecr_domain      = "${var.ecr_domain}"

  # RDS Variables
  db_subnet_ids      = "${var.internal_subnet_ids}"
  db_security_groups = "${var.kong_db_security_groups}"
  db_password        = "${var.kong_db_password}"
  awslogs_group      = "${var.ecs_tasks_cloudwatch_log_group}"

  # configuration_image_tag = "integration"

  # ALB Variables
  internal_alb_arn              = "${var.internal_alb_arn}"
  internal_alb_listener_arn     = "${var.internal_alb_listener_arn}"
  external_alb_target_group_arn = "${var.external_alb_target_group_arn}"
}

# -----------------------------------------------------------------------------
# ECS task and service for se-mobile-api
# -----------------------------------------------------------------------------
module "se_mobile_api" {
  source = "../se-service"

  name        = "se-mobile-api"
  cluster     = "${var.cluster}"
  environment = "${var.environment}"
  vpc_id      = "${var.vpc_id}"
  image       = "${var.ecr_domain}/schedule-engine/se-mobile-api"
  image_tag   = "${var.aws_account_key}"

  port = "${lookup(var.service_port_map, "se-mobile-api")}"

  zone_id          = "${var.zone_id}"
  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  # Environment Variables
  aws_account_id          = "${var.aws_account_id}"
  aws_account_key         = "${var.aws_account_key}"
  aws_account_name        = "${var.aws_account_name}"
  mongo_connection_string = "${format(var.mongo_connection_string_template, "se_mobile_api")}"

  # AWS CloudWatch Log Variables
  awslogs_group  = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region = "${var.region}"
}

# # -----------------------------------------------------------------------------
# # ECS task and service for se-mobile-api
# # -----------------------------------------------------------------------------
# module "se_mobile_api" {
#   source = "../ecs-service"


#   name        = "se-mobile-api"
#   cluster     = "${module.ecs_cluster.name}"
#   environment = "${var.environment}"
#   vpc_id      = "${module.network.vpc_id}"
#   image       = "${module.defaults.ecr_domain}/schedule-engine/se-mobile-api"
#   image_tag   = "${var.aws_account_key}"


#   port             = "8011"
#   zone_id          = "${module.dns.zone_id}"
#   alb_arn          = "${module.ecs_cluster.internal_alb_arn}"
#   alb_listener_arn = "${module.ecs_cluster.default_internal_alb_listener_arn}"


#   # AWS CloudWatch Log Variables
#   awslogs_group         = "${module.ecs_cluster.ecs_tasks_cloudwatch_log_group}"
#   awslogs_region        = "${var.region}"
#   awslogs_stream_prefix = "${module.ecs_cluster.name}"


#   env_vars = <<EOF
#   [
#     { "name": "NODE_ENV",        "value": "development" }, 
#     { "name": "AWS_ACCOUNT_KEY", "value": "${var.aws_account_key}" }
#   ]
#   EOF
# }


# # -----------------------------------------------------------------------------
# # ECS task and service for se-client-service
# # -----------------------------------------------------------------------------
# module "se_client_service" {
#   source = "../ecs-service"


#   cluster     = "${module.ecs_cluster.name}"
#   name        = "se-client-service"
#   environment = "${var.environment}"
#   vpc_id      = "${module.network.vpc_id}"
#   image       = "${module.defaults.ecr_domain}/schedule-engine/se-client-service"
#   image_tag   = "${var.aws_account_key}"


#   port             = "8006"
#   zone_id          = "${module.dns.zone_id}"
#   alb_arn          = "${module.ecs_cluster.internal_alb_arn}"
#   alb_listener_arn = "${module.ecs_cluster.default_internal_alb_listener_arn}"


#   # AWS CloudWatch Log Variables
#   awslogs_group         = "${module.ecs_cluster.ecs_tasks_cloudwatch_log_group}"
#   awslogs_region        = "${var.region}"
#   awslogs_stream_prefix = "${module.ecs_cluster.name}"


#   env_vars = <<EOF
#   [
#     { "name": "NODE_ENV",                "value": "development" }, 
#     { "name": "SE_ENV",                  "value": "development" },
#     { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
#     { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
#     { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
#     { "name": "MONGO_CONNECTION_STRING", "value": "mongodb://admin:rGmGTpEnhf2%3E%253frvpDXMPUP@cluster0-shard-00-00-hulfh.mongodb.net:27017,cluster0-shard-00-01-hulfh.mongodb.net:27017,cluster0-shard-00-02-hulfh.mongodb.net:27017/se_client_service?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin" }
#   ]
#   EOF
# }


# # -----------------------------------------------------------------------------
# # ECS task and service for se-geocoding-service
# # -----------------------------------------------------------------------------
# module "se_geocoding_service" {
#   source = "../ecs-service"


#   cluster     = "${module.ecs_cluster.name}"
#   name        = "se-geocoding-service"
#   environment = "${var.environment}"
#   vpc_id      = "${module.network.vpc_id}"
#   image       = "${module.defaults.ecr_domain}/schedule-engine/se-geocoding-service"
#   image_tag   = "${var.aws_account_key}"


#   port             = "8037"
#   zone_id          = "${module.dns.zone_id}"
#   alb_arn          = "${module.ecs_cluster.internal_alb_arn}"
#   alb_listener_arn = "${module.ecs_cluster.default_internal_alb_listener_arn}"


#   # AWS CloudWatch Log Variables
#   awslogs_group         = "${module.ecs_cluster.ecs_tasks_cloudwatch_log_group}"
#   awslogs_region        = "${var.region}"
#   awslogs_stream_prefix = "${module.ecs_cluster.name}"


#   env_vars = <<EOF
#   [
#     { "name": "NODE_ENV",                "value": "development" }, 
#     { "name": "SE_ENV",                  "value": "development" },
#     { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
#     { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
#     { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
#     { "name": "MONGO_CONNECTION_STRING", "value": "mongodb://admin:rGmGTpEnhf2%3E%253frvpDXMPUP@cluster0-shard-00-00-hulfh.mongodb.net:27017,cluster0-shard-00-01-hulfh.mongodb.net:27017,cluster0-shard-00-02-hulfh.mongodb.net:27017/se_geocoding_service?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin" }
#   ]
#   EOF
# }

