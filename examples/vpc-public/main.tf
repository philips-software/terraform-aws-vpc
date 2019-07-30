module "vpc" {
  source = "../../"

  environment = var.environment
  aws_region  = var.aws_region

  // optional, defaults
  project = "Forest"

  create_private_subnets = false

  // example to override default availability_zones
  availability_zones = ["eu-west-1a", "eu-west-1b"]

  // add aditional tags
  tags = {
    my-tag = "my-new-tag"
  }
}
