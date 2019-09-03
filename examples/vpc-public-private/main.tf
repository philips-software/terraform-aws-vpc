module "vpc" {
  source = "../../"

  environment = var.environment
  aws_region  = var.aws_region

  // optional, defaults
  project = "Forest"

  // example to override default availability_zones
  # availability_zones = {
  #   eu-west-1 = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  # }

  // add aditional tags
  tags = {
    my-tag = "my-new-tag"
  }
}
