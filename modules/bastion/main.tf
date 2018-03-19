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
 *      source            = "github.com/segmentio/stack/bastion"
 *      region            = "us-west-2"
 *      security_groups   = "sg-1,sg-2"
 *      vpc_id            = "vpc-12"
 *      key_name          = "ssh-key"
 *      subnet_id         = "pub-1"
 *      environment       = "prod"
 *    }
 *
 */

variable "long_key" {
  type = "string"

  default = <<EOF
-----BEGIN RSA PRIVATE KEY-----
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
-----END RSA PRIVATE KEY-----
EOF
}

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

resource "null_resource" "provision-bastion-files" {
  depends_on = ["aws_eip.bastion"]

  connection {
    type    = "ssh"
    host    = "${aws_eip.bastion.public_ip}"
    port    = 22
    user    = "ubuntu"
    agent   = false
    timeout = "3m"

    # private_key = "${file("~/.ssh/ecs-key-staging.key")}"
    # private_key = "${var.long_key}"  
    # private_key = "${file(format("%s/../../ssh-keys/se-%s-account.key.pub", path.module, var.aws_account_key))}"
    private_key = "${var.private_key}"
  }

  provisioner "file" {
    # source      = "${format("../../env/global/keys/%s.key", var.key_name)}"  # content     = "${var.long_key}"

    content     = "${var.private_key}"
    destination = "/home/ubuntu/.ssh/ecs-key.pem"
  }

  # provisioner "file" {
  #   content     = ":))"
  #   destination = "/home/ubuntu/hello.txt"
  # }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 /home/ubuntu/.ssh/ecs-key.pem",
    ]
  }
}
