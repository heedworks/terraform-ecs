module "defaults" {
  source = "../defaults"

  region = "${var.region}"
  cidr   = "${var.vpc_cidr}"
}

module "network" {
  source = "../network"

  name               = "${var.name}"
  environment        = "${var.environment}"
  vpc_cidr           = "${var.vpc_cidr}"
  external_subnets   = "${var.external_subnets}"
  internal_subnets   = "${var.internal_subnets}"
  availability_zones = "${var.availability_zones}"
  depends_id         = ""
}

module "security_groups" {
  source      = "../security-groups"
  name        = "${var.name}"
  vpc_id      = "${module.network.vpc_id}"
  environment = "${var.environment}"
  cidr        = "${var.vpc_cidr}"
}

module "bastion" {
  source = "../bastion"

  cluster         = "${var.name}"
  region          = "${var.region}"
  instance_type   = "${var.bastion_instance_type}"
  subnet_id       = "${element(module.network.external_subnet_ids, 0)}"
  security_groups = "${module.security_groups.external_ssh},${module.security_groups.internal_ssh}"
  vpc_id          = "${module.network.vpc_id}"
  key_name        = "${var.key_name}"
  environment     = "${var.environment}"

  # subnet_id       = "${element(module.vpc.external_subnets, 0)}"
  # instance_type   = "${var.bastion_instance_type}"
  # security_groups = "${module.security_groups.external_ssh},${module.security_groups.internal_ssh}"
}

module "dhcp" {
  source = "../dhcp"

  vpc_id = "${module.network.vpc_id}"

  # name    = "ec2.internal"
  # servers = "AmazonProvidedDNS"

  name    = "${module.dns.name}"
  servers = "${module.defaults.domain_name_servers}"

  # servers = "${coalesce(var.domain_name_servers, module.defaults.domain_name_servers)}"
  # servers = "${cidrhost(var.vpc_cidr, 2)}"
}

module "dns" {
  source = "../dns"

  name   = "${var.internal_domain_name}"
  vpc_id = "${module.network.vpc_id}"
}

module "ecs_cluster" {
  source = "../ecs-cluster"

  region      = "${var.region}"
  environment = "${var.environment}"

  name            = "${coalesce(var.ecs_cluster_name, var.name)}"
  security_groups = "${module.security_groups.internal_ssh},${module.security_groups.internal_alb},${module.security_groups.external_alb}"

  cloudwatch_prefix = "${var.environment}"
  vpc_cidr          = "${var.vpc_cidr}"

  # external_subnets   = "${var.external_subnets}"
  # internal_subnets   = "${var.internal_subnets}"
  # availability_zones = "${var.availability_zones}"

  max_size               = "${var.ecs_max_size}"
  min_size               = "${var.ecs_min_size}"
  desired_capacity       = "${var.ecs_desired_capacity}"
  key_name               = "${aws_key_pair.ecs.key_name}"
  instance_type          = "${var.ecs_instance_type}"
  instance_ebs_optimized = "${var.ecs_instance_ebs_optimized}"
  root_volume_size       = "${var.ecs_root_volume_size}"
  docker_volume_size     = "${var.ecs_docker_volume_size}"
  image_id               = "${coalesce(var.ecs_ami, module.defaults.ecs_ami)}"
  # new variables
  vpc_id                      = "${module.network.vpc_id}"
  depends_id                  = "${module.network.depends_id}"
  internal_subnet_ids         = "${module.network.internal_subnet_ids}"
  external_subnet_ids         = "${module.network.external_subnet_ids}"
  internal_alb_security_group = "${module.security_groups.internal_alb}"
  external_alb_security_group = "${module.security_groups.external_alb}"
}

resource "aws_key_pair" "ecs" {
  key_name   = "${var.key_name}"
  public_key = "${file(format("%s/../../ssh-keys/se-%s-account.key.pub", path.module, var.aws_account_key))}"
}

module "se_confluent" {
  source = "../se-confluent"

  ami                  = "${coalesce(var.ecs_ami, module.defaults.ecs_ami)}"
  region               = "${var.region}"
  availability_zones   = "${var.availability_zones}"
  environment          = "${var.environment}"
  cluster              = "${module.ecs_cluster.name}"
  key_name             = "${aws_key_pair.ecs.key_name}"
  instance_type        = "${var.ecs_instance_type}"
  iam_instance_profile = "${module.ecs_cluster.iam_instance_profile}"
  security_groups      = "${module.ecs_cluster.security_group_id}"
  subnet_ids           = "${module.network.internal_subnet_ids}"
  zone_id              = "${module.dns.zone_id}"

  #   # AWS CloudWatch Log Variables
  awslogs_group         = "${module.ecs_cluster.ecs_tasks_cloudwatch_log_group}"
  awslogs_region        = "${var.region}"
  awslogs_stream_prefix = "${module.ecs_cluster.name}"
}

# module "se_kong" {
#   source = "../se-kong"


#   aws_account_key = "${var.aws_account_key}"
#   cluster         = "${module.ecs_cluster.name}"
#   vpc_id          = "${module.network.vpc_id}"
#   zone_id         = "${module.dns.zone_id}"
#   environment     = "${var.environment}"


#   # region          = "${var.region}"


#   # RDS Variables
#   db_subnet_ids      = "${module.network.internal_subnet_ids}"
#   db_security_groups = "${module.ecs_cluster.security_group_id},${module.security_groups.external_ssh}"
#   db_password        = "7dxvs>)Dmtc2nnc"
#   ecr_domain         = "${module.defaults.ecr_domain}"
#   awslogs_group      = "${module.ecs_cluster.ecs_tasks_cloudwatch_log_group}"


#   # configuration_image_tag = "integration"


#   # ALB Variables
#   internal_alb_arn              = "${module.ecs_cluster.internal_alb_arn}"
#   internal_alb_listener_arn     = "${module.ecs_cluster.default_internal_alb_listener_arn}"
#   external_alb_target_group_arn = "${module.ecs_cluster.default_external_alb_target_group_arn}"
# }


# #
# # ECS task and service for se-mobile-api
# #


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


# #
# # ECS task and service for se-client-service
# #


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


# #
# # ECS task and service for se-geocoding-service
# #


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

