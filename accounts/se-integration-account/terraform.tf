variable "region" {}
variable "aws_account_id" {}
variable "aws_creds_profile" {}
variable "vpc_cidr" {}
variable "cluster" {}
variable "environment" {}
variable "max_size" {}
variable "min_size" {}
variable "desired_capacity" {}
variable "instance_type" {}
variable "ecs_aws_ami" {}

variable "private_subnet_cidrs" {
  type = "list"
}

variable "public_subnet_cidrs" {
  type = "list"
}

variable "availability_zones" {
  type = "list"
}

# Configure the Terraform backend storage
# NOTE: Terraform does not support variables in this block
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

provider "aws" {
  region  = "${var.region}"
  profile = "${var.aws_creds_profile}"

  assume_role {
    role_arn     = "arn:aws:iam::${var.aws_account_id}:role/TerraformRole"
    session_name = "terraform"
  }
}

module "ecs" {
  source = "../../modules/ecs-cluster"

  region               = "${var.region}"
  environment          = "${var.environment}"
  cluster              = "${var.cluster}"
  cloudwatch_prefix    = "${var.environment}"           # See ecs-instances module when to set this and when not!
  vpc_cidr             = "${var.vpc_cidr}"
  public_subnet_cidrs  = "${var.public_subnet_cidrs}"
  private_subnet_cidrs = "${var.private_subnet_cidrs}"
  availability_zones   = "${var.availability_zones}"
  max_size             = "${var.max_size}"
  min_size             = "${var.min_size}"
  desired_capacity     = "${var.desired_capacity}"
  key_name             = "${aws_key_pair.ecs.key_name}"
  instance_type        = "${var.instance_type}"
  ecs_aws_ami          = "${var.ecs_aws_ami}"
}

resource "aws_key_pair" "ecs" {
  key_name   = "ecs-key-${var.environment}"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDLbxjBtIjSLo7KQx24Ym/CGVl5FJyA2KbeL5WzMK58Zy6a5n0RbKEcr0HvdzdEHyG84sx7rkZdKryBQmFr4ov0tJ8UbXQ1SsHaRAE1KnJf3mHrBvNHHUF3yMFE5WGS7fT/iyEPqpVKJgyBRBKYAyoOcQmzAYA7ZE13cbrwqq9tYT+/lnmhr3/2IbISDnkkMwCjyp3WTXTmuKsLGtLGDnajExkZmj6EmekxTRW99ISVwm+k+oHzXx+FdMuyy/zkD8U6mQoB4+WK0HDEErol11puB4AWMH7FZlju893ao/LBg+XPz5g+JwrafQEUKy1jTHfosTgsRIYmIjRKW7hmFeL/9woca3in4osDZZ4VVvDfq+oiBhOVNlIC9N3bAU3ZiYZwu74LpF1K971r/8c9qIm8d7aXqZWl134Kc7zi4FRL5a6BqOWtGeR91GcXvJIqaTPa+TpgGsl0oT0Kugjzj/FoTVJe8l9GZJ/1HSYVB6/O0Ja584erdkEwyAM46t/y0YQgCtlc0KKBiN5TilbY7NToyouulNCvA9lIJVDdrLZF6LxXrPsvA4h4ow1TaA2QpgOcgF1XPdmuN8dUQ3KYL3ssw0DL56QF2dkDpDYHfyJQlBHyWpDwvX3EYYvZZq4V2BvXBKBMmplWx84UHfb5ulEXYdn/qq2Dl3rnMtqbkDX+Qw== ecs-key-staging"
}

# output "default_alb_target_group" {
#   value = "${module.ecs.default_alb_target_group}"
# }

