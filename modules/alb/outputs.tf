output "arn" {
  value = "${aws_lb.main.arn}"
}

output "dns_name" {
  value = "${aws_lb.main.dns_name}"
}

output "zone_id" {
  value = "${aws_lb.main.zone_id}"
}

# output "alb_listener_arn" {
#   value = "${aws_alb_listener.http.arn}"
# }

# output "default_alb_target_group_arn" {
#   value = "${aws_alb_target_group.default.arn}"
# }

output "security_group_id" {
  value = "${aws_security_group.main.id}"
}
