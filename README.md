# Terraform module for creating a vpc

This module creates one vpc, by default it creates public and private subnets in all the availability zones for the selected region.

Via the aws-cli you can find which AZ are available in your region.
```
aws ec2 describe-availability-zones --region <region>
```

## Example usages:
```
module "vpc" {
  source = "https://github.com/philips-software/terraform-aws-vpc.git?ref=1.0.0"

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

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| availability_zones |  | map | `<map>` | no |
| aws_region | The Amazon region | string | - | yes |
| cidr_block |  | string | `10.0.0.0/16` | no |
| create_private_hosted_zone |  | string | `true` | no |
| create_private_subnets |  | string | `true` | no |
| environment |  | string | - | yes |
| project |  | string | `` | no |
| public_subnet_map_public_ip_on_launch |  | string | `false` | no |

### Outputs

| Name | Description |
|------|-------------|
| availability_zones | List of the availability zones. |
| nat_gateway_public_ip | Public IP address of the NAT gateway. |
| private_dns_zone_id | ID of the the private DNS zone, optional. |
| private_domain_name | Private domain name, optional. |
| private_subnets | List of the private subnets. |
| public_subnets | List of the public subnets. |
| vpc_cidr | VPC CDIR. |
| vpc_id | ID of the VPC. |

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
