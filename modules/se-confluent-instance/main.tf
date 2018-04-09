variable "environment" {
  description = "The name of the environment"
}

variable "region" {
  default     = "us-east-1"
  description = "The name of the AWS region"
}

variable "cluster" {
  default     = "default"
  description = "The name of the ECS cluster"
}

variable "custom_userdata" {
  default     = ""
  description = "Inject extra command in the instance template to be run on boot"
}

variable "ecs_config" {
  default     = "echo '' > /etc/ecs/ecs.config"
  description = "Specify ecs configuration or get it from S3. Example: aws s3 cp s3://some-bucket/ecs.config /etc/ecs/ecs.config"
}

variable "ecs_logging" {
  default     = "[\"json-file\",\"awslogs\"]"
  description = "Adding logging option to ECS that the Docker containers can use. It is possible to add fluentd as well"
}

variable "ecs_instance_attributes" {
  default     = "{\\\"se-instance-type\\\": \\\"confluent\\\"}"
  description = "A list of custom attributes, in JSON form, to apply to your container instances."
}

variable "cloudwatch_prefix" {
  default     = ""
  description = "If you want to avoid cloudwatch collision or you don't want to merge all logs to one log group specify a prefix"
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  default     = 25
}

variable "docker_volume_size" {
  description = "Attached EBS volume size in GB"
  default     = 25
}

variable "key_name" {
  description = "SSH key name to be used"
}

variable "instance_type" {
  description = "AWS instance type to use"
}

variable "instance_ebs_optimized" {
  description = "When set to true the instance will be launched with EBS optimized turned on"
  default     = true
}

variable "security_groups" {
  description = "Comma separated list of security groups"
}

variable "ami" {
  description = "The AWS ami id to use for ECS"
}

variable "iam_instance_profile" {
  description = "The IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile."
}

variable "subnet_ids" {
  description = ""
  type        = "list"
}

variable "availability_zones" {
  description = ""
  type        = "list"
}

#-------------------------------------------------------------
#
#-------------------------------------------------------------
data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user_data.sh")}"

  vars {
    ecs_config              = "${var.ecs_config}"
    ecs_logging             = "${var.ecs_logging}"
    ecs_instance_attributes = "${var.ecs_instance_attributes}"
    cluster_name            = "${var.cluster}"
    env_name                = "${var.environment}"
    cloudwatch_prefix       = "${var.cloudwatch_prefix}"

    custom_userdata = <<EOF
    #############
    # EBS VOLUME
    #
    # note: /dev/sdh => /dev/xvdh
    # see: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/device_naming.html
    #############

    ############################################################
    # Attach and mount /dev/sdh to /zk-data
    ############################################################
    zk_data_state="unknown"
    until [ $zk_data_state == "attached" ]; do
        zk_data_state=$(aws ec2 describe-volumes \
            --region $region \
            --filters \
                Name=attachment.instance-id,Values=$instance_id \
                Name=attachment.device,Values=/dev/sdh \
            --query Volumes[].Attachments[].State \
            --output text)
        echo 'waiting for volume...'
        sleep 5
    done
    echo 'EBS volume /dev/sdh attached!'

    #
    # Format /dev/xvdh if it does not contain a partition yet
    #
    if [ "$(file -b -s /dev/xvdh)" == "data" ]; then
      mkfs -t ext4 /dev/xvdh
    fi

    mkdir -p /zk-data
    mount /dev/xvdh /zk-data

    #
    # Persist the volume in /etc/fstab so it gets mounted again
    #
    echo '/dev/xvdh /zk-data ext4 defaults,nofail 0 2' >> /etc/fstab

    ############################################################
    # Attach and mount /dev/sdi to /zk-txn-logs
    ############################################################
    zk_txn_logs_state="unknown"
    until [ $zk_txn_logs_state == "attached" ]; do
        zk_txn_logs_state=$(aws ec2 describe-volumes \
            --region $region \
            --filters \
                Name=attachment.instance-id,Values=$instance_id \
                Name=attachment.device,Values=/dev/sdi \
            --query Volumes[].Attachments[].State \
            --output text)
        echo 'waiting for volume...'
        sleep 5
    done
    echo 'EBS volume /dev/sdi attached!'

    #
    # Format /dev/xvdi if it does not contain a partition yet
    #
    if [ "$(file -b -s /dev/xvdi)" == "data" ]; then
      mkfs -t ext4 /dev/xvdi
    fi

    mkdir -p /zk-txn-logs
    mount /dev/xvdi /zk-txn-logs

    #
    # Persist the volume in /etc/fstab so it gets mounted again
    #
    echo '/dev/xvdi /zk-txn-logs ext4 defaults,nofail 0 2' >> /etc/fstab
    
    ############################################################
    # Attach and mount /dev/sdj to /kafka-logs
    ############################################################
    kafka_data="unknown"
    until [ $kafka_data == "attached" ]; do
        kafka_data=$(aws ec2 describe-volumes \
            --region $region \
            --filters \
                Name=attachment.instance-id,Values=$instance_id \
                Name=attachment.device,Values=/dev/sdj \
            --query Volumes[].Attachments[].State \
            --output text)
        echo 'waiting for volume...'
        sleep 5
    done
    echo 'EBS volume /dev/sdj attached!'

    #
    # Format /dev/xvdj if it does not contain a partition yet
    #
    if [ "$(file -b -s /dev/xvdj)" == "data" ]; then
      mkfs -t ext4 /dev/xvdj
    fi

    mkdir -p /kafka-logs
    mount /dev/xvdj /kafka-logs

    #
    # Persist the volume in /etc/fstab so it gets mounted again
    #
    echo '/dev/xvdj /kafka-data ext4 defaults,nofail 0 2' >> /etc/fstab
    EOF
  }
}

