# -----------------------------------------------------------------------------
# RDS database instance for se-kong
# -----------------------------------------------------------------------------
module "db" {
  source = "../rds"

  vpc_id                        = "${var.vpc_id}"
  name                          = "${var.db_name}"
  engine                        = "${var.db_engine}"
  engine_version                = "${var.db_engine_version}"
  database                      = "${coalesce(var.db_database, replace(var.db_name, "-", "_"))}"
  username                      = "${coalesce(var.db_username, replace(var.db_name, "-", "_"))}"
  password                      = "${var.db_password}"
  multi_az                      = "${var.db_multi_az}"
  subnet_ids                    = "${var.db_subnet_ids}"
  ingress_allow_security_groups = ["${split(",",var.db_security_groups)}"]
}

# -----------------------------------------------------------------------------
# ECS service for se-kong-configuration
# -----------------------------------------------------------------------------
resource "aws_ecs_service" "configuration" {
  name          = "se-kong-configuration"
  cluster       = "${var.cluster}"
  desired_count = 1

  # Track the latest ACTIVE revision
  task_definition = "${module.configuration_task.name}:${module.configuration_task.max_revision}"
}

# -----------------------------------------------------------------------------
# ECS task for se-kong-configuration
# -----------------------------------------------------------------------------
module "configuration_task" {
  source = "../ecs-task"

  name        = "se-kong-configuration"
  environment = "${var.environment}"
  image       = "${var.ecr_domain}/schedule-engine/se-kong-configuration"
  image_tag   = "${coalesce(var.configuration_image_tag, var.aws_account_key)}"

  command               = "${var.configuration_command}"
  ports                 = "[]"
  awslogs_group         = "${var.awslogs_group}"
  awslogs_region        = "${coalesce(var.awslogs_region, var.region)}"
  awslogs_stream_prefix = "${coalesce(var.awslogs_stream_prefix, var.cluster)}"

  env_vars = <<EOF
  [
    { "name": "KONG_PG_CONNECTION_STRING", "value": "${module.db.db_connection_string}" }
  ]
  EOF
}

module "migrations_task" {
  source = "../ecs-task"

  name        = "se-kong-migrations"
  environment = "${var.environment}"
  image       = "${var.ecr_domain}/schedule-engine/se-kong"
  image_tag   = "${coalesce(var.image_tag, var.aws_account_key)}"
  env_vars    = "${var.env_vars}"
  command     = "[\"kong\",\"migrations\",\"up\"]"
  ports       = "[]"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.awslogs_group}"
  awslogs_region        = "${coalesce(var.awslogs_region, var.region)}"
  awslogs_stream_prefix = "${coalesce(var.awslogs_stream_prefix, var.cluster)}"

  env_vars = <<EOF
  [
    { "name": "KONG_DATABASE",    "value": "postgres" }, 
    { "name": "KONG_PG_USER",     "value": "${module.db.username}" },
    { "name": "KONG_PG_PASSWORD", "value": "${var.db_password}" },
    { "name": "KONG_PG_HOST",     "value": "${module.db.address}" },
    { "name": "KONG_PG_PORT",     "value": "${module.db.port}" },
    { "name": "KONG_PG_DATABASE", "value": "${coalesce(var.db_database, replace(var.db_name, "-", "_"))}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-kong-admin
# -----------------------------------------------------------------------------
module "admin" {
  source = "../ecs-service"

  name            = "se-kong-admin"
  aws_account_key = "${var.aws_account_key}"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  vpc_id          = "${var.vpc_id}"

  image            = "${var.ecr_domain}/schedule-engine/se-kong"
  image_tag        = "${coalesce(var.image_tag, var.aws_account_key)}"
  container_port   = "${var.admin_container_port}"
  port             = "${var.admin_port}"
  zone_id          = "${var.zone_id}"
  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  # Deployment Variables
  desired_count                      = "${var.admin_desired_count}"
  deployment_minimum_healthy_percent = "${var.admin_deployment_minimum_healthy_percent}"
  deployment_maximum_percent         = "${var.admin_deployment_maximum_percent}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.awslogs_group}"
  awslogs_region        = "${coalesce(var.awslogs_region, var.region)}"
  awslogs_stream_prefix = "${coalesce(var.awslogs_stream_prefix, var.cluster)}"

  env_vars = <<EOF
  [
    { "name": "KONG_DATABASE",    "value": "postgres" }, 
    { "name": "KONG_PG_USER",     "value": "${module.db.username}" },
    { "name": "KONG_PG_PASSWORD", "value": "${var.db_password}" },
    { "name": "KONG_PG_HOST",     "value": "${module.db.address}" },
    { "name": "KONG_PG_PORT",     "value": "${module.db.port}" },
    { "name": "KONG_PG_DATABASE", "value": "${coalesce(var.db_database, replace(var.db_name, "-", "_"))}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS service for se-kong-proxy
# -----------------------------------------------------------------------------
resource "aws_ecs_service" "proxy" {
  name    = "se-kong-proxy"
  cluster = "${var.cluster}"

  desired_count                      = "${var.proxy_desired_count}"
  deployment_minimum_healthy_percent = "${var.proxy_deployment_minimum_healthy_percent}"
  deployment_maximum_percent         = "${var.proxy_deployment_maximum_percent}"

  lifecycle {
    create_before_destroy = true
  }

  # Track the latest ACTIVE revision
  task_definition = "${module.proxy_task.name}:${module.proxy_task.max_revision}"

  load_balancer {
    target_group_arn = "${var.external_alb_target_group_arn}"
    container_name   = "${module.proxy_task.name}"
    container_port   = "${var.proxy_container_port}"
  }
}

# -----------------------------------------------------------------------------
# ECS task for se-kong-proxy
# -----------------------------------------------------------------------------
module "proxy_task" {
  source = "../ecs-task"

  name        = "se-kong-proxy"
  environment = "${var.environment}"
  image       = "${var.ecr_domain}/schedule-engine/se-kong"
  image_tag   = "${coalesce(var.image_tag, var.aws_account_key)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.awslogs_group}"
  awslogs_region        = "${coalesce(var.awslogs_region, var.region)}"
  awslogs_stream_prefix = "${coalesce(var.awslogs_stream_prefix, var.cluster)}"

  ports = <<EOF
  [
    {
      "protocol": "TCP",
      "containerPort": ${var.proxy_container_port},
      "hostPort": ${var.proxy_port}
    }
  ]
  EOF

  env_vars = <<EOF
  [
    { "name": "KONG_DATABASE",    "value": "postgres" }, 
    { "name": "KONG_PG_HOST",     "value": "${module.db.address}" },
    { "name": "KONG_PG_DATABASE", "value": "${coalesce(var.db_database, replace(var.db_name, "-", "_"))}" },
    { "name": "KONG_PG_USER",     "value": "${module.db.username}" },
    { "name": "KONG_PG_PASSWORD", "value": "${var.db_password}" }
  ]
  EOF
}
