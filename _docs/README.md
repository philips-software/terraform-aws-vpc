# Terraform module for creating a vpc

This module creates one VPC, by default it creates public and private subnets in all the availability zones for the selected region.

Via the aws-cli you can find which AZ are available in your region.
```
aws ec2 describe-availability-zones --region <region>
```

## Example usages:
```
module "vpc" {
  source = "github.com/philips-software/terraform-aws-vpc.git?ref=1.0.0"

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

  // add aditional tags
  tags = {
    my-tag = "my-new-tag"
  }
}

module "x" {
  source = "..."

  subnet_id = "${element(module.vpc.public_subnets, 0)}"
}

module "y" {
  source = "..."

  private_subnets  = "${module.vpc.private_subnets}"
  public_subnets   = "${module.vpc.public_subnets}"
}
```

$ESCAPED_DATA

## Philips Forest

This module is part of the Philips Forest.

```
                                                     ___                   _
                                                    / __\__  _ __ ___  ___| |_
                                                   / _\/ _ \| '__/ _ \/ __| __|
                                                  / / | (_) | | |  __/\__ \ |_
                                                  \/   \___/|_|  \___||___/\__|  

                                                                 Infrastructure
```

Talk to the forestkeepers in the `forest`-channel on Slack.

[![Slack](https://philips-software-slackin.now.sh/badge.svg)](https://philips-software-slackin.now.sh)
