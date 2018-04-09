/**
 * The bastion host acts as the "jump point" for the rest of the infrastructure.
 * Since most of our instances aren't exposed to the external internet, the bastion acts as the gatekeeper for any direct SSH access.
 * The bastion is provisioned using the key name that you pass to the stack (and hopefully have stored somewhere).
 * If you ever need to access an instance directly, you can do it by "jumping through" the bastion.
 *
 *    $ terraform output # print the bastion ip
 *    $ ssh -i <path/to/key> ubuntu@<bastion-ip> ssh ubuntu@<internal-ip>
 *
 * Usage:
 *
 *    module "bastion" {
 *      source            = "../bastion"
 *      region            = "us-west-2"
 *      security_groups   = "sg-1,sg-2"
 *      vpc_id            = "vpc-12"
 *      key_name          = "ssh-key"
 *      subnet_id         = "pub-1"
 *      environment       = "prod"
 *    }
 *
 */

module "ami" {
  source        = "github.com/terraform-community-modules/tf_aws_ubuntu_ami/ebs"
  region        = "${var.region}"
  distribution  = "trusty"
  instance_type = "${var.instance_type}"
}

resource "aws_instance" "bastion" {
  ami                    = "${module.ami.ami_id}"
  source_dest_check      = false
  instance_type          = "${var.instance_type}"
  subnet_id              = "${var.subnet_id}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${split(",",var.security_groups)}"]
  monitoring             = true
  user_data              = "${file(format("%s/templates/user_data.sh", path.module))}"

  tags {
    Name        = "${format("%s-bastion", var.cluster)}"
    Environment = "${var.environment}"
    Cluster     = "${var.cluster}"
  }
}

resource "aws_eip" "bastion" {
  depends_on = ["aws_instance.bastion"]
  instance   = "${aws_instance.bastion.id}"
  vpc        = true
}
