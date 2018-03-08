# Private ALB implementation that can be used connect ECS instances to it
# Public LB for routing incoming external traffic; kong would us this target_group

resource "aws_alb_target_group" "private" {
  name                 = "${var.alb_name}-private"
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

resource "aws_alb" "alb" {
  name            = "${var.alb_name}"
  internal        = true
  subnets         = ["${var.public_subnet_ids}"]
  security_groups = ["${aws_security_group.alb.id}"]

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = "${aws_alb.alb.id}"
  port              = "8000"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.private.id}"
    type             = "forward"
  }
}

resource "aws_security_group" "alb" {
  name   = "${var.alb_name}-alb"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "http_from_anywhere" {
  type      = "ingress"
  from_port = 8000
  to_port   = 8000
  protocol  = "TCP"

  # cidr_blocks       = ["${var.allow_cidr_block}"]
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = "${aws_security_group.alb.id}"
}

resource "aws_security_group_rule" "outbound_internet_access" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.alb.id}"
}
