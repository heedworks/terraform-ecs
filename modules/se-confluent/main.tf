# NOTE: NEED TO MOUNT EBS VOLUMES FROM DOCKER

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

variable "zone_id" {
  description = ""
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
  default     = "{\"se-instance-type\": \"confluent\"}"
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

variable "deployment_minimum_healthy_percent" {
  description = "lower limit (% of desired_count) of # of running tasks during a deployment"
  default     = 100
}

variable "deployment_maximum_percent" {
  description = "upper limit (% of desired_count) of # of running tasks during a deployment"
  default     = 200
}

variable "awslogs_group" {
  description = "The awslogs group. defaults to var.environment/ecs/tasks"
  default     = ""
}

variable "awslogs_region" {
  description = "The awslogs group. defaults to var.region"
  default     = ""
}

variable "awslogs_stream_prefix" {
  description = "The awslogs stream prefix. defaults to var.cluster"
  default     = ""
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

    # custom_userdata         = "${var.custom_userdata}"

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

    #
    # Restart docker
    #
    service docker restart
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

resource "aws_route53_record" "zookeeper" {
  zone_id = "${var.zone_id}"
  name    = "se-zookeeper-1"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.confluent_1.private_ip}"]
}

resource "aws_route53_record" "kafka" {
  zone_id = "${var.zone_id}"
  name    = "se-kafka-1"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.confluent_1.private_ip}"]
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
# Confluent Kafka Service
#-------------------------------------------------------------

# -----------------------------------------------------------------------------
# ECS service for se-zookeeper
# -----------------------------------------------------------------------------

resource "aws_ecs_service" "zookeeper" {
  name    = "se-zookeeper-1"
  cluster = "${var.cluster}"

  # iam_role = "${var.iam_role}"

  desired_count                      = "1"
  deployment_minimum_healthy_percent = "0"
  deployment_maximum_percent         = "100"
  placement_constraints {
    type       = "memberOf"
    expression = "attribute:se-instance-type == confluent"
  }
  placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }
  placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
  lifecycle {
    create_before_destroy = true
  }
  # Track the latest ACTIVE revision
  task_definition = "${module.zookeeper_task.name}:${module.zookeeper_task.max_revision}"
}

# -----------------------------------------------------------------------------
# ECS task for se-zookeeper
# -----------------------------------------------------------------------------
module "zookeeper_task" {
  source = "../se-zookeeper-task"

  name        = "se-zookeeper-1"
  environment = "${var.environment}"
  image       = "confluentinc/cp-zookeeper"
  image_tag   = "latest"

  cpu                = "1024"
  memory             = "512"
  memory_reservation = "256"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.awslogs_group}"
  awslogs_region        = "${coalesce(var.awslogs_region, var.region)}"
  awslogs_stream_prefix = "${coalesce(var.awslogs_stream_prefix, var.cluster)}"

  ports = <<EOF
  [
    {
      "protocol": "tcp",
      "containerPort": 22181,
      "hostPort": 22181
    },
    {
      "protocol": "tcp",
      "containerPort": 22888,
      "hostPort": 22888
    },
    {
      "protocol": "tcp",
      "containerPort": 23888,
      "hostPort": 23888
    }
  ]
  EOF

  # { "name": "ZOOKEEPER_SERVERS",     "value": "se-zookeeper-1.internal:22888:23888" }
  env_vars = <<EOF
  [
    { "name": "ZOOKEEPER_SERVER_ID",   "value": "1" }, 
    { "name": "ZOOKEEPER_CLIENT_PORT", "value": "22181" }, 
    { "name": "ZOOKEEPER_TICK_TIME",   "value": "2000" }, 
    { "name": "ZOOKEEPER_INIT_LIMIT",  "value": "5" }, 
    { "name": "ZOOKEEPER_SYNC_LIMIT",  "value": "2" }
  ]
  EOF
}

# -----------------------------------------------------------------------------
# ECS service for se-kafka
# -----------------------------------------------------------------------------

resource "aws_ecs_service" "kafka" {
  name    = "se-kafka-1"
  cluster = "${var.cluster}"

  # iam_role = "${var.iam_role}"

  desired_count                      = "1"
  deployment_minimum_healthy_percent = "0"
  deployment_maximum_percent         = "100"
  placement_constraints {
    type       = "memberOf"
    expression = "attribute:se-instance-type == confluent"
  }
  placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }
  placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
  lifecycle {
    create_before_destroy = true
  }
  # Track the latest ACTIVE revision
  task_definition = "${module.kafka_task.name}:${module.kafka_task.max_revision}"
}

# -----------------------------------------------------------------------------
# ECS task for se-kafka
# -----------------------------------------------------------------------------
module "kafka_task" {
  source = "../se-kafka-task"

  name        = "se-kafka-1"
  environment = "${var.environment}"
  image       = "confluentinc/cp-kafka"
  image_tag   = "latest"

  cpu                = "1024"
  memory             = "512"
  memory_reservation = "256"

  # AWS CloudWatch Log Variables
  awslogs_group         = "${var.awslogs_group}"
  awslogs_region        = "${coalesce(var.awslogs_region, var.region)}"
  awslogs_stream_prefix = "${coalesce(var.awslogs_stream_prefix, var.cluster)}"

  ports = <<EOF
  [
    {
      "protocol": "tcp",
      "containerPort": 29092,
      "hostPort": 29092
    }
  ]
  EOF

  env_vars = <<EOF
  [
    { "name": "KAFKA_BROKER_ID",            "value": "1" }, 
    { "name": "KAFKA_ZOOKEEPER_CONNECT",    "value": "se-zookeeper-1.internal:22181" }, 
    { "name": "KAFKA_ADVERTISED_LISTENERS", "value": "PLAINTEXT://se-kafka-1.internal:29092" }
  ]
  EOF
}
