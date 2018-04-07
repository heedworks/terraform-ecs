# -----------------------------------------------------------------------------
# S3 Bucket for hosting se-widget-demo
# -----------------------------------------------------------------------------
data "template_file" "se_widget_demo_policy" {
  template = "${file("${path.module}/templates/public-read-policy.json")}"

  vars = {
    bucket = "${var.aws_account_key}.se-widget-demo"
  }
}

resource "aws_s3_bucket" "se_widget_demo" {
  bucket = "${var.aws_account_key}.se-widget-demo"

  versioning {
    enabled = true
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags {
    Name        = "${var.aws_account_key}.se-widget-demo"
    Environment = "${var.environment}"
  }

  policy = "${data.template_file.se_widget_demo_policy.rendered}"
}

# -----------------------------------------------------------------------------
# S3 Bucket for hosting se-client-dashboard
# -----------------------------------------------------------------------------
data "template_file" "se_client_dashboard_policy" {
  template = "${file("${path.module}/templates/public-read-policy.json")}"

  vars = {
    bucket = "${var.aws_account_key}.se-client-dashboard"
  }
}

resource "aws_s3_bucket" "se_client_dashboard" {
  bucket = "${var.aws_account_key}.se-client-dashboard"

  versioning {
    enabled = true
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags {
    Name        = "${var.aws_account_key}.se-client-dashboard"
    Environment = "${var.environment}"
  }

  policy = "${data.template_file.se_client_dashboard_policy.rendered}"
}

# -----------------------------------------------------------------------------
# S3 Bucket for hosting se-admin-console
# -----------------------------------------------------------------------------
data "template_file" "se_admin_console_policy" {
  template = "${file("${path.module}/templates/public-read-policy.json")}"

  vars = {
    bucket = "${var.aws_account_key}.se-admin-console"
  }
}

resource "aws_s3_bucket" "se_admin_console" {
  bucket = "${var.aws_account_key}.se-admin-console"

  versioning {
    enabled = true
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags {
    Name        = "${var.aws_account_key}.se-admin-console"
    Environment = "${var.environment}"
  }

  policy = "${data.template_file.se_admin_console_policy.rendered}"
}

# -----------------------------------------------------------------------------
# S3 Bucket for hosting se-widget-embed
# -----------------------------------------------------------------------------
data "template_file" "se_widget_embed_policy" {
  template = "${file("${path.module}/templates/public-read-policy.json")}"

  vars = {
    bucket = "${var.aws_account_key}.se-widget-embed"
  }
}

resource "aws_s3_bucket" "se_widget_embed" {
  bucket = "${var.aws_account_key}.se-widget-embed"

  versioning {
    enabled = true
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags {
    Name        = "${var.aws_account_key}.se-widget-embed"
    Environment = "${var.environment}"
  }

  policy = "${data.template_file.se_widget_embed_policy.rendered}"
}

# -----------------------------------------------------------------------------
# S3 Bucket for hosting se-widget-ui-haller
# -----------------------------------------------------------------------------
data "template_file" "se_widget_ui_haller_policy" {
  template = "${file("${path.module}/templates/public-read-policy.json")}"

  vars = {
    bucket = "${var.aws_account_key}-haller.se-widget-ui"
  }
}

resource "aws_s3_bucket" "se_widget_ui_haller" {
  bucket = "${var.aws_account_key}-haller.se-widget-ui"

  versioning {
    enabled = true
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags {
    Name        = "se-widget-ui-haller-${var.aws_account_key}"
    Environment = "${var.environment}"
  }

  policy = "${data.template_file.se_widget_ui_haller_policy.rendered}"
}

# -----------------------------------------------------------------------------
# S3 Bucket for hosting se-widget-ui-croppmetcalfe
# -----------------------------------------------------------------------------
data "template_file" "se_widget_ui_croppmetcalfe_policy" {
  template = "${file("${path.module}/templates/public-read-policy.json")}"

  vars = {
    bucket = "${var.aws_account_key}-croppmetcalfe.se-widget-ui"
  }
}

resource "aws_s3_bucket" "se_widget_ui_croppmetcalfe" {
  bucket = "${var.aws_account_key}-croppmetcalfe.se-widget-ui"

  versioning {
    enabled = true
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags {
    Name        = "${var.aws_account_key}-croppmetcalfe.se-widget-ui"
    Environment = "${var.environment}"
  }

  policy = "${data.template_file.se_widget_ui_croppmetcalfe_policy.rendered}"
}

# -----------------------------------------------------------------------------
# Service Metric CloudWatch Dashboard
# -----------------------------------------------------------------------------
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "service-pulse-dashboard"

  dashboard_body = <<EOF
 {
   "widgets": [
      ${module.se_address_service.cloudwatch_metric_widget},
      ${module.se_admin_console_api.cloudwatch_metric_widget},
      ${module.se_admin_auth_service.cloudwatch_metric_widget},
      ${module.se_agent_api.cloudwatch_metric_widget},
      ${module.se_agent_auth_service.cloudwatch_metric_widget},
      ${module.se_appointment_service.cloudwatch_metric_widget},
      ${module.se_certification_service.cloudwatch_metric_widget},
      ${module.se_client_auth_service.cloudwatch_metric_widget},
      ${module.se_client_dashboard_api.cloudwatch_metric_widget},
      ${module.se_client_service.cloudwatch_metric_widget},
      ${module.se_communication_service.cloudwatch_metric_widget},
      ${module.se_contract_service.cloudwatch_metric_widget},
      ${module.se_customer_auth_service.cloudwatch_metric_widget},
      ${module.se_customer_service.cloudwatch_metric_widget},
      ${module.se_device_auth_service.cloudwatch_metric_widget},
      ${module.se_dispatch_service.cloudwatch_metric_widget},
      ${module.se_erp_notification_service.cloudwatch_metric_widget},
      ${module.se_geocoding_service.cloudwatch_metric_widget},
      ${module.se_location_service.cloudwatch_metric_widget},
      ${module.se_media_service.cloudwatch_metric_widget},
      ${module.se_mobile_api.cloudwatch_metric_widget},
      ${module.se_notification_service.cloudwatch_metric_widget},
      ${module.se_payment_service.cloudwatch_metric_widget},
      ${module.se_phone_lookup_service.cloudwatch_metric_widget},
      ${module.se_room_service.cloudwatch_metric_widget},
      ${module.se_sampro_service.cloudwatch_metric_widget},
      ${module.se_scheduling_service.cloudwatch_metric_widget},
      ${module.se_technician_service.cloudwatch_metric_widget},
      ${module.se_trade_service.cloudwatch_metric_widget},
      ${module.se_vehicle_service.cloudwatch_metric_widget},
      ${module.se_web_api.cloudwatch_metric_widget}
   ]
 }
 EOF
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

  image_tag               = "${lookup(var.image_tag_map, "se-kong", var.default_image_tag)}"
  configuration_image_tag = "${lookup(var.image_tag_map, "se-kong-configuration", var.default_image_tag)}"
  configuration_node_env  = "${lookup(var.node_env_map, "se-kong-configuration", var.default_node_env)}"
  configuration_se_env    = "${lookup(var.se_env_map, "se-kong-configuration", var.default_se_env)}"

  # RDS Variables
  db_subnet_ids      = "${var.internal_subnet_ids}"
  db_security_groups = "${var.kong_db_security_groups}"
  db_name            = "${var.kong_db_name}"
  db_password        = "${var.kong_db_password}"
  awslogs_group      = "${var.ecs_tasks_cloudwatch_log_group}"

  # ALB Variables
  internal_alb_arn              = "${var.internal_alb_arn}"
  internal_alb_listener_arn     = "${var.internal_alb_listener_arn}"
  external_alb_arn              = "${var.external_alb_arn}"
  external_alb_target_group_arn = "${var.external_alb_target_group_arn}"
}

# -----------------------------------------------------------------------------
# ECS task and service for se-address-service
# -----------------------------------------------------------------------------
module "se_address_service" {
  source = "../ecs-service"

  name            = "se-address-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-address-service"
  image_tag = "${lookup(var.image_tag_map, "se-address-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-address-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-address-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-address-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-address-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-address-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-address-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_address_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-admin-console-api
# -----------------------------------------------------------------------------
module "se_admin_console_api" {
  source = "../ecs-service"

  name            = "se-admin-console-api"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-admin-console-api"
  image_tag = "${lookup(var.image_tag_map, "se-admin-console-api", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-admin-console-api", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-admin-console-api", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-admin-console-api", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-admin-console-api", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-admin-console-api", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-admin-console-api", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_admin_console_api")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-admin-auth-service
# -----------------------------------------------------------------------------
module "se_admin_auth_service" {
  source = "../ecs-service"

  name            = "se-admin-auth-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-admin-auth-service"
  image_tag = "${lookup(var.image_tag_map, "se-admin-auth-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-admin-auth-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-admin-auth-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-admin-auth-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-admin-auth-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-admin-auth-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-admin-auth-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_admin_auth_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-agent-api
# -----------------------------------------------------------------------------
module "se_agent_api" {
  source = "../ecs-service"

  name            = "se-agent-api"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"
  desired_count   = 1

  image     = "${var.ecr_domain}/schedule-engine/se-agent-api"
  image_tag = "${lookup(var.image_tag_map, "se-agent-api", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-agent-api", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-agent-api", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-agent-api", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-agent-api", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "DEBUG",                   "value": "kafka-node:*" },
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-agent-api", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-agent-api", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "KAFKA_HOST",              "value": "${var.kafka_host}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_agent_api")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-agent-auth-service
# -----------------------------------------------------------------------------
module "se_agent_auth_service" {
  source = "../ecs-service"

  name            = "se-agent-auth-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-agent-auth-service"
  image_tag = "${lookup(var.image_tag_map, "se-agent-auth-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-agent-auth-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-agent-auth-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-agent-auth-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-agent-auth-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-agent-auth-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-agent-auth-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_agent_auth_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-appointment-service
# -----------------------------------------------------------------------------
module "se_appointment_service" {
  source = "../ecs-service"

  name            = "se-appointment-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-appointment-service"
  image_tag = "${lookup(var.image_tag_map, "se-appointment-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-appointment-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-appointment-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-appointment-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-appointment-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-appointment-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-appointment-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_appointment_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-certification-service
# -----------------------------------------------------------------------------
module "se_certification_service" {
  source = "../ecs-service"

  name            = "se-certification-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-certification-service"
  image_tag = "${lookup(var.image_tag_map, "se-certification-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-certification-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-certification-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-certification-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-certification-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-certification-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-certification-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_certification_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-client-auth-service
# -----------------------------------------------------------------------------
module "se_client_auth_service" {
  source = "../ecs-service"

  name            = "se-client-auth-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-client-auth-service"
  image_tag = "${lookup(var.image_tag_map, "se-client-auth-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-client-auth-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-client-auth-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-client-auth-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-client-auth-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-client-auth-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-client-auth-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_client_auth_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-client-dashboard-api
# -----------------------------------------------------------------------------
module "se_client_dashboard_api" {
  source = "../ecs-service"

  name            = "se-client-dashboard-api"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-client-dashboard-api"
  image_tag = "${lookup(var.image_tag_map, "se-client-dashboard-api", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-client-dashboard-api", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-client-dashboard-api", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-client-dashboard-api", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-client-dashboard-api", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-client-dashboard-api", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-client-dashboard-api", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_client_dashboard_api")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-client-service
# -----------------------------------------------------------------------------
module "se_client_service" {
  source = "../ecs-service"

  name            = "se-client-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-client-service"
  image_tag = "${lookup(var.image_tag_map, "se-client-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-client-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-client-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-client-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-client-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "DEBUG",                   "value": "kafka-node:*" },
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-client-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-client-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "KAFKA_HOST",              "value": "${var.kafka_host}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_client_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-communication-service
# -----------------------------------------------------------------------------
module "se_communication_service" {
  source = "../ecs-service"

  name            = "se-communication-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-communication-service"
  image_tag = "${lookup(var.image_tag_map, "se-communication-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-communication-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-communication-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-communication-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-communication-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-communication-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-communication-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_communication_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-contract-service
# -----------------------------------------------------------------------------
module "se_contract_service" {
  source = "../ecs-service"

  name            = "se-contract-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-contract-service"
  image_tag = "${lookup(var.image_tag_map, "se-contract-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-contract-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-contract-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-contract-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-contract-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-contract-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-contract-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_contract_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-customer-auth-service
# -----------------------------------------------------------------------------
module "se_customer_auth_service" {
  source = "../ecs-service"

  name            = "se-customer-auth-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-customer-auth-service"
  image_tag = "${lookup(var.image_tag_map, "se-customer-auth-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-customer-auth-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-customer-auth-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-customer-auth-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-customer-auth-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-customer-auth-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-customer-auth-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_customer_auth_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-customer-service
# -----------------------------------------------------------------------------
module "se_customer_service" {
  source = "../ecs-service"

  name            = "se-customer-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-customer-service"
  image_tag = "${lookup(var.image_tag_map, "se-customer-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-customer-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-customer-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-customer-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-customer-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-customer-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-customer-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_customer_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-device-auth-service
# -----------------------------------------------------------------------------
module "se_device_auth_service" {
  source = "../ecs-service"

  name            = "se-device-auth-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-device-auth-service"
  image_tag = "${lookup(var.image_tag_map, "se-device-auth-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-device-auth-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-device-auth-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-device-auth-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-device-auth-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-device-auth-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-device-auth-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_device_auth_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-dispatch-service
# -----------------------------------------------------------------------------
module "se_dispatch_service" {
  source = "../ecs-service"

  name            = "se-dispatch-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-dispatch-service"
  image_tag = "${lookup(var.image_tag_map, "se-dispatch-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-dispatch-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-dispatch-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-dispatch-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-dispatch-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-dispatch-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-dispatch-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_dispatch_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-erp-notification-service
# -----------------------------------------------------------------------------
module "se_erp_notification_service" {
  source = "../ecs-service"

  name            = "se-erp-notification-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-erp-notification-service"
  image_tag = "${lookup(var.image_tag_map, "se-erp-notification-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-erp-notification-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-erp-notification-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-erp-notification-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-erp-notification-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-erp-notification-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-erp-notification-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_erp_notification_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-geocoding-service
# -----------------------------------------------------------------------------
module "se_geocoding_service" {
  source = "../ecs-service"

  name            = "se-geocoding-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-geocoding-service"
  image_tag = "${lookup(var.image_tag_map, "se-geocoding-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-geocoding-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-geocoding-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-geocoding-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-geocoding-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-geocoding-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-geocoding-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_geocoding_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-location-service
# -----------------------------------------------------------------------------
module "se_location_service" {
  source = "../ecs-service"

  name            = "se-location-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-location-service"
  image_tag = "${lookup(var.image_tag_map, "se-location-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-location-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-location-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-location-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-location-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-location-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-location-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_location_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-media-service
# -----------------------------------------------------------------------------
module "se_media_service" {
  source = "../ecs-service"

  name            = "se-media-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-media-service"
  image_tag = "${lookup(var.image_tag_map, "se-media-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-media-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-media-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-media-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-media-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-media-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-media-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_media_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-mobile-api
# -----------------------------------------------------------------------------
module "se_mobile_api" {
  source = "../ecs-service"

  name            = "se-mobile-api"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-mobile-api"
  image_tag = "${lookup(var.image_tag_map, "se-mobile-api", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-mobile-api", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-mobile-api", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-mobile-api", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-mobile-api", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-mobile-api", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-mobile-api", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_mobile_api")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-notification-service
# -----------------------------------------------------------------------------
module "se_notification_service" {
  source = "../ecs-service"

  name            = "se-notification-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-notification-service"
  image_tag = "${lookup(var.image_tag_map, "se-notification-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-notification-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-notification-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-notification-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-notification-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-notification-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-notification-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_notification_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-payment-service
# -----------------------------------------------------------------------------
module "se_payment_service" {
  source = "../ecs-service"

  name            = "se-payment-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-payment-service"
  image_tag = "${lookup(var.image_tag_map, "se-payment-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-payment-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-payment-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-payment-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-payment-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-payment-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-payment-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_payment_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-phone-lookup-service
# -----------------------------------------------------------------------------
module "se_phone_lookup_service" {
  source = "../ecs-service"

  name            = "se-phone-lookup-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-phone-lookup-service"
  image_tag = "${lookup(var.image_tag_map, "se-phone-lookup-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-phone-lookup-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-phone-lookup-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-phone-lookup-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-phone-lookup-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-phone-lookup-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-phone-lookup-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_phone_lookup_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-room-service
# -----------------------------------------------------------------------------
module "se_room_service" {
  source = "../ecs-service"

  name            = "se-room-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-room-service"
  image_tag = "${lookup(var.image_tag_map, "se-room-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-room-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-room-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-room-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-room-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-room-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-room-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_room_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-sampro-service
# -----------------------------------------------------------------------------
module "se_sampro_service" {
  source = "../ecs-service"

  name            = "se-sampro-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"
  desired_count   = 1

  image     = "${var.ecr_domain}/schedule-engine/se-sampro-service"
  image_tag = "${lookup(var.image_tag_map, "se-sampro-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-sampro-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-sampro-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-sampro-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-sampro-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "DEBUG",                   "value": "kafka-node:*" },
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-sampro-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-sampro-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "KAFKA_HOST",              "value": "${var.kafka_host}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_sampro_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-scheduling-service
# -----------------------------------------------------------------------------
module "se_scheduling_service" {
  source = "../ecs-service"

  name            = "se-scheduling-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-scheduling-service"
  image_tag = "${lookup(var.image_tag_map, "se-scheduling-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-scheduling-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-scheduling-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-scheduling-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-scheduling-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-scheduling-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-scheduling-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_scheduling_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-technician-service
# -----------------------------------------------------------------------------
module "se_technician_service" {
  source = "../ecs-service"

  name            = "se-technician-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-technician-service"
  image_tag = "${lookup(var.image_tag_map, "se-technician-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-technician-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-technician-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-technician-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-technician-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-technician-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-technician-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_technician_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-trade-service
# -----------------------------------------------------------------------------
module "se_trade_service" {
  source = "../ecs-service"

  name            = "se-trade-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-trade-service"
  image_tag = "${lookup(var.image_tag_map, "se-trade-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-trade-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-trade-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-trade-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-trade-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-trade-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-trade-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_trade_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-vehicle-service
# -----------------------------------------------------------------------------
module "se_vehicle_service" {
  source = "../ecs-service"

  name            = "se-vehicle-service"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-vehicle-service"
  image_tag = "${lookup(var.image_tag_map, "se-vehicle-service", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-vehicle-service", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-vehicle-service", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-vehicle-service", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-vehicle-service", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-vehicle-service", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-vehicle-service", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_vehicle_service")}" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS task and service for se-web-api
# -----------------------------------------------------------------------------
module "se_web_api" {
  source = "../ecs-service"

  name            = "se-web-api"
  cluster         = "${var.cluster}"
  environment     = "${var.environment}"
  aws_account_key = "${var.aws_account_key}"
  vpc_id          = "${var.vpc_id}"
  zone_id         = "${var.zone_id}"

  image     = "${var.ecr_domain}/schedule-engine/se-web-api"
  image_tag = "${lookup(var.image_tag_map, "se-web-api", var.aws_account_key)}"

  port           = 0
  container_port = "${lookup(var.container_port_map, "se-web-api", var.default_container_port)}"

  alb_arn          = "${var.internal_alb_arn}"
  alb_listener_arn = "${var.internal_alb_listener_arn}"

  cpu                = "${lookup(var.task_cpu_map, "se-web-api", var.default_task_cpu)}"
  memory             = "${lookup(var.task_memory_map, "se-web-api", var.default_task_memory)}"
  memory_reservation = "${lookup(var.task_memory_reservation_map, "se-web-api", var.default_task_memory_reservation)}"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${var.cluster}"

  env_vars = <<EOF
  [
    { "name": "NODE_ENV",                "value": "${lookup(var.node_env_map, "se-web-api", var.default_node_env)}" }, 
    { "name": "SE_ENV",                  "value": "${lookup(var.se_env_map, "se-web-api", var.default_se_env)}" },
    { "name": "AWS_ACCOUNT_ID",          "value": "${var.aws_account_id}" },
    { "name": "AWS_ACCOUNT_KEY",         "value": "${var.aws_account_key}" },
    { "name": "AWS_ACCOUNT_NAME",        "value": "${var.aws_account_name}" },
    { "name": "MONGO_CONNECTION_STRING", "value": "${format(var.mongo_connection_string_template, "se_web_api")}" }
  ]
  EOF
}
