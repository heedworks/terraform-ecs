resource "aws_lb_target_group" "main" {
  name                 = "${var.name}"
  port                 = "${var.port}"
  protocol             = "${var.protocol}"
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

# resource "aws_alb_target_group" "main" {
#   name                 = "${var.alb_name}-default"
#   port                 = "${coalesce(var.target_group_port, var.port)}"
#   protocol             = "HTTP"
#   vpc_id               = "${var.vpc_id}"
#   deregistration_delay = "${var.deregistration_delay}"


#   # port                 = "80"


#   health_check {
#     path     = "${var.health_check_path}"
#     protocol = "${var.health_check_protocol}"
#     port     = "${var.health_check_port}"
#   }
#   tags {
#     Environment = "${var.environment}"
#   }
# }

