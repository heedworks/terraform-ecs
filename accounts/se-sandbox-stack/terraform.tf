provider "aws" {
  region  = "us-west-2"
  profile = "se-ops-account-terraform"

  assume_role {
    role_arn     = "arn:aws:iam::616175625615:role/TerraformRole"
    session_name = "terraform"
  }
}

module "stack" {
  source      = "github.com/segmentio/stack"
  environment = "prod"
  key_name    = "stack-my-app"
  name        = "my-app"
}
