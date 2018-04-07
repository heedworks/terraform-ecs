# -----------------------------------------------------------------------------
# Terraform Backend Configuration
# 
# Configure the Terraform backend storage
# NOTE: Terraform does not support variables in this block
# -----------------------------------------------------------------------------
terraform {
  backend "s3" {
    bucket         = "schedule-engine-terraform-integration"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform_state_lock"
    acl            = "private"
    profile        = "se-integration-account-terraform"
  }
}

# -----------------------------------------------------------------------------
# Terraform AWS Provider
# -----------------------------------------------------------------------------
provider "aws" {
  region  = "${var.region}"
  profile = "${var.aws_creds_profile}"

  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id}:role/TerraformRole"
    session_name = "terraform"
  }
}

# -----------------------------------------------------------------------------
# se-stack module (infrastructure)
# -----------------------------------------------------------------------------
module "se_stack" {
  source = "../../modules/se-stack"

  name        = "${var.name}"
  region      = "${var.region}"
  environment = "${var.environment}"

  aws_account_id   = "${var.aws_account_id}"
  aws_account_key  = "${var.aws_account_key}"
  aws_account_name = "${var.aws_account_name}"

  ecs_cluster_name      = "${coalesce(var.ecs_cluster_name, var.name)}"
  cloudwatch_prefix     = "${var.environment}"
  vpc_cidr              = "${var.vpc_cidr}"
  external_subnets      = "${var.external_subnets}"
  internal_subnets      = "${var.internal_subnets}"
  availability_zones    = "${var.availability_zones}"
  ecs_max_size          = "${var.ecs_max_size}"
  ecs_min_size          = "${var.ecs_min_size}"
  ecs_desired_capacity  = "${var.ecs_desired_capacity}"
  ecs_instance_type     = "${var.ecs_instance_type}"
  bastion_instance_type = "${var.bastion_instance_type}"
  ecs_ami               = "${var.ecs_ami}"
  key_name              = "${var.key_name}"
  internal_domain_name  = "${var.internal_domain_name}"
  external_domain_name  = "${var.external_domain_name}"
}

# -----------------------------------------------------------------------------
# se-service-list module (SE Tasks and Services)
# -----------------------------------------------------------------------------
module "se_service_list" {
  source = "../../modules/se-service-list"

  region      = "${var.region}"
  cluster     = "${module.se_stack.cluster}"
  environment = "${var.environment}"
  vpc_id      = "${module.se_stack.vpc_id}"
  zone_id     = "${module.se_stack.zone_id}"

  kong_db_password        = "${var.kong_db_password}"
  kong_db_security_groups = "${module.se_stack.ecs_cluster_security_group_id},${module.se_stack.external_ssh_security_group_id}"

  ecs_cluster_security_group_id = "${module.se_stack.ecs_cluster_security_group_id}"

  internal_alb_arn              = "${module.se_stack.internal_alb_arn}"
  internal_alb_listener_arn     = "${module.se_stack.default_internal_alb_listener_arn}"
  external_alb_arn              = "${module.se_stack.external_alb_arn}"
  external_alb_target_group_arn = "${module.se_stack.default_external_alb_target_group_arn}"

  internal_subnet_ids = "${module.se_stack.internal_subnet_ids}"
  external_subnet_ids = "${module.se_stack.external_subnet_ids}"

  default_image_tag = "${var.default_image_tag}"

  # Environment Variables
  default_node_env                 = "${var.default_node_env}"
  default_se_env                   = "${var.default_se_env}"
  aws_account_id                   = "${var.aws_account_id}"
  aws_account_key                  = "${var.aws_account_key}"
  aws_account_name                 = "${var.aws_account_name}"
  kafka_host                       = "${var.kafka_host}"
  mongo_connection_string_template = "${var.mongo_connection_string_template}"

  ecr_domain                     = "${module.se_stack.ecr_domain}"
  ecs_tasks_cloudwatch_log_group = "${module.se_stack.ecs_tasks_cloudwatch_log_group}"

  # Service Maps
  container_port_map = "${var.service_container_port_map}"

  node_env_map  = "${var.service_node_env_map}"
  se_env_map    = "${var.service_se_env_map}"
  image_tag_map = "${var.service_image_tag_map}"

  # Task Defaults
  default_task_cpu                = "${var.default_task_cpu}"
  default_task_memory             = "${var.default_task_memory}"
  default_task_memory_reservation = "${var.default_task_memory_reservation}"
}

# -----------------------------------------------------------------------------
# Module Variables
# -----------------------------------------------------------------------------
variable "name" {
  description = "the name of your stack, e.g. se-app"
  default     = "se-app"
}

variable "aws_creds_profile" {
  description = "AWS credentials profile with Terraform credentials"
}

