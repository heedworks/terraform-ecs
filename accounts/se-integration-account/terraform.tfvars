region = "us-east-1"

aws_account_id = "205210731340"

aws_creds_profile = "se-ops-account-terraform"

vpc_cidr = "10.0.0.0/16"

cluster = "se-app"

environment = "integration"

public_subnet_cidrs = ["10.0.0.0/24", "10.0.1.0/24"]

private_subnet_cidrs = ["10.0.50.0/24", "10.0.51.0/24"]

availability_zones = ["us-east-1a", "us-east-1b"]

max_size = 100

min_size = 3

desired_capacity = 3

instance_type = "t2.large"

ecs_aws_ami = "ami-a7a242da"
