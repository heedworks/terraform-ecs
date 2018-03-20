resource "aws_lb" "main" {
  name               = "${var.name}"
  internal           = "${var.internal}"
  subnets            = ["${var.subnet_ids}"]
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.main.id}"]

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "main" {
  name   = "${var.name}-alb"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}
