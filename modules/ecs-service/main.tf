/**
 * The service module creates an ecs service, task definition, 
 * alb rules and a route53 record under the local service zone (see the dns module).
 *
 * Usage:
 *
 *      module "auth_service" {
 *        source    = "../ecs-service"
 *        name      = "auth-service"
 *        image     = "auth-service"
 *        cluster   = "default"
 *      }
 *
 */

data "aws_lb" "main" {
  arn = "${var.alb_arn}"
}

/**
 * Resources
 */

resource "aws_ecs_service" "main" {
  name                               = "${module.task.name}"
  cluster                            = "${var.cluster}"
  desired_count                      = "${var.desired_count}"
  iam_role                           = "${var.iam_role}"
  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"
  deployment_maximum_percent         = "${var.deployment_maximum_percent}"

  placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  lifecycle {
    create_before_destroy = true
  }

  # Track the latest ACTIVE revision
  task_definition = "${module.task.name}:${module.task.max_revision}"

  load_balancer {
    target_group_arn = "${aws_lb_target_group.main.arn}"
    container_name   = "${module.task.name}"
    container_port   = "${var.container_port}"
  }

  # "aws_lb_target_group.main",
  depends_on = [
    "aws_lb_listener_rule.main",
  ]
}

module "task" {
  source = "../ecs-task"

  name                  = "${var.name}"
  environment           = "${var.environment}"
  image                 = "${var.image}"
  image_tag             = "${coalesce(var.image_tag, var.aws_account_key)}"
  command               = "${var.command}"
  env_vars              = "${var.env_vars}"
  memory                = "${var.memory}"
  cpu                   = "${var.cpu}"
  awslogs_group         = "${var.awslogs_group}"
  awslogs_region        = "${var.awslogs_region}"
  awslogs_stream_prefix = "${var.awslogs_stream_prefix}"

  ports = <<EOF
  [
    {
      "protocol": "TCP",
      "containerPort": ${var.container_port},
      "hostPort": ${var.port}
    }
  ]
EOF
}

resource "aws_lb_target_group" "main" {
  name                 = "${module.task.name}"
  port                 = "${var.container_port}"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "${var.deregistration_delay}"

  health_check {
    path     = "${var.health_check_path}"
    protocol = "${var.health_check_protocol}"
    port     = "${var.health_check_port}"
  }

  tags {
    Cluster     = "${var.cluster}"
    Environment = "${var.environment}"
  }
}

resource "aws_lb_listener_rule" "main" {
  listener_arn = "${var.alb_listener_arn}"
  priority     = "${var.port}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.main.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${format("%s.%s", coalesce(var.dns_name, module.task.name), var.domain_name)}"]
  }

  depends_on = [
    "aws_lb_target_group.main",
  ]
}

resource "aws_route53_record" "main" {
  zone_id = "${var.zone_id}"
  name    = "${coalesce(var.dns_name, module.task.name)}"
  type    = "A"

  alias {
    name                   = "${data.aws_lb.main.dns_name}"
    zone_id                = "${data.aws_lb.main.zone_id}"
    evaluate_target_health = true
  }
}
