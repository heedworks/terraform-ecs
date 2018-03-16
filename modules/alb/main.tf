# Default ALB implementation that can be used connect ECS instances to it
# Public LB for routing incoming external traffic; kong would us this target_group

resource "aws_alb" "main" {
  name            = "${var.alb_name}"
  internal        = "${var.internal}"
  subnets         = ["${var.subnet_ids}"]
  security_groups = ["${aws_security_group.main.arn}"]

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = "${aws_alb.main.id}"
  port              = "${var.port}"
  protocol          = "HTTP"

  # port              = "80"

  default_action {
    target_group_arn = "${aws_alb_target_group.default.arn}"
    type             = "forward"
  }
}

resource "aws_alb_target_group" "default" {
  name                 = "${var.alb_name}-default"
  port                 = "${coalesce(var.target_group_port, var.port)}"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "${var.deregistration_delay}"

  # port                 = "80"

  health_check {
    path     = "${var.health_check_path}"
    protocol = "${var.health_check_protocol}"
    port     = "${var.health_check_port}"
  }
  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "main" {
  name   = "${var.alb_name}-alb"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "http_from_anywhere" {
  type              = "ingress"
  from_port         = "${var.port}"
  to_port           = "${var.port}"
  protocol          = "TCP"
  cidr_blocks       = ["${var.allow_cidr_block}"]
  security_group_id = "${aws_security_group.main.id}"
}

resource "aws_security_group_rule" "outbound_internet_access" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.main.id}"
}
