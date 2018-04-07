name = "se-app"

environment = "sandbox"

aws_account_key = "sandbox"

aws_account_id = "616175625615"

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

# ecs_task_image_key = "sandbox"

# ecs_cluster_name = "se-app"

ecs_min_size = 3

ecs_max_size = 100

ecs_desired_capacity = 3

ecs_instance_type = "t2.medium"

# ecs_root_volume_size = "25"

# ecs_docker_volume_size = "25"

# ecs_ami = "ami-a7a242da"

# kong_db_password = "7dxvs>)Dmtc2nnc"

# mongo_connection_string_template = "mongodb://admin:rGmGTpEnhf2%3E%253frvpDXMPUP@cluster0-shard-00-00-hulfh.mongodb.net:27017,cluster0-shard-00-01-hulfh.mongodb.net:27017,cluster0-shard-00-02-hulfh.mongodb.net:27017/%s?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin"

default_task_cpu = 0

default_task_memory = 256

default_task_memory_reservation = 64

default_image_tag = "integration"

default_node_env = "development"

default_se_env = "development"

kafka_host = "10.30.135.194:9092,10.30.145.248:9092,10.30.128.213:9092"
