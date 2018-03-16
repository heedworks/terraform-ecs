variable "region" {
  description = "The AWS region"
}

variable "cidr" {
  description = "The CIDR block to provision for the VPC"
}

variable "default_ecs_ami" {
  default = {
    us-east-1      = "ami-cad827b7"
    us-east-2      = "ami-ef64528a"
    us-west-1      = "ami-29b8b249"
    us-west-2      = "ami-baa236c2"
    eu-west-1      = "ami-64c4871d"
    eu-west-2      = "ami-25f51242"
    eu-west-3      = "ami-0356e07e"
    eu-central-1   = "ami-3b7d1354"
    ap-northeast-1 = "ami-bb5f13dd"
    ap-northeast-2 = "ami-3b19b455"
    ap-southeast-1 = "ami-f88ade84"
    ap-southeast-2 = "ami-a677b6c4"
    sa-east-1      = "ami-da2c66b6"
    ca-central-1   = "ami-db48cfbf"
    ap-south-1     = "ami-9e91cff1"
  }
}

# http://docs.aws.amazon.com/ElasticLoadBalancing/latest/DeveloperGuide/enable-access-logs.html#attach-bucket-policy
variable "default_log_account_ids" {
  default = {
    us-east-1      = "127311923021"
    us-east-2      = "033677994240"
    us-west-1      = "027434742980"
    us-west-2      = "797873946194"
    eu-west-1      = "156460612806"
    eu-west-2      = "652711504416"
    eu-west-3      = "009996457667"
    eu-central-1   = "054676820928"
    ap-northeast-1 = "582318560864"
    ap-northeast-2 = "600734575887"
    ap-northeast-3 = "383597477331"
    ap-southeast-1 = "114774131450"
    ap-southeast-2 = "783225319266"
    sa-east-1      = "507241528517"
    ca-central-1   = "985666609251"
    us-gov-west-1  = "048591011584"
    cn-north-1     = "638102146993"
    cn-northwest-1 = "037604701340"
    ap-south-1     = "718504428378"
  }
}
