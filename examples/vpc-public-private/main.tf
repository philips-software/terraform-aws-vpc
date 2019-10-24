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

  // add tags on the subnets. Mostly useful when creating EKS clusters
  public_subnet_tags = {
    my-public-subnet-tag = "my-public-subnet-tag-value"
  }

  private_subnet_tags = {
    my-private-subnet-tag = "my-private-subnet-tag-value"
  }
}
