aws_creds_profile = "ignite_dev"

vpc_cidr = "10.0.0.0/16"

environment = "prod"

public_subnet_cidrs = ["10.0.0.0/24", "10.0.1.0/24"]

private_subnet_cidrs = ["10.0.50.0/24", "10.0.51.0/24"]

availability_zones = ["us-east-1a", "us-east-1b"]

max_size = 4

min_size = 2

desired_capacity = 2

instance_type = "t2.micro"

ecs_aws_ami = "ami-13401669"
