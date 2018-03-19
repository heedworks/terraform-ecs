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
  default     = "7dxvs>)Dmtc2nnc"
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

variable "ecr_domain" {
  description = "The domain name of the ECR registry, e.g account_id.dkr.ecr.region.amazonaws.com"
}

variable "configuration_version" {
  description = "The docker image version, e.g latest or 8.8-alpine"
  default     = "latest"
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
  default     = ""
}

variable "awslogs_stream_prefix" {
  description = "The awslogs stream prefix. defaults to var.cluster"
  default     = ""
}

module "db" {
  source                        = "../rds"
  vpc_id                        = "${var.vpc_id}"
  name                          = "${var.db_name}"
  engine                        = "${var.db_engine}"
  engine_version                = "${var.db_engine_version}"
  database                      = "${coalesce(var.db_database, replace(var.db_name, "-", "_"))}"
  username                      = "${coalesce(var.db_username, replace(var.db_name, "-", "_"))}"
  password                      = "${var.db_password}"
  multi_az                      = "${var.db_multi_az}"
  subnet_ids                    = "${var.db_subnet_ids}"
  ingress_allow_security_groups = "${var.db_ingress_allow_security_groups}"
}

resource "aws_ecs_service" "configuration" {
  name          = "se-kong-configuration"
  cluster       = "${var.cluster}"
  desired_count = 1

  # Track the latest ACTIVE revision
  #   task_definition = "${aws_ecs_task_definition.se-kong-configuration.family}:${max("${aws_ecs_task_definition.se-kong-configuration.revision}", "${data.aws_ecs_task_definition.se-kong-configuration.revision}")}"
  # Track the latest ACTIVE revision
  task_definition = "${module.configuration_task.name}:${module.configuration_task.max_revision}"
}

module "configuration_task" {
  source = "../ecs-task"

  name                  = "se-kong-configuration"
  environment           = "${var.environment}"
  image                 = "${var.ecr_domain}/schedule-engine/se-kong-configuration"
  image_version         = "${var.configuration_version}"
  command               = "${var.configuration_command}"
  memory                = "${var.configuration_memory}"
  cpu                   = "${var.configuration_cpu}"
  ports                 = "[]"
  awslogs_group         = "${var.awslogs_group}"
  awslogs_region        = "${coalesce(var.awslogs_region, var.region)}"
  awslogs_stream_prefix = "${coalesce(var.awslogs_stream_prefix, var.cluster)}"

  #   env_vars      = "${var.configuration_env_vars}"
  env_vars = <<EOF
[
  { "name": "NODE_ENV",                  "value": "integration" }, 
  { "name": "AWS_ACCOUNT_KEY",           "value": "sandbox" },
  { "name": "KONG_PG_CONNECTION_STRING", "value": "${module.db.url}" }
]
EOF
}
