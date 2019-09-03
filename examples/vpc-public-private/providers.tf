provider "aws" {
  region  = "${var.aws_region}"
  version = "2.16.0"
}

provider "template" {
  version = "2.1.2"
}
