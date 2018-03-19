module "defaults" {
  source = "../defaults"
  region = "${var.region}"
  cidr   = "${var.vpc_cidr}"
}

module "network" {
  source             = "../network"
  name               = "${var.name}"
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
  source  = "../dhcp"
  name    = "${module.dns.name}"
  vpc_id  = "${module.network.vpc_id}"
  servers = "${module.defaults.domain_name_servers}"

  # servers = "${coalesce(var.domain_name_servers, module.defaults.domain_name_servers)}"
  # servers = "${cidrhost(var.vpc_cidr, 2)}"
}

module "dns" {
  source = "../dns"
  name   = "${var.internal_domain_name}"
  vpc_id = "${module.network.vpc_id}"
}

module "ecs_cluster" {
  source = "../ecs-cluster"

  region      = "${var.region}"
  environment = "${var.environment}"

  # cluster            = "${var.ecs_cluster_name}"
  name            = "${coalesce(var.ecs_cluster_name, var.name)}"
  security_groups = "${module.security_groups.internal_ssh},${module.security_groups.internal_alb},${module.security_groups.external_alb}"

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
  external_subnet_ids = "${module.network.external_subnet_ids}"
}

resource "aws_key_pair" "ecs" {
  key_name   = "${var.key_name}"
  public_key = "${file(format("%s/../../ssh-keys/se-%s-account.key.pub", path.module, var.aws_account_key))}"
}

module "se_kong" {
  source                           = "../se-kong"
  cluster                          = "${module.ecs_cluster.name}"
  environment                      = "${var.environment}"
  region                           = "${var.region}"
  vpc_id                           = "${module.network.vpc_id}"
  db_subnet_ids                    = "${module.network.internal_subnet_ids}"
  db_ingress_allow_security_groups = ["${module.ecs_cluster.security_group_id}"]
  ecr_domain                       = "${module.defaults.ecr_domain}"
  awslogs_group                    = "${module.ecs_cluster.ecs_tasks_cloudwatch_log_group}"
  configuration_version            = "integration"
}
