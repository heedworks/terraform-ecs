name = "se-app"

region = "us-east-1"

aws_account_id = "616175625615"

aws_creds_profile = "se-ops-account-terraform"

external_domain_name = "integration.sedev.net"

internal_domain_name = "internal"

environment = "sandbox"

aws_account_key = "sandbox"

vpc_cidr = "10.0.0.0/16"

internal_subnets = ["10.0.50.0/24", "10.0.51.0/24", "10.0.52.0/24"]

external_subnets = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]

availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

key_name = "internal-key"

bastion_instance_type = "t2.micro"

ecs_task_image_key = "sandbox"

ecs_cluster_name = "se-app"

ecs_max_size = 100

ecs_min_size = 3

ecs_desired_capacity = 3

ecs_instance_type = "t2.large"

ecs_root_volume_size = "25"

ecs_docker_volume_size = "25"

ecs_ami = "ami-a7a242da"
