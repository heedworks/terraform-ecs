# variable "region" {
#   description = "The AWS region"
# }

# variable "environment" {
#   description = "The name of the environment"
# }

# variable "cluster" {
#   default     = "default"
#   description = "The name of the ECS cluster"
# }

# variable "instance_group" {
#   default     = "default"
#   description = "The name of the instances that you consider as a group"
# }

# variable "vpc_cidr" {
#   description = "VPC cidr block. Example: 10.0.0.0/16"
# }

# variable "private_subnet_cidrs" {
#   type        = "list"
#   description = "List of private cidrs, for every avalibility zone you want you need one. Example: 10.0.0.0/24 and 10.0.1.0/24"
# }

# variable "public_subnet_cidrs" {
#   type        = "list"
#   description = "List of public cidrs, for every avalibility zone you want you need one. Example: 10.0.0.0/24 and 10.0.1.0/24"
# }

# variable "load_balancers" {
#   type        = "list"
#   default     = []
#   description = "The load balancers to couple to the instances"
# }

# variable "availability_zones" {
#   type        = "list"
#   description = "List of avalibility zones you want. Example: eu-west-1a and eu-west-1b"
# }

# variable "max_size" {
#   description = "Maximum size of the nodes in the cluster"
# }

# variable "min_size" {
#   description = "Minimum size of the nodes in the cluster"
# }

# variable "desired_capacity" {
#   description = "The desired capacity of the cluster"
# }

# variable "key_name" {
#   description = "SSH key name to be used"
# }

# variable "instance_type" {
#   description = "AWS instance type to use"
# }

# variable "ecs_aws_ami" {
#   description = "The AWS ami id to use for ECS"
# }

variable "name" {
  description = "the name of your stack, e.g. \"se-app\""
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

# variable "domain_name_servers" {
#   description = "the internal DNS servers, defaults to the internal route53 server of the VPC"
#   default     = ""
# }

variable "aws_account_key" {
  description = "the schedule engine aws account key"
  default     = ""
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

# variable "ecs_docker_auth_type" {
#   description = "The docker auth type, see https://godoc.org/github.com/aws/amazon-ecs-agent/agent/engine/dockerauth for the possible values"
#   default     = ""
# }

# variable "ecs_docker_auth_data" {
#   description = "A JSON object providing the docker auth data, see https://godoc.org/github.com/aws/amazon-ecs-agent/agent/engine/dockerauth for the supported formats"
#   default     = ""
# }

variable "ecs_ami" {
  description = "The AMI that will be used to launch EC2 instances in the ECS cluster, defaults to the default image for the selected region"
  default     = ""
}

variable "custom_userdata" {
  default     = ""
  description = "Inject extra command in the instance template to be run on boot"
}

variable "ecs_config" {
  default     = "echo '' > /etc/ecs/ecs.config"
  description = "Specify ecs configuration or get it from S3. Example: aws s3 cp s3://some-bucket/ecs.config /etc/ecs/ecs.config"
}

variable "ecs_logging" {
  default     = "[\"json-file\",\"awslogs\"]"
  description = "Adding logging option to ECS that the Docker containers can use. It is possible to add fluentd as well"
}

variable "cloudwatch_prefix" {
  default     = ""
  description = "If you want to avoid cloudwatch collision or you don't want to merge all logs to one log group specify a prefix"
}

variable "alb_deregistration_delay" {
  default     = "300"
  description = "The default alb deregistration delay"
}

variable "alb_health_check_path" {
  default     = "/"
  description = "The default health check path"
}

variable "alb_health_check_port" {
  default     = "traffic-port"
  description = "The default health check port"
}

variable "alb_health_check_protocol" {
  default     = "HTTP"
  description = "The default health check protocol"
}

# variable "region" {
#   default     = "us-east-1"
#   description = ""
# }


# variable "aws_account_id" {
#   description = ""
# }


# variable "aws_creds_profile" {
#   description = ""
# }


# variable "vpc_cidr" {
#   description = ""
# }


# variable "cluster" {
#   description = ""
# }


# variable "environment" {
#   description = ""
# }


# variable "max_size" {
#   description = ""
# }


# variable "min_size" {
#   description = ""
# }


# variable "desired_capacity" {
#   description = ""
# }


# variable "instance_type" {
#   description = ""
# }


# variable "ecs_aws_ami" {
#   description = ""
# }


# variable "private_subnet_cidrs" {
#   type = "list"
# }


# variable "public_subnet_cidrs" {
#   type = "list"
# }


# variable "availability_zones" {
#   type = "list"
# }