#-------------------------------------------------------------
# Confluent Instance 1
#-------------------------------------------------------------
resource "aws_ebs_volume" "zk_data_1" {
  availability_zone = "${element(var.availability_zones, 0)}"
  size              = 512
  type              = "st1"

  tags {
    Name        = "${format("%s-confluent-zk-data-1", var.cluster)}"
    Environment = "${var.environment}"
    Cluster     = "${var.cluster}"
  }
}

resource "aws_ebs_volume" "zk_txn_logs_1" {
  availability_zone = "${element(var.availability_zones, 0)}"
  size              = 512
  type              = "st1"

  tags {
    Name        = "${format("%s-confluent-zk-txn-logs-1", var.cluster)}"
    Environment = "${var.environment}"
    Cluster     = "${var.cluster}"
  }
}

resource "aws_ebs_volume" "kafka_data_1" {
  availability_zone = "${element(var.availability_zones, 0)}"
  size              = 512
  type              = "st1"

  tags {
    Name        = "${format("%s-confluent-kafka-data-1", var.cluster)}"
    Environment = "${var.environment}"
    Cluster     = "${var.cluster}"
  }
}

resource "aws_instance" "confluent_1" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${element(var.subnet_ids, 0)}"

  monitoring             = true
  vpc_security_group_ids = ["${split(",",var.security_groups)}"]
  iam_instance_profile   = "${var.iam_instance_profile}"
  key_name               = "${var.key_name}"
  user_data              = "${data.template_file.user_data.rendered}"

  # root
  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.root_volume_size}"
  }

  tags {
    Name        = "${format("%s-confluent-1", var.cluster)}"
    Environment = "${var.environment}"
    Cluster     = "${var.cluster}"
  }

  depends_on = ["aws_ebs_volume.zk_data_1", "aws_ebs_volume.zk_txn_logs_1", "aws_ebs_volume.kafka_data_1"]
}

resource "aws_volume_attachment" "ebs_att_zk_data_1" {
  device_name  = "/dev/sdh"
  volume_id    = "${aws_ebs_volume.zk_data_1.id}"
  instance_id  = "${aws_instance.confluent_1.id}"
  skip_destroy = true
}

resource "aws_volume_attachment" "ebs_att_zk_txn_logs_1" {
  device_name = "/dev/sdi"
  volume_id   = "${aws_ebs_volume.zk_txn_logs_1.id}"
  instance_id = "${aws_instance.confluent_1.id}"
}

resource "aws_volume_attachment" "ebs_att_kafka_data_1" {
  device_name = "/dev/sdj"
  volume_id   = "${aws_ebs_volume.kafka_data_1.id}"
  instance_id = "${aws_instance.confluent_1.id}"
}

#-------------------------------------------------------------
# Confluent Instance 2
#-------------------------------------------------------------
# resource "aws_ebs_volume" "zk_data_2" {
#   availability_zone = "us-east-1b"
#   size              = 512
#   type              = "st1"


#   tags {
#     Name        = "${format("%s-confluent-zk-data-2", var.cluster)}"
#     Environment = "${var.environment}"
#     Cluster     = "${var.cluster}"
#   }
# }


# resource "aws_instance" "confluent_2" {
#   ami           = "${var.ami}"
#   instance_type = "${var.instance_type}"


#   #   availability_zone = "${format("%sa", var.region)}"
#   #   subnet_id         = "subnet-35444f68"
#   subnet_id = "${element(var.subnet_ids, 1)}"


#   monitoring             = true
#   vpc_security_group_ids = ["${split(",",var.security_groups)}"]
#   iam_instance_profile   = "${var.iam_instance_profile}"
#   key_name               = "${var.key_name}"
#   user_data              = "${data.template_file.user_data.rendered}"


#   # root
#   root_block_device {
#     volume_type = "gp2"
#     volume_size = "${var.root_volume_size}"
#   }


#   tags {
#     Name        = "${format("%s-confluent-2", var.cluster)}"
#     Environment = "${var.environment}"
#     Cluster     = "${var.cluster}"
#   }
# }


# resource "aws_volume_attachment" "ebs_att_zk_data_2" {
#   device_name = "/dev/sdf"
#   volume_id   = "${aws_ebs_volume.zk_data_2.id}"
#   instance_id = "${aws_instance.confluent_2.id}"
# }

