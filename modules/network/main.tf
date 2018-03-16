module "vpc" {
  source = "../vpc"

  cidr        = "${var.vpc_cidr}"
  environment = "${var.environment}"
}

module "internal_subnet" {
  source = "../subnet"

  name               = "${var.environment}-internal-subnet"
  environment        = "${var.environment}"
  vpc_id             = "${module.vpc.id}"
  cidrs              = "${var.internal_subnets}"
  availability_zones = "${var.availability_zones}"
}

module "external_subnet" {
  source = "../subnet"

  name               = "${var.environment}-external-subnet"
  environment        = "${var.environment}"
  vpc_id             = "${module.vpc.id}"
  cidrs              = "${var.external_subnets}"
  availability_zones = "${var.availability_zones}"
}

module "nat" {
  source = "../nat-gateway"

  subnet_ids   = "${module.external_subnet.ids}"
  subnet_count = "${length(var.external_subnets)}"
}

resource "aws_route" "external_igw_route" {
  count                  = "${length(var.external_subnets)}"
  route_table_id         = "${element(module.external_subnet.route_table_ids, count.index)}"
  gateway_id             = "${module.vpc.igw}"
  destination_cidr_block = "${var.destination_cidr_block}"
}

resource "aws_route" "internal_nat_route" {
  count                  = "${length(var.internal_subnets)}"
  route_table_id         = "${element(module.internal_subnet.route_table_ids, count.index)}"
  nat_gateway_id         = "${element(module.nat.ids, count.index)}"
  destination_cidr_block = "${var.destination_cidr_block}"
}

# Creating a NAT Gateway takes some time. Some services need the internet (NAT Gateway) before proceeding. 
# Therefore we need a way to depend on the NAT Gateway in Terraform and wait until is finished. 
# Currently Terraform does not allow module dependency to wait on.
# Therefore we use a workaround described here: https://github.com/hashicorp/terraform/issues/1178#issuecomment-207369534

resource "null_resource" "dummy_dependency" {
  depends_on = ["module.nat"]
}
