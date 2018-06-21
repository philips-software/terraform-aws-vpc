module "vpc" {
  source = "../"

  environment = "my-awsome-project"
  aws_region  = "eu-west-1"

  // optional, defaults
  project                    = "Forest"
  create_private_hosted_zone = "false"  // default = true
  create_private_subnets     = "false"  // default = true

  // example to override default availability_zones
  availability_zones = {
    eu-west-1 = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  }
}