variable "aws_account_id" {
  description = "the schedule engine aws account id"
}

variable "aws_account_key" {
  description = "the schedule engine aws account key"
}

variable "aws_account_name" {
  description = "the schedule engine aws account key"
}

variable "environment" {
  description = "the name of your environment, e.g. integration"
}

variable "key_name" {
  description = "the name of the ssh key to use, e.g. internal-key"
}

variable "external_domain_name" {
  description = "the external DNS name to use for the external load balancer"
  default     = "env.sedev.net"
}

variable "internal_domain_name" {
  description = "the internal DNS name to use with services"
  default     = "internal"
}

variable "region" {
  description = "the AWS region in which resources are created, you must set the availability_zones variable as well if you define this value to something other than the default"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "the CIDR block to provision for the VPC, if set to something other than the default, both internal_subnets and external_subnets have to be defined as well"
  default     = "10.0.0.0/16"
}

variable "internal_subnets" {
  description = "a list of CIDRs for internal subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones"
  default     = ["10.0.50.0/24", "10.0.51.0/24", "10.0.52.0/24"]
}

variable "external_subnets" {
  description = "a list of CIDRs for external subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones"
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zones" {
  description = "a comma-separated list of availability zones, defaults to all AZ of the region, if set to something other than the defaults, both internal_subnets and external_subnets have to be defined as well"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "bastion_instance_type" {
  description = "Instance type for the bastion"
  default     = "t2.micro"
}

variable "ecs_cluster_name" {
  description = "the name of the cluster, if not specified the variable name will be used"
  default     = ""
}

variable "ecs_instance_type" {
  description = "the instance type to use for your default ecs cluster"
  default     = "t2.micro"
}

variable "ecs_min_size" {
  description = "the minimum number of instances to use in the default ecs cluster"

  // create 3 instances in our cluster by default
  // 2 instances to run our service with high-availability
  // 1 extra instance so we can deploy without port collisions
  default = 3
}

variable "ecs_max_size" {
  description = "the maximum number of instances to use in the default ecs cluster"
  default     = 100
}

variable "ecs_desired_capacity" {
  description = "the desired number of instances to use in the default ecs cluster"
  default     = 3
}

variable "ecs_ami" {
  description = "The AMI that will be used to launch EC2 instances in the ECS cluster, defaults to the default image for the selected region"
  default     = ""
}

variable "kong_db_password" {
  description = "Postgres user password"
}

variable "kafka_host" {
  description = "Kafka host"
}

variable "mongo_connection_string_template" {
  description = "Mongo connection string with a '%s' placeholder for the database name, e.g. mongodb://user:password@cluster0-shard-00-01-hulfh.mongodb.net:27017/%s"
}

variable "service_port_map" {
  description = "default value for the task ECR image tag, e.g. integration"
  type        = "map"

  default = {}
}

# TODO: remove these default values
variable "default_image_tag" {
  description = "default value for the task ECR image tag, e.g. integration"
}

variable "default_node_env" {
  description = "default value for NODE_ENV, e.g. integration"
}

variable "default_se_env" {
  description = "default value for SE_ENV, e.g. integration"
}

variable "default_task_cpu" {
  description = "default number of cpu units to reserve for the container"
}

variable "default_task_memory" {
  description = "default maximum number of MiB of memory to reserve for the container"
}

variable "default_task_memory_reservation" {
  description = "default number of MiB of memory to reserve for the container"
}

variable "service_container_port_map" {
  type = "map"

  default = {
    se-kong-admin = "8001"
  }
}

variable "service_image_tag_map" {
  type = "map"

  default = {}
}

variable "service_se_env_map" {
  type = "map"

  default = {}
}

variable "service_node_env_map" {
  type = "map"

  default = {}
}

variable "service_desired_count_map" {
  type = "map"

  default = {
    se-technician-service = 1
  }
}

variable "service_deployment_minimum_healthy_percent_map" {
  type = "map"

  default = {}
}

variable "service_deployment_maximum_percent_map" {
  type = "map"

  default = {}
}

# -----------------------------------------------------------------------------
# Module Outputs
# -----------------------------------------------------------------------------

// The region in which the infrastructure lives.
output "region" {
  value = "${var.region}"
}

// The AWS account key
output "aws_account_key" {
  value = "${var.aws_account_key}"
}

// The environment of the infrastructure
output "environment" {
  value = "${var.environment}"
}

// The bastion host IP.
output "bastion_ip" {
  value = "${module.se_stack.bastion_ip}"
}

// The bastion host IP.
output "run_command_to_copy_bastion_private_key" {
  value = "make copy-key IP=${module.se_stack.bastion_ip} ACCOUNT=${var.aws_account_key}"
}
