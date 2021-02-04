provider "aws" {
  region  = var.aws_region
  version = "~> 3.23.0"
}

provider "template" {
  version = "~> 2.1.2"
}

