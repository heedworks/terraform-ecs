data "aws_ecs_task_definition" "se-kong-configuration" {
  task_definition = "${aws_ecs_task_definition.se-kong-configuration.family}"
  depends_on      = ["aws_ecs_task_definition.se-kong-configuration"]
}

resource "aws_ecs_task_definition" "se-kong-configuration" {
  family = "se-kong-configuration"

  # definitions could be in external JSON files or inline
  # container_definitions = "${file("${path.module}/definitions/se-kong.json")}"
  # definitions could be in external JSON files or inline
  # "image": "595075499860.dkr.ecr.us-east-1.amazonaws.com/schedule-engine/se-kong:d6a56c9f86f05ee167fa78eca7d19b44135728b7_36"
  container_definitions = <<DEFINITION
[
  {
    "name": "se-kong-configuration",
    "cpu": 128,
    "memory": 256,
    "memoryReservation": null,
    "portMappings": [],
    "essential": true,
    "image": "302058597523.dkr.ecr.us-east-1.amazonaws.com/schedule-engine/se-kong-configuration:develop",
    "environment": [
      { "name": "NODE_ENV", "value": "integration" }, 
      { "name": "AWS_ACCOUNT_KEY", "value": "integration" },
      { "name": "KONG_PG_CONNECTION_STRING", "value": "postgres://se_admin@7dxvs>)Dmtc2nnc@se-postgres.c7l754p6gzdi.us-east-1.rds.amazonaws.com:5432/se_kong" }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${var.environment}/ecs/tasks",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "se-app"
      }
    }
  }
]
DEFINITION
}

resource "aws_ecs_service" "se-kong-configuration" {
  name          = "se-kong-configuration"
  cluster       = "${var.cluster}"
  desired_count = 1

  # Track the latest ACTIVE revision
  task_definition = "${aws_ecs_task_definition.se-kong-configuration.family}:${max("${aws_ecs_task_definition.se-kong-configuration.revision}", "${data.aws_ecs_task_definition.se-kong-configuration.revision}")}"

  # load_balancer {
  #   target_group_arn = "${var.default_alb_target_group}"
  #   container_name   = "se-kong-configuration"
  #   container_port   = "8000"
  # }
}
