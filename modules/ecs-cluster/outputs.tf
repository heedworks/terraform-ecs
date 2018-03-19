// The cluster name, e.g se-app
output "name" {
  value = "${var.name}"
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
# output "vpc_id" {
#   value = "${module.network.vpc_id}"
# }
# output "internal_subnet_ids" {
#   value = "${module.network.internal_subnet_ids}"
# }
# output "external_subnet_ids" {
#   value = "${module.network.external_subnet_ids}"
# }

