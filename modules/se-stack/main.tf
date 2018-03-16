module "defaults" {
  source = "../defaults"
  region = "${var.region}"
  cidr   = "${var.vpc_cidr}"
}

module "network" {
  source             = "../network"
  environment        = "${var.environment}"
  vpc_cidr           = "${var.vpc_cidr}"
  external_subnets   = "${var.external_subnets}"
  internal_subnets   = "${var.internal_subnets}"
  availability_zones = "${var.availability_zones}"
  depends_id         = ""
}

module "security_groups" {
  source      = "../security-groups"
  name        = "${var.name}"
  vpc_id      = "${module.network.vpc_id}"
  environment = "${var.environment}"
  cidr        = "${var.vpc_cidr}"
}

module "bastion" {
  source          = "../bastion"
  region          = "${var.region}"
  instance_type   = "${var.bastion_instance_type}"
  subnet_id       = "${element(module.network.external_subnet_ids, 0)}"
  security_groups = "${module.security_groups.external_ssh},${module.security_groups.internal_ssh}"
  vpc_id          = "${module.network.vpc_id}"
  key_name        = "${var.key_name}"
  environment     = "${var.environment}"
  cluster         = "${var.name}"

  # subnet_id       = "${element(module.vpc.external_subnets, 0)}"
  # instance_type   = "${var.bastion_instance_type}"
  # security_groups = "${module.security_groups.external_ssh},${module.security_groups.internal_ssh}"
}

module "dhcp" {
  source = "../dhcp"
  name   = "${module.dns.name}"

  # vpc_id  = "${module.vpc.id}"
  vpc_id = "${module.network.vpc_id}"

  # servers = "${coalesce(var.domain_name_servers, module.defaults.domain_name_servers)}"
  servers = "${cidrhost(var.vpc_cidr, 2)}"
}

module "dns" {
  source = "../dns"

  name = "${var.internal_domain_name}"

  # name   = "internal"
  vpc_id = "${module.network.vpc_id}"
}

module "ecs" {
  source = "../../modules/ecs-cluster"

  region      = "${var.region}"
  environment = "${var.environment}"

  # cluster            = "${var.ecs_cluster_name}"
  name = "${coalesce(var.ecs_cluster_name, var.name)}"

  cloudwatch_prefix = "${var.environment}" # See ecs-instances module when to set this and when not!
  vpc_cidr          = "${var.vpc_cidr}"

  # external_subnets   = "${var.external_subnets}"
  # internal_subnets   = "${var.internal_subnets}"
  # availability_zones = "${var.availability_zones}"

  max_size         = "${var.ecs_max_size}"
  min_size         = "${var.ecs_min_size}"
  desired_capacity = "${var.ecs_desired_capacity}"
  key_name         = "${aws_key_pair.ecs.key_name}"
  instance_type    = "${var.ecs_instance_type}"
  image_id         = "${coalesce(var.ecs_ami, module.defaults.ecs_ami)}"
  # new variables
  vpc_id              = "${module.network.vpc_id}"
  depends_id          = "${module.network.depends_id}"
  internal_subnet_ids = "${module.network.internal_subnet_ids}"
  external_subnet_ids = "${module.network.internal_subnet_ids}"
}

resource "aws_key_pair" "ecs" {
  key_name   = "${var.key_name}"
  public_key = "${file(format("%s/../../ssh-keys/se-%s-account.key.pub", path.module, var.aws_account_key))}"

  # public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDLbxjBtIjSLo7KQx24Ym/CGVl5FJyA2KbeL5WzMK58Zy6a5n0RbKEcr0HvdzdEHyG84sx7rkZdKryBQmFr4ov0tJ8UbXQ1SsHaRAE1KnJf3mHrBvNHHUF3yMFE5WGS7fT/iyEPqpVKJgyBRBKYAyoOcQmzAYA7ZE13cbrwqq9tYT+/lnmhr3/2IbISDnkkMwCjyp3WTXTmuKsLGtLGDnajExkZmj6EmekxTRW99ISVwm+k+oHzXx+FdMuyy/zkD8U6mQoB4+WK0HDEErol11puB4AWMH7FZlju893ao/LBg+XPz5g+JwrafQEUKy1jTHfosTgsRIYmIjRKW7hmFeL/9woca3in4osDZZ4VVvDfq+oiBhOVNlIC9N3bAU3ZiYZwu74LpF1K971r/8c9qIm8d7aXqZWl134Kc7zi4FRL5a6BqOWtGeR91GcXvJIqaTPa+TpgGsl0oT0Kugjzj/FoTVJe8l9GZJ/1HSYVB6/O0Ja584erdkEwyAM46t/y0YQgCtlc0KKBiN5TilbY7NToyouulNCvA9lIJVDdrLZF6LxXrPsvA4h4ow1TaA2QpgOcgF1XPdmuN8dUQ3KYL3ssw0DL56QF2dkDpDYHfyJQlBHyWpDwvX3EYYvZZq4V2BvXBKBMmplWx84UHfb5ulEXYdn/qq2Dl3rnMtqbkDX+Qw== ecs-key-staging"
}
