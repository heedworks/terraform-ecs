/**
 * The task module creates an ECS task definition.
 *
 * Usage:
 *
 *     module "se-mobile-api" {
 *       source        = "../ecs-task"
 *       name          = "se-mobile-api"
 *       image         = "302058597523.dkr.ecr.us-east-1.amazonaws.com/schedule-engine/se-kong:integration"
 *       image_tag = "integration"
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

  container_definitions = <<EOF
[
  {
    "name": "${var.name}",
    "cpu": ${var.cpu},
    "environment": ${var.env_vars},
    "essential": true,
    "command": ${var.command},
    "image": "${var.image}:${var.image_tag}",
    "memory": ${var.memory},
    "portMappings": ${var.ports},
    "entryPoint": ${var.entry_point},
    "mountPoints": [],
    "logConfiguration": {
      "logDriver": "${var.log_driver}",
      "options": {
        "awslogs-group": "${coalesce(var.awslogs_group, format("%s/ecs/tasks", var.environment))}",
        "awslogs-region": "${var.awslogs_region}",
        "awslogs-stream-prefix": "${var.awslogs_stream_prefix}"
      }
    }
  }
]
EOF
}
