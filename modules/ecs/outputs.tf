output "default_alb_target_group" {
  value = "${aws_alb_target_group.default.arn}"
}
