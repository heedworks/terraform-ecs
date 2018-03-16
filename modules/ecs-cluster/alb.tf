module "alb" {
  source = "../alb"

  internal    = false
  environment = "${var.environment}"
  alb_name    = "${var.name}"
  vpc_id      = "${var.vpc_id}"
  subnet_ids  = "${var.external_subnet_ids}"
}

resource "aws_security_group_rule" "alb_to_ecs" {
  type = "ingress"

  # from_port                = 32768
  # to_port                  = 61000

  from_port                = 8000
  to_port                  = 9999
  protocol                 = "TCP"
  source_security_group_id = "${module.alb.alb_security_group_id}"
  security_group_id        = "${module.ecs_instances.ecs_instance_security_group_id}"
}

# resource "aws_alb_target_group" "default" {
#   name                 = "${var.cluster}-default"
#   port                 = "80"
#   protocol             = "HTTP"
#   vpc_id               = "${module.network.vpc_id}"
#   deregistration_delay = "${var.alb_deregistration_delay}"


#   health_check {
#     path     = "${var.alb_health_check_path}"
#     protocol = "${var.alb_health_check_protocol}"
#     port     = "${var.alb_health_check_port}"
#   }


#   tags {
#     Environment = "${var.environment}"
#   }
# }


# resource "aws_alb_listener" "https" {
#   load_balancer_arn = "${module.alb.alb_arn}"
#   port              = "80"
#   protocol          = "HTTP"


#   default_action {
#     target_group_arn = "${aws_alb_target_group.default.id}"
#     type             = "forward"
#   }
# }


# module "alb_private" {
#   source = "../alb_private"


#   environment = "${var.environment}"
#   alb_name    = "${var.cluster}-private"
#   vpc_id      = "${module.network.vpc_id}"
#   subnet_ids  = "${module.network.private_subnet_ids}"
# }


# resource "aws_security_group_rule" "alb_private_to_ecs" {
#   type = "ingress"


#   # from_port                = 32768
#   # to_port                  = 61000


#   from_port                = 8001
#   to_port                  = 9999
#   protocol                 = "TCP"
#   source_security_group_id = "${module.alb_private.alb_security_group_id}"
#   security_group_id        = "${module.ecs_instances.ecs_instance_security_group_id}"
# }

