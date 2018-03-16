output "alb_target_group_arn" {
  value = "${aws_target_group.main.arn}"
}
