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
