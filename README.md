# Terraform module for creating a vpc

This module creates one VPC, by default it creates public and private subnets in all the availability zones for the selected region.

## Terraform version

- Terraform 0.12: Pin module to `~> 2+`, submit pull request to branch `terraform012`
- Terraform 0.11: Pin module to `~> 1.x`, submit pull request to branch `develop`

## Example usages:

See the [examples](./examples) for executable examples.

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
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| availability\_zones | List to specify the availability zones for which subnes will be created. By default all availability zones will be used. | list | `<list>` | no |
| aws\_region | The Amazon region | string | n/a | yes |
| cidr\_block | The CIDR block used for the VPC. | string | `"10.0.0.0/16"` | no |
| create\_private\_hosted\_zone | Indicate to create a private hosted zone. | bool | `"true"` | no |
| create\_private\_subnets | Indicates to create private subnets. | bool | `"true"` | no |
| create\_s3\_vpc\_endpoint | Whether to create a VPC Endpoint for S3, so the S3 buckets can be used from within the VPC without using the NAT gateway. | bool | `"true"` | no |
| environment | Environment name, will be added for resource tagging. | string | n/a | yes |
| project | Project name, will be added for resource tagging. | string | `""` | no |
| public\_subnet\_map\_public\_ip\_on\_launch | Enable public ip creaton by default on EC2 instance launch. | bool | `"false"` | no |
| tags | Map of tags to apply on the resources | map(string) | `<map>` | no |

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

## Automated checks
Currently the automated checks are limited. In CI the following checks are done for the root and each example.
- lint: `terraform validate` and `terraform fmt`
- basic init / get check: `terraform init -get -backend=false -input=false`

## Generation variable documentation
A markdown table for variables can be generated as follow. Generation requires awk and terraform-docs installed.

```
 .ci/bin/terraform-docs.sh markdown
```

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
