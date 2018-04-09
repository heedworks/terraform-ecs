/**
 * The task module creates an ECS task definition.
 *
 * Usage:
 *
 *     module "se_kafka_task" {
 *       source    = "../se-kafka-task"
 *       name      = "se-kafka-1"
 *       image     = "confluentinc/cp-zookeeper"
 *       image_tag = "latest"
 *     }
 *
 */

/**
 * Resources
 */

# The ECS task definition.

data "aws_ecs_task_definition" "main" {
  task_definition = "${aws_ecs_task_definition.main.family}"
  depends_on      = ["aws_ecs_task_definition.main"]
}

resource "aws_ecs_task_definition" "main" {
  family        = "${var.name}"
  task_role_arn = "${var.role}"

  lifecycle {
    ignore_changes        = ["image"]
    create_before_destroy = true
  }

  volume {
    name      = "kafka-data"
    host_path = "/kafka-data"
  }

  container_definitions = <<EOF
[
  {
    "name": "${var.name}",
    "environment": ${var.env_vars},
    "essential": true,
    "command": ${var.command},
    "image": "${var.image}:${var.image_tag}",
    "cpu": ${var.cpu},
    "memory": ${var.memory},
    "memoryReservation": ${var.memory_reservation},
    "portMappings": ${var.ports},
    "entryPoint": ${var.entry_point},
    "volumesFrom": ${var.volumes_from},
    "logConfiguration": {
      "logDriver": "${var.log_driver}",
      "options": {
        "awslogs-group": "${coalesce(var.awslogs_group, format("%s/ecs/tasks", var.environment))}",
        "awslogs-region": "${var.awslogs_region}",
        "awslogs-stream-prefix": "${var.awslogs_stream_prefix}"
      }
    },
    "mountPoints": [
      {
        "sourceVolume": "kafka-data",
        "containerPath": "/var/lib/kafka/data"
      }
    ]
  }
]
EOF
}
