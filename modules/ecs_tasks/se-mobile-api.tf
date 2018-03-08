data "aws_ecs_task_definition" "se-mobile-api" {
  task_definition = "${aws_ecs_task_definition.se-mobile-api.family}"
  depends_on      = ["aws_ecs_task_definition.se-mobile-api"]
}

resource "aws_ecs_task_definition" "se-mobile-api" {
  family = "${var.cluster}_se-mobile-api"

  # definitions could be in external JSON files or inline
  container_definitions = <<DEFINITION
[
  {
    "name": "se-mobile-api",
    "cpu": 128,
    "memory": 256,
    "memoryReservation": null,
    "portMappings": [
      {
        "hostPort": 8011,
        "protocol": "tcp",
        "containerPort": 8000
      }
    ],
    "essential": true,
    "image": "595075499860.dkr.ecr.us-east-1.amazonaws.com/schedule-engine/se-mobile-api:develop"
  }
]
DEFINITION
}

resource "aws_ecs_service" "se-mobile-api" {
  name          = "se-mobile-api"
  cluster       = "${var.cluster}"
  desired_count = 2

  # Track the latest ACTIVE revision
  task_definition = "${aws_ecs_task_definition.se-mobile-api.family}:${max("${aws_ecs_task_definition.se-mobile-api.revision}", "${data.aws_ecs_task_definition.se-mobile-api.revision}")}"

  load_balancer {
    target_group_arn = "${var.private_alb_target_group}"
    container_name   = "se-mobile-api"
    container_port   = "8000"
  }
}
