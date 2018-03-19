variable "region" {}
variable "aws_account_id" {}
variable "aws_creds_profile" {}

variable "ecr_policy_sid" {
  default = "se-app-read-only"
}

variable "ecr_policy_principal" {
  default = <<EOF
{
  "AWS": "arn:aws:iam::205210731340:root",
  "AWS": "arn:aws:iam::616175625615:root"
}
EOF
}

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
  source           = "../../modules/ecr"
  name             = "ignite/aws-python"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "ignite-se-deploy" {
  source           = "../../modules/ecr"
  name             = "ignite/se-deploy"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

# Schedule Engine Repositories

module "se-address-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-address-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-admin-console-api" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-admin-console-api"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-admin-auth-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-admin-auth-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-admin-console" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-admin-console"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-agent-api" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-agent-api"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-agent-auth-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-agent-auth-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-appointment-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-appointment-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-certification-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-certification-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-client-auth-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-client-auth-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-client-dashboard" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-client-dashboard"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-client-dashboard-api" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-client-dashboard-api"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-client-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-client-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-communication-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-communication-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-contract-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-contract-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-customer-auth-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-customer-auth-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-customer-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-customer-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-device-auth-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-device-auth-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-dispatch-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-dispatch-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-erp-notification-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-erp-notification-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-geocoding-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-geocoding-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-kafka" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-kafka"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-kafka-rest" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-kafka-rest"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-kafka-topics-ui" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-kafka-topics-ui"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-kafka-zookeeper" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-kafka-zookeeper"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-kong" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-kong"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-kong-configuration" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-kong-configuration"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-kong-konga" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-kong-konga"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-location-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-location-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-media-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-media-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-mobile-api" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-mobile-api"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-notification-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-notification-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-payment-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-payment-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-phone-lookup-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-phone-lookup-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-room-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-room-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-sampro-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-sampro-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-scheduling-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-scheduling-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-technician-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-technician-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-trade-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-trade-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-vehicle-service" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-vehicle-service"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-web-api" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-web-api"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-widget-ui" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-widget-ui"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}

module "se-widget-embed" {
  source           = "../../modules/ecr"
  name             = "schedule-engine/se-widget-embed"
  policy_sid       = "${var.ecr_policy_sid}"
  policy_principal = "${var.ecr_policy_principal}"
}
