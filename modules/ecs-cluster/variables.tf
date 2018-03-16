variable "region" {
  description = "The AWS region"
}

variable "environment" {
  description = "The name of the environment"
}

variable "name" {
  default     = "default"
  description = "The name of the ECS cluster"
}

variable "instance_group" {
  default     = "default"
  description = "The name of the instances that you consider as a group"
}

variable "vpc_cidr" {
  description = "VPC cidr block. Example: 10.0.0.0/16"
}

# variable "internal_subnets" {
#   type        = "list"
#   description = "List of internal cidrs, for every avalibility zone you want you need one. Example: 10.0.0.0/16 and 10.0.1.0/16"
# }

# variable "external_subnets" {
#   type        = "list"
#   description = "List of external cidrs, for every avalibility zone you want you need one. Example: 10.0.0.0/16 and 10.0.1.0/16"
# }

variable "load_balancers" {
  type        = "list"
  default     = []
  description = "The load balancers to couple to the instances"
}

# variable "availability_zones" {
#   type        = "list"
#   description = "List of avalibility zones you want. Example: eu-west-1a and eu-west-1b"
# }

variable "max_size" {
  description = "Maximum size of the nodes in the cluster"
}

variable "min_size" {
  description = "Minimum size of the nodes in the cluster"
}

variable "desired_capacity" {
  description = "The desired capacity of the cluster"
}

variable "key_name" {
  description = "SSH key name to be used"
}

variable "instance_type" {
  description = "AWS instance type to use"
}

variable "image_id" {
  description = "The AWS ami id to use for ECS"
}

variable "bastion_instance_type" {
  description = "Instance type for the bastion"
  default     = "t2.micro"
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

variable "vpc_id" {
  description = ""
}

variable "internal_subnet_ids" {
  description = ""
}

variable "external_subnet_ids" {
  description = ""
}

variable "depends_id" {
  description = ""
}
