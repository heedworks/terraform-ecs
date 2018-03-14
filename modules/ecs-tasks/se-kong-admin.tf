data "aws_ecs_task_definition" "se-kong-admin" {
  task_definition = "${aws_ecs_task_definition.se-kong-admin.family}"
  depends_on      = ["aws_ecs_task_definition.se-kong-admin"]
}

resource "aws_ecs_task_definition" "se-kong-admin" {
  family = "se-kong-admin"

  # definitions could be in external JSON files or inline
  # container_definitions = "${file("${path.module}/definitions/se-kong.json")}"
  # definitions could be in external JSON files or inline
  # "image": "595075499860.dkr.ecr.us-east-1.amazonaws.com/schedule-engine/se-kong:d6a56c9f86f05ee167fa78eca7d19b44135728b7_36"
  container_definitions = <<DEFINITION
[
  {
    "name": "se-kong-admin",
    "cpu": 128,
    "memory": 256,
    "memoryReservation": null,
    "portMappings": [
      {
        "hostPort": 8022,
        "protocol": "tcp",
        "containerPort": 8000
      }
    ],
    "essential": true,
    "image": "302058597523.dkr.ecr.us-east-1.amazonaws.com/schedule-engine/se-kong:develop",
    "environment": [
      { "name": "KONG_DATABASE", "value": "postgres" }, 
      { "name": "KONG_PG_HOST", "value": "se-postgres.c7l754p6gzdi.us-east-1.rds.amazonaws.com" },
      { "name": "KONG_PG_DATABASE", "value": "se_kong" },
      { "name": "KONG_PG_USER", "value": "se_admin" },
      { "name": "KONG_PG_PASSWORD", "value": "7dxvs>)Dmtc2nnc" }
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

resource "aws_alb_target_group" "se-kong-admin" {
  name                 = "se-kong-admin"
  port                 = "8000"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "${var.deregistration_delay}"

  health_check {
    path     = "${var.health_check_path}"
    protocol = "${var.health_check_protocol}"
    port     = "${var.health_check_port}"
  }

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_lb_listener_rule" "se-kong-admin" {
  listener_arn = "arn:aws:elasticloadbalancing:us-east-1:205210731340:listener/app/se-app-private/61d58b85637e36d1/1bc654dfce4b6de4"
  priority     = 8022

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.se-kong-admin.arn}"
  }

  condition {
    field  = "host-header"
    values = ["se-mobile-api.stack.local"]
  }
}

resource "aws_ecs_service" "se-kong-admin" {
  name          = "se-kong-admin"
  cluster       = "${var.cluster}"
  desired_count = 2

  # Track the latest ACTIVE revision
  task_definition = "${aws_ecs_task_definition.se-kong-admin.family}:${max("${aws_ecs_task_definition.se-kong-admin.revision}", "${data.aws_ecs_task_definition.se-kong-admin.revision}")}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.se-kong-admin.arn}"
    container_name   = "se-kong-admin"
    container_port   = "8000"
  }
}
