data "aws_ecs_task_definition" "se-client-service" {
  task_definition = "${aws_ecs_task_definition.se-client-service.family}"
  depends_on      = ["aws_ecs_task_definition.se-client-service"]
}

resource "aws_ecs_task_definition" "se-client-service" {
  family = "se-client-service"

  # definitions could be in external JSON files or inline
  container_definitions = <<EOF
[
  {
    "name": "se-client-service",
    "cpu": 128,
    "memory": 256,
    "memoryReservation": null,
    "portMappings": [
      {
        "hostPort": 8006,
        "protocol": "tcp",
        "containerPort": 8000
      }
    ],
    "essential": true,
    "image": "302058597523.dkr.ecr.us-east-1.amazonaws.com/schedule-engine/se-client-service:develop",
    "environment": [
      { "name": "NODE_ENV", "value": "integration" }, 
      { "name": "AWS_ACCOUNT_KEY", "value": "integration" },
      { "name": "MONGO_CONNECTION_STRING", "value": "" }
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
EOF
}

resource "aws_alb_target_group" "se-client-service" {
  name                 = "se-client-service"
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

resource "aws_lb_listener_rule" "se-client-service" {
  listener_arn = "arn:aws:elasticloadbalancing:us-east-1:205210731340:listener/app/se-app-private/61d58b85637e36d1/1bc654dfce4b6de4"
  priority     = 8006

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.se-client-service.arn}"
  }

  condition {
    field  = "host-header"
    values = ["se-mobile-api.internal"]
  }
}

resource "aws_ecs_service" "se-client-service" {
  name          = "se-client-service"
  cluster       = "${var.cluster}"
  desired_count = 2

  # Track the latest ACTIVE revision
  task_definition = "${aws_ecs_task_definition.se-client-service.family}:${max("${aws_ecs_task_definition.se-client-service.revision}", "${data.aws_ecs_task_definition.se-client-service.revision}")}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.se-client-service.arn}"
    container_name   = "se-client-service"
    container_port   = "8000"
  }
}
