# output "default_alb_target_group" {
#   value = "${module.ecs.default_alb_target_group}"
# }
# output "default_alb_target_group_2" {
#   value = ":))"
# }

// The region in which the infrastructure lives.
output "region" {
  value = "${var.region}"
}

// The bastion host IP.
output "bastion_ip" {
  value = "${module.bastion.external_ip}"
}

# output "" {
#   value = "${}"
# }

output "vpc_id" {
  value = "${module.network.vpc_id}"
}

// The internal route53 zone ID.
output "zone_id" {
  value = "${module.dns.zone_id}"
}

output "internal_subnet_ids" {
  value = "${module.network.internal_subnet_ids}"
}

output "external_subnet_ids" {
  value = "${module.network.external_subnet_ids}"
}

output "ecs_cluster_security_group_id" {
  value = "${module.ecs_cluster.security_group_id}"
}

output "external_ssh_security_group_id" {
  value = "${module.security_groups.external_ssh}"
}

output "internal_ssh_security_group_id" {
  value = "${module.security_groups.internal_ssh}"
}

output "external_alb_security_group_id" {
  value = "${module.security_groups.external_alb}"
}

output "internal_alb_security_group_id" {
  value = "${module.security_groups.internal_alb}"
}

output "cluster" {
  value = "${module.ecs_cluster.name}"
}

output "awslogs_group" {
  value = "${module.ecs_cluster.ecs_tasks_cloudwatch_log_group}"
}

output "internal_alb_arn" {
  value = "${module.ecs_cluster.internal_alb_arn}"
}

output "internal_alb_target_group_arn" {
  value = "${module.ecs_cluster.default_internal_alb_target_group_arn}"
}

output "internal_alb_listener_arn" {
  value = "${module.ecs_cluster.default_internal_alb_listener_arn}"
}

output "external_alb_arn" {
  value = "${module.ecs_cluster.internal_alb_arn}"
}

output "external_alb_target_group_arn" {
  value = "${module.ecs_cluster.default_external_alb_target_group_arn}"
}

output "external_alb_listener_arn" {
  value = "${module.ecs_cluster.default_external_alb_listener_arn}"
}

output "external_alb_dns_name" {
  value = "${module.ecs_cluster.external_alb_dns_name}"
}
