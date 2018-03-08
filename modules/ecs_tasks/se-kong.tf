data "aws_ecs_task_definition" "main" {
  task_definition = "${aws_ecs_task_definition.main.family}"
  depends_on      = ["aws_ecs_task_definition.main"]
}

resource "aws_ecs_task_definition" "main" {
  family = "${var.cluster}_se-kong"

  # definitions could be in external JSON files or inline
  # container_definitions = "${file("${path.module}/definitions/se-kong.json")}"
  # definitions could be in external JSON files or inline
  container_definitions = <<DEFINITION
[
  {
    "name": "se-kong",
    "cpu": 128,
    "memory": 256,
    "memoryReservation": null,
    "portMappings": [
      {
        "hostPort": 8021,
        "protocol": "tcp",
        "containerPort": 8000
      }
    ],
    "essential": true,
    "image": "595075499860.dkr.ecr.us-east-1.amazonaws.com/schedule-engine/se-kong:d6a56c9f86f05ee167fa78eca7d19b44135728b7_36"
  }
]
DEFINITION
}

resource "aws_ecs_service" "main" {
  name          = "se-kong"
  cluster       = "${var.cluster}"
  desired_count = 2

  # Track the latest ACTIVE revision
  task_definition = "${aws_ecs_task_definition.main.family}:${max("${aws_ecs_task_definition.main.revision}", "${data.aws_ecs_task_definition.main.revision}")}"

  load_balancer {
    target_group_arn = "${var.default_alb_target_group}"
    container_name   = "se-kong"
    container_port   = "8000"
  }
}
