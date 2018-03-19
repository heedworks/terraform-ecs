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

  #   load_balancer {
  #     elb_name       = "${module.elb.id}"
  #     container_name = "${module.task.name}"
  #     container_port = "${var.container_port}"
  #   }

  lifecycle {
    create_before_destroy = true
  }
  # Track the latest ACTIVE revision
  task_definition = "${module.task.family}:${module.task.max_revision}"

  #   task_definition                    = "${module.task.arn}"

  load_balancer {
    target_group_arn = "${aws_lb_target_group.main.arn}"
    container_name   = "${module.task.name}"
    container_port   = "${var.container_port}"
  }
}

module "task" {
  source        = "../task"
  name          = "${var.name}"
  image         = "${var.image}"
  image_version = "${var.version}"
  command       = "${var.command}"
  env_vars      = "${var.env_vars}"
  memory        = "${var.memory}"
  cpu           = "${var.cpu}"

  ports = <<EOF
  [
    {
      "protocol": "tcp",
      "containerPort": ${var.container_port},
      "hostPort": ${var.port}
    }
  ]
EOF
}

# name = "${coalesce(var.name, replace(var.image, "/", "-"))}"

# module "elb" {
#   source = "../elb"

#   name            = "${module.task.name}"
#   port            = "${var.port}"
#   environment     = "${var.environment}"
#   subnet_ids      = "${var.subnet_ids}"
#   security_groups = "${var.security_groups}"
#   dns_name        = "${coalesce(var.dns_name, module.task.name)}"
#   healthcheck     = "${var.healthcheck}"
#   protocol        = "${var.protocol}"
#   zone_id         = "${var.zone_id}"
#   log_bucket      = "${var.log_bucket}"
# }

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
    Environment = "${var.environment}"
  }
}

resource "aws_lb_listener_rule" "main" {
  listener_arn = "${var.lb_listener_arn}"

  priority = "${var.port}"

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.main.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${coalesce(var.dns_name, module.task.name)}.*"]

    # values = ["se-mobile-api.internal"]
  }

  # listener_arn = "arn:aws:elasticloadbalancing:us-east-1:205210731340:listener/app/se-app-private/61d58b85637e36d1/1bc654dfce4b6de4"
}

resource "aws_route53_record" "main" {
  zone_id = "${var.zone_id}"
  name    = "${coalesce(var.dns_name, module.task.name)}"
  type    = "CNAME"
  ttl     = "5"

  #   weighted_routing_policy {
  #     weight = 10
  #   }

  #   set_identifier = "dev"
  records = ["${var.lb_listener_arn}"]
}

# resource "aws_ecs_service" "se-mobile-api" {
#   name          = "se-mobile-api"
#   cluster       = "${var.cluster}"
#   desired_count = 2


#   # Track the latest ACTIVE revision
#   task_definition = "${aws_ecs_task_definition.se-mobile-api.family}:${max("${aws_ecs_task_definition.se-mobile-api.revision}", "${data.aws_ecs_task_definition.se-mobile-api.revision}")}"


#   load_balancer {
#     target_group_arn = "${aws_lb_target_group.main.arn}"
#     container_name   = "${var.name}"
#     container_port   = "${var.container_port}"
#   }
# }

