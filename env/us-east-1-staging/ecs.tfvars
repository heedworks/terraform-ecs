region = "us-east-1"

aws_creds_profile = "ignite_dev"

vpc_cidr = "10.0.0.0/16"

cluster = "staging"

environment = "staging"

public_subnet_cidrs = ["10.0.0.0/24", "10.0.1.0/24"]

private_subnet_cidrs = ["10.0.50.0/24", "10.0.51.0/24"]

availability_zones = ["us-east-1a", "us-east-1b"]

max_size = 100

min_size = 3

desired_capacity = 3

instance_type = "t2.large"

ecs_aws_ami = "ami-a7a242da"
