variable "region" {}
variable "aws_account_id" {}
variable "aws_creds_profile" {}

terraform {
  backend "s3" {
    bucket         = "schedule-engine-terraform-ecr"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform_state_lock"
    acl            = "private"
    profile        = "se-ecr-account-terraform"
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

# Ignite Repositories

module "ignite-aws-python" {
  source = "../../modules/ecr"
  name   = "ignite/aws-python"
}

# Schedule Engine Repositories

# module "se-kong" {
#   source = "../../modules/ecr"
#   name   = "schedule-engine/se-kong"
# }

# module "se-address-service" {
#   source = "../../modules/ecr"
#   name   = "schedule-engine/se-address-service"
# }

# module "se-client-service" {
#   source = "../../modules/ecr"
#   name   = "schedule-engine/se-client-service"
# }

# module "se-mobile-api" {
#   source = "../../modules/ecr"
#   name   = "schedule-engine/se-mobile-api"
# }

module "se-address-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-address-service"
}

module "se-admin-console-api" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-admin-console-api"
}

module "se-admin-auth-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-admin-auth-service"
}

module "se-admin-console" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-admin-console"
}

module "se-agent-api" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-agent-api"
}

module "se-agent-auth-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-agent-auth-service"
}

module "se-appointment-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-appointment-service"
}

module "se-certification-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-certification-service"
}

module "se-client-auth-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-client-auth-service"
}

module "se-client-dashboard" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-client-dashboard"
}

module "se-client-dashboard-api" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-client-dashboard-api"
}

module "se-client-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-client-service"
}

module "se-communication-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-communication-service"
}

module "se-contract-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-contract-service"
}

module "se-customer-auth-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-customer-auth-service"
}

module "se-customer-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-customer-service"
}

module "se-device-auth-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-device-auth-service"
}

module "se-dispatch-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-dispatch-service"
}

module "se-erp-notification-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-erp-notification-service"
}

module "se-geocoding-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-geocoding-service"
}

module "se-kafka" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-kafka"
}

module "se-kafka-rest" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-kafka-rest"
}

module "se-kafka-topics-ui" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-kafka-topics-ui"
}

module "se-kafka-zookeeper" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-kafka-zookeeper"
}

module "se-kong" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-kong"
}

module "se-kong-configuration" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-kong-configuration"
}

module "se-kong-konga" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-kong-konga"
}

module "se-location-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-location-service"
}

module "se-media-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-media-service"
}

module "se-mobile-api" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-mobile-api"
}

module "se-notification-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-notification-service"
}

module "se-payment-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-payment-service"
}

module "se-phone-lookup-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-phone-lookup-service"
}

module "se-room-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-room-service"
}

module "se-sampro-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-sampro-service"
}

module "se-scheduling-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-scheduling-service"
}

module "se-technician-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-technician-service"
}

module "se-trade-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-trade-service"
}

module "se-vehicle-service" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-vehicle-service"
}

module "se-web-api" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-web-api"
}

module "se-widget-ui" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-widget-ui"
}

module "se-widget-embed" {
  source = "../../modules/ecr"
  name   = "schedule-engine/se-widget-embed"
}
