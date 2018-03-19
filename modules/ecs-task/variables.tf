/**
 * Required Variables.
 */

variable "image" {
  description = "The docker image name, e.g node:8.8-alpine"
}

variable "name" {
  description = "The worker name, if empty the service name is defaulted to the image name"
}

variable "environment" {
  description = "The application environment. e.g. production"
}

/**
 * Optional Variables.
 */

variable "cpu" {
  description = "The number of cpu units to reserve for the container"
  default     = 512
}

variable "env_vars" {
  description = "The raw json of the task env vars"
  default     = "[]"
} # [{ "name": name, "value": value }]

variable "command" {
  description = "The raw json of the task command"
  default     = "[]"
} # ["--key=foo","--port=bar"]

variable "entry_point" {
  description = "The docker container entry point"
  default     = "[]"
}

variable "ports" {
  description = "The docker container ports"
  default     = "[]"
}

variable "image_version" {
  description = "The docker image version"
  default     = "latest"
}

variable "memory" {
  description = "The number of MiB of memory to reserve for the container"
  default     = 512
}

variable "log_driver" {
  description = "The log driver to use use for the container"
  default     = "awslogs"
}

variable "role" {
  description = "The IAM Role to assign to the Container"
  default     = ""
}

variable "awslogs_group" {
  description = "The awslogs group. defaults to var.environment/ecs/tasks"
  default     = ""
}

variable "awslogs_region" {
  description = "The awslogs group. defaults to var.environment/ecs/tasks"
  default     = ""
}

variable "awslogs_stream_prefix" {
  description = "The awslogs stream prefix. defaults to var.environment/ecs/tasks"
  default     = ""
}
