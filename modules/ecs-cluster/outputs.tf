// The cluster name, e.g se-app
output "name" {
  value = "${var.name}"
}

output "vpc_id" {
  value = "${var.vpc_id}"
}

// The cluster security group ID.
output "security_group_id" {
  value = "${aws_security_group.cluster.id}"
}

output "ecs_tasks_cloudwatch_log_group" {
  value = "${var.cloudwatch_prefix}/ecs/tasks"
}

# output "default_alb_target_group_arn" {
#   value = "${aws_alb_target_group.default.arn}"
# }

# output "internal_subnet_ids" {
#   value = "${module.network.internal_subnet_ids}"
# }
# output "external_subnet_ids" {
#   value = "${module.network.external_subnet_ids}"
# }

output "external_alb_arn" {
  value = "${module.external_alb.arn}"
}

output "external_alb_dns_name" {
  value = "${module.external_alb.dns_name}"
}

output "external_alb_security_group_id" {
  value = "${module.external_alb.security_group_id}"
}

output "default_external_alb_listener_arn" {
  value = "${module.external_alb_listener.arn}"
}

output "default_external_alb_target_group_arn" {
  value = "${module.external_alb_target_group.arn}"
}

output "internal_alb_arn" {
  value = "${module.internal_alb.arn}"
}

output "internal_alb_dns_name" {
  value = "${module.internal_alb.dns_name}"
}

output "internal_alb_security_group_id" {
  value = "${module.internal_alb.security_group_id}"
}

output "default_internal_alb_listener_arn" {
  value = "${module.internal_alb_listener.arn}"
}

output "default_internal_alb_target_group_arn" {
  value = "${module.internal_alb_target_group.arn}"
}
