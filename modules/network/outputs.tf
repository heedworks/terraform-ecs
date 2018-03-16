output "vpc_id" {
  value = "${module.vpc.id}"
}

output "vpc_cidr" {
  value = "${module.vpc.cidr_block}"
}

output "internal_subnet_ids" {
  value = "${module.internal_subnet.ids}"
}

output "external_subnet_ids" {
  value = "${module.external_subnet.ids}"
}

output "depends_id" {
  value = "${null_resource.dummy_dependency.id}"
}
