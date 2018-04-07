variable "cluster" {
  description = ""
  default     = "se-app"
}

variable "region" {
  description = ""
  default     = "us-east-1"
}

variable "environment" {
  description = ""
}

variable "default_container_port" {
  description = "default container port"
  default     = 8000
}

variable "default_image_tag" {
  description = "The default image_tag for ECR images"
}

variable "default_node_env" {
  description = "The default NODE_ENV environment variable"
}

variable "default_se_env" {
  description = "The default SE_ENV environment variable"
}

variable "default_task_cpu" {
  description = "default number of cpu units to reserve for the container"
  default     = 0
}

variable "default_task_memory" {
  description = "default maximum number of MiB of memory to reserve for the container"
  default     = 256
}

variable "default_task_memory_reservation" {
  description = "default number of MiB of memory to reserve for the container"
  default     = 64
}

variable "default_desired_count" {
  description = "The desired task instance count"
  default     = 2
}

variable "default_deployment_minimum_healthy_percent" {
  description = "default lower limit (% of desired_count) of # of running tasks during a deployment"
  default     = 100
}

variable "default_deployment_maximum_percent" {
  description = "default upper limit (% of desired_count) of # of running tasks during a deployment"
  default     = 200
}

variable "port_map" {
  description = "map of service name and host port"
  type        = "map"

  default = {}
}

#------------------------------------------------------------------------------
# Service Override Maps
#------------------------------------------------------------------------------
variable "container_port_map" {
  description = "map of service name to container port to override the default_container_port variable, if applicable"
  type        = "map"

  default = {}
}

variable "image_tag_map" {
  description = "map of service name to container port to override the default_image_tag variable, if applicable"
  type        = "map"

  default = {}
}

variable "se_env_map" {
  description = "map of service name to container port to override the default_se_env variable, if applicable"
  type        = "map"

  default = {}
}

variable "node_env_map" {
  description = "map of service name to container port to override the default_node_env variable, if applicable"
  type        = "map"

  default = {}
}

variable "task_cpu_map" {
  description = "map of service name to task cpu value to override the default_task_cpu variable, if applicable"
  type        = "map"

  default = {}
}

variable "task_memory_map" {
  description = "map of service name to task memory value to override the default_task_memory variable, if applicable"
  type        = "map"

  default = {}
}

variable "task_memory_reservation_map" {
  description = "map of service name to task memory_reservation value to override the default_task_memory_reservation variable, if applicable"
  type        = "map"

  default = {}
}

variable "kong_db_name" {
  description = "RDS instance name"
  default     = "se-kong-postgres"
}

variable "kong_db_password" {
  description = "RDS user password"
}

variable "aws_account_key" {
  description = ""
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "zone_id" {
  description = "The ID of the hosted zone to contain this record."
}

variable "aws_account_name" {
  description = ""
}

variable "aws_account_id" {
  description = ""
}

variable "ecr_domain" {
  description = ""
}

variable "ecs_cluster_security_group_id" {
  description = ""
}

# variable "internal_alb_security_group_id" {
#   description = ""
# }

# variable "external_alb_security_group_id" {
#   description = ""
# }

# variable "external_ssh_security_group_id" {}

variable "internal_subnet_ids" {
  description = "A list of internal subnet IDs"
  type        = "list"
}

variable "external_subnet_ids" {
  description = "A list of external subnet IDs"
  type        = "list"
}

variable "kong_db_security_groups" {
  description = ""
}

variable "internal_alb_arn" {
  description = ""
}

variable "external_alb_arn" {
  description = ""
}

variable "external_alb_target_group_arn" {
  description = ""
}

variable "internal_alb_listener_arn" {
  description = ""
}

variable "ecs_tasks_cloudwatch_log_group" {
  description = ""
}

variable "mongo_connection_string_template" {
  description = "Mongo connection string with a '%s' placeholder for the database name, e.g. mongodb://user:password@cluster0-shard-00-01-hulfh.mongodb.net:27017/%s"
}

variable "kafka_host" {
  description = "Kafka host string, e.g. ip-10-0-50-34.ec2.internal:9092,ip-10-0-51-136.ec2.internal:9092"
}
