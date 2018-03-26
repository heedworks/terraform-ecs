# variable "region" {}
# variable "aws_account_id" {}
# variable "aws_creds_profile" {}
# variable "vpc_cidr" {}
# variable "cluster" {}
# variable "environment" {}
# variable "aws_account_key" {}
# variable "ecs_task_image_key" {}
# variable "max_size" {}
# variable "min_size" {}
# variable "desired_capacity" {}
# variable "instance_type" {}
# variable "ecs_aws_ami" {}
# variable "private_subnet_cidrs" {
#   type = "list"
# }
# variable "public_subnet_cidrs" {
#   type = "list"
# }
# variable "availability_zones" {
#   type = "list"
# }

variable "name" {
  description = "the name of your stack, e.g. \"se-app\""
}

variable "aws_creds_profile" {
  description = ""
}

variable "aws_account_id" {
  description = ""
}

variable "aws_account_key" {
  description = "the schedule engine aws account key"
}

variable "aws_account_name" {
  description = "the schedule engine aws account key"
}

variable "environment" {
  description = "the name of your environment, e.g. \"integration\""
}

variable "key_name" {
  description = "the name of the ssh key to use, e.g. \"internal-key\""
}

variable "external_domain_name" {
  description = "the external DNS name to use for the external load balancer"
  default     = "integration.sedev.net"
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

variable "ecs_task_image_key" {
  description = "the key used to reference task images, defaults to aws_account_key variable"
  default     = ""
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

variable "ecs_root_volume_size" {
  description = "the size of the ecs instance root volume"
  default     = 25
}

variable "ecs_docker_volume_size" {
  description = "the size of the ecs instance docker volume"
  default     = 25
}

variable "ecs_ami" {
  description = "The AMI that will be used to launch EC2 instances in the ECS cluster, defaults to the default image for the selected region"
  default     = ""
}

# variable "ecs_docker_auth_type" {
#   description = "The docker auth type, see https://godoc.org/github.com/aws/amazon-ecs-agent/agent/engine/dockerauth for the possible values"
#   default     = ""
# }

# variable "ecs_docker_auth_data" {
#   description = "A JSON object providing the docker auth data, see https://godoc.org/github.com/aws/amazon-ecs-agent/agent/engine/dockerauth for the supported formats"
#   default     = ""
# }

# variable "domain_name_servers" {
#   description = "the internal DNS servers, defaults to the internal route53 server of the VPC"
#   default     = ""
# }

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

  name                  = "${var.name}"
  region                = "${var.region}"
  environment           = "${var.environment}"
  aws_account_id        = "${var.aws_account_id}"
  aws_account_key       = "${var.aws_account_key}"
  aws_account_name      = "${var.aws_account_name}"
  ecs_cluster_name      = "${coalesce(var.ecs_cluster_name, var.name)}"
  cloudwatch_prefix     = "${var.environment}"                          # See ecs-instances module when to set this and when not!
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

# module "ecs" {
#   source = "../../modules/ecs-cluster"

#   region               = "${var.region}"
#   environment          = "${var.environment}"
#   cluster              = "${var.cluster}"
#   cloudwatch_prefix    = "${var.environment}"           # See ecs-instances module when to set this and when not!
#   vpc_cidr             = "${var.vpc_cidr}"
#   public_subnet_cidrs  = "${var.public_subnet_cidrs}"
#   private_subnet_cidrs = "${var.private_subnet_cidrs}"
#   availability_zones   = "${var.availability_zones}"
#   max_size             = "${var.max_size}"
#   min_size             = "${var.min_size}"
#   desired_capacity     = "${var.desired_capacity}"
#   key_name             = "${aws_key_pair.ecs.key_name}"
#   instance_type        = "${var.instance_type}"
#   ecs_aws_ami          = "${var.ecs_aws_ami}"
# }

# resource "aws_key_pair" "ecs" {
#   key_name   = "ecs-key-${var.environment}"
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDLbxjBtIjSLo7KQx24Ym/CGVl5FJyA2KbeL5WzMK58Zy6a5n0RbKEcr0HvdzdEHyG84sx7rkZdKryBQmFr4ov0tJ8UbXQ1SsHaRAE1KnJf3mHrBvNHHUF3yMFE5WGS7fT/iyEPqpVKJgyBRBKYAyoOcQmzAYA7ZE13cbrwqq9tYT+/lnmhr3/2IbISDnkkMwCjyp3WTXTmuKsLGtLGDnajExkZmj6EmekxTRW99ISVwm+k+oHzXx+FdMuyy/zkD8U6mQoB4+WK0HDEErol11puB4AWMH7FZlju893ao/LBg+XPz5g+JwrafQEUKy1jTHfosTgsRIYmIjRKW7hmFeL/9woca3in4osDZZ4VVvDfq+oiBhOVNlIC9N3bAU3ZiYZwu74LpF1K971r/8c9qIm8d7aXqZWl134Kc7zi4FRL5a6BqOWtGeR91GcXvJIqaTPa+TpgGsl0oT0Kugjzj/FoTVJe8l9GZJ/1HSYVB6/O0Ja584erdkEwyAM46t/y0YQgCtlc0KKBiN5TilbY7NToyouulNCvA9lIJVDdrLZF6LxXrPsvA4h4ow1TaA2QpgOcgF1XPdmuN8dUQ3KYL3ssw0DL56QF2dkDpDYHfyJQlBHyWpDwvX3EYYvZZq4V2BvXBKBMmplWx84UHfb5ulEXYdn/qq2Dl3rnMtqbkDX+Qw== ecs-key-staging"
# }

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
