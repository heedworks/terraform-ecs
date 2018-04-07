name = "se-app"

environment = "integration"

aws_account_key = "integration"

aws_account_id = "205210731340"

aws_account_name = "se-sandbox-account"

region = "us-east-1"

aws_creds_profile = "se-ops-account-terraform"

external_domain_name = "integration.sedev.net"

internal_domain_name = "internal"

vpc_cidr = "10.0.0.0/16"

internal_subnets = ["10.0.50.0/24", "10.0.51.0/24", "10.0.52.0/24"]

external_subnets = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]

availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

key_name = "se-app-internal-key"

bastion_instance_type = "t2.micro"

ecs_min_size = 3

ecs_max_size = 100

ecs_desired_capacity = 3

ecs_instance_type = "t2.medium"

default_task_cpu = 0

default_task_memory = 256

default_task_memory_reservation = 64

default_image_tag = "integration"

default_node_env = "development"

default_se_env = "integration"

// kafka_host = "ec2-35-172-33-1.compute-1.amazonaws.com:9092,ec2-52-90-107-255.compute-1.amazonaws.com:9092,ec2-54-236-63-243.compute-1.amazonaws.com:9092"

// kafka_host = "ip-10-30-133-67.ec2.internal:9092,ip-10-30-148-117.ec2.internal:9092,ip-10-30-141-122.ec2.internal:9092"

kafka_host = "ip-10-30-133-67.ec2.internal:9092,ip-10-30-148-117.ec2.internal:9092,ip-10-30-141-122.ec2.internal:9092"
