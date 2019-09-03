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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| availability\_zones |  | map | `<map>` | no |
| aws\_region | The Amazon region | string | n/a | yes |
| cidr\_block |  | string | `"10.0.0.0/16"` | no |
| create\_private\_hosted\_zone |  | string | `"true"` | no |
| create\_private\_subnets |  | string | `"true"` | no |
| create\_s3\_vpc\_endpoint | Whether to create a VPC Endpoint for S3, so the S3 buckets can be used from within the VPC without using the NAT gateway. | string | `"true"` | no |
| environment |  | string | n/a | yes |
| project |  | string | `""` | no |
| public\_subnet\_map\_public\_ip\_on\_launch |  | string | `"false"` | no |
| tags | Map of tags to apply on the resources | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| availability\_zones | List of the availability zones. |
| nat\_gateway\_public\_ip | Public IP address of the NAT gateway. |
| private\_dns\_zone\_id | ID of the the private DNS zone, optional. |
| private\_domain\_name | Private domain name, optional. |
| private\_subnets | List of the private subnets. |
| private\_subnets\_route\_table |  |
| public\_subnets | List of the public subnets. |
| public\_subnets\_route\_table |  |
| vpc\_cidr | VPC CDIR. |
| vpc\_id | ID of the VPC. |

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
