# output "default_alb_target_group_arn" {
#   value = "${aws_alb_target_group.default.arn}"
# }

output "vpc_id" {
  value = "${module.network.vpc_id}"
}

output "internal_subnet_ids" {
  value = "${module.network.internal_subnet_ids}"
}

output "external_subnet_ids" {
  value = "${module.network.external_subnet_ids}"
}
