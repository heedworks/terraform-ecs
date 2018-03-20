output "alb_arn" {
  value = "${aws_alb.main.arn}"
}

output "alb_dns_name" {
  value = "${aws_alb.main.dns_name}"
}

output "alb_zone_id" {
  value = "${aws_alb.main.zone_id}"
}

output "alb_listener_arn" {
  value = "${aws_alb_listener.http.arn}"
}

output "default_alb_target_group_arn" {
  value = "${aws_alb_target_group.default.arn}"
}

output "alb_security_group_id" {
  value = "${aws_security_group.main.id}"
}
