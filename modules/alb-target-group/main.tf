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
    matcher  = "${var.health_check_matcher}"
  }

  tags {
    Environment = "${var.environment}"
  }
}
