# variable "ecs_task_image_key" {
#   description = "the key used to reference task images, defaults to aws_account_key variable"
#   default     = ""
# }

# variable "ecs_root_volume_size" {
#   description = "the size of the ecs instance root volume"
#   default     = 25
# }

# variable "ecs_docker_volume_size" {
#   description = "the size of the ecs instance docker volume"
#   default     = 25
# }

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

variable "mongo_connection_string_template" {
  description = "Mongo connection string with a '%s' placeholder for the database name, e.g. mongodb://user:password@cluster0-shard-00-01-hulfh.mongodb.net:27017/%s"
}

# Varaibles for ./modules/se-service-list
variable "service_port_map" {
  type = "map"

  default = {
    se-address-service          = "8028"
    se-admin-console-api        = "8001"
    se-admin-auth-service       = "8002"
    se-agent-api                = "8004"
    se-agent-auth-service       = "8041"
    se-appointment-service      = "8040"
    se-certification-service    = "8034"
    se-client-auth-service      = "8005"
    se-client-dashboard-api     = "8036"
    se-client-service           = "8006"
    se-communication-service    = "8007"
    se-contract-service         = "8044"
    se-customer-auth-service    = "8008"
    se-customer-service         = "8009"
    se-device-auth-service      = "8038"
    se-dispatch-service         = "8010"
    se-erp-notification-service = "8035"
    se-geocoding-service        = "8037"
    se-location-service         = "8029"
    se-media-service            = "8043"
    se-mobile-api               = "8011"
    se-notification-service     = "8042"
    se-payment-service          = "8012"
    se-phone-lookup-service     = "8039"
    se-room-service             = "8032"
    se-sampro-service           = "8013"
    se-scheduling-service       = "8014"
    se-technician-service       = "8015"
    se-trade-service            = "8033"
    se-vehicle-service          = "8030"
    se-web-api                  = "8016"
  }
}

variable "default_node_env" {
  description = "default value for NODE_ENV, e.g. integration"
  default     = "integration"
}

variable "default_se_env" {
  description = "default value for SE_ENV, e.g. integration"
  default     = "sandbox"
}

variable "service_container_port_map" {
  type = "map"

  default = {
    se-kong-admin = "8001"
  }
}

variable "service_image_tag_map" {
  type = "map"

  default = {
    se-mobile-api = "sandbox"
  }
}

variable "service_se_env_map" {
  type = "map"

  default = {
    se-mobile-api = "integration"
  }
}

variable "service_node_env_map" {
  type = "map"

  default = {
    se-mobile-api = "development"
  }
}

variable "service_desired_count_map" {
  type = "map"

  default = {
    se-technician-service = 1
  }
}

variable "service_deployment_minimum_healthy_percent_map" {
  type = "map"

  default = {
    se-room-service = 50
  }
}

variable "service_deployment_maximum_percent_map" {
  type = "map"

  default = {
    se-mobile-api = 100
  }
}

# Configure the Terraform backend storage
# NOTE: Terraform does not support variables in this block
terraform {
  backend "s3" {
    bucket         = "schedule-engine-terraform-sandbox"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform_state_lock"
    acl            = "private"
    profile        = "se-sandbox-account-terraform"
  }
}

provider "aws" {
  region  = "${var.region}"
  profile = "${var.aws_creds_profile}"

  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id}:role/TerraformRole"
    session_name = "terraform"
  }
}

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
  external_alb_target_group_arn = "${module.se_stack.default_external_alb_target_group_arn}"

  internal_subnet_ids = "${module.se_stack.internal_subnet_ids}"
  external_subnet_ids = "${module.se_stack.external_subnet_ids}"

  # Environment Variables
  default_node_env                 = "${var.default_node_env}"
  default_se_env                   = "${var.default_se_env}"
  aws_account_id                   = "${var.aws_account_id}"
  aws_account_key                  = "${var.aws_account_key}"
  aws_account_name                 = "${var.aws_account_name}"
  mongo_connection_string_template = "${var.mongo_connection_string_template}"

  ecr_domain                     = "${module.se_stack.ecr_domain}"
  ecs_tasks_cloudwatch_log_group = "${module.se_stack.ecs_tasks_cloudwatch_log_group}"

  # Service Maps
  port_map           = "${var.service_port_map}"
  container_port_map = "${var.service_container_port_map}"
  node_env_map       = "${var.service_node_env_map}"
  se_env_map         = "${var.service_se_env_map}"
  image_tag_map      = "${var.service_image_tag_map}"
}

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
