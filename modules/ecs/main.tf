module "network" {
  source               = "../network"
  environment          = "${var.environment}"
  vpc_cidr             = "${var.vpc_cidr}"
  public_subnet_cidrs  = "${var.public_subnet_cidrs}"
  private_subnet_cidrs = "${var.private_subnet_cidrs}"
  availability_zones   = "${var.availability_zones}"
  depends_id           = ""
}

module "ecs_instances" {
  source = "../ecs-instances"

  environment             = "${var.environment}"
  cluster                 = "${var.cluster}"
  instance_group          = "${var.instance_group}"
  private_subnet_ids      = "${module.network.private_subnet_ids}"
  aws_ami                 = "${var.ecs_aws_ami}"
  instance_type           = "${var.instance_type}"
  max_size                = "${var.max_size}"
  min_size                = "${var.min_size}"
  desired_capacity        = "${var.desired_capacity}"
  vpc_id                  = "${module.network.vpc_id}"
  iam_instance_profile_id = "${aws_iam_instance_profile.ecs.id}"
  key_name                = "${var.key_name}"
  load_balancers          = "${var.load_balancers}"
  depends_id              = "${module.network.depends_id}"
  custom_userdata         = "${var.custom_userdata}"
  cloudwatch_prefix       = "${var.cloudwatch_prefix}"

  private_ssh_security_group = "${aws_security_group.private_ssh.id}"
  public_ssh_security_group  = "${aws_security_group.public_ssh.id}"
  vpc_cidr                   = "${var.vpc_cidr}"
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.cluster}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "ecs-tasks-cloudwatch" {
  name              = "${var.cloudwatch_prefix}/ecs/tasks"
  retention_in_days = 30
}

module "ecs_tasks" {
  source = "../ecs-tasks"

  vpc_id                   = "${module.network.vpc_id}"
  cluster                  = "${var.cluster}"
  environment              = "${var.environment}"
  default_alb_target_group = "${aws_alb_target_group.default.arn}"
  private_alb_target_group = "${module.alb_private.private_alb_target_group}"
}

# bastion
resource "aws_security_group" "public_ssh" {
  name        = "${format("%s-%s-public-ssh", var.environment, var.cluster)}"
  description = "Allows ssh from the world"
  vpc_id      = "${module.network.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "${format("%s-%s public ssh", var.environment, var.cluster)}"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "private_ssh" {
  name        = "${format("%s-%s-private-ssh", var.environment, var.cluster)}"
  description = "Allows ssh from bastion"
  vpc_id      = "${module.network.vpc_id}"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.public_ssh.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]

    # cidr_blocks = ["${var.cidr}"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name        = "${format("%s-%s private ssh", var.environment, var.cluster)}"
    Environment = "${var.environment}"
  }
}

module "bastion" {
  source          = "../bastion"
  region          = "${var.region}"
  instance_type   = "t2.micro"
  subnet_id       = "${element(module.network.public_subnet_ids, 0)}"
  security_groups = "${aws_security_group.public_ssh.id},${aws_security_group.private_ssh.id}"
  vpc_id          = "${module.network.vpc_id}"
  key_name        = "${var.key_name}"
  environment     = "${var.environment}"
  cluster         = "${var.cluster}"

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

  # name   = "${var.domain_name}"
  name = "internal"

  # vpc_id = "${module.vpc.id}"
  vpc_id = "${module.network.vpc_id}"
}
