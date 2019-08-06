## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| availability_zones | List to specify the availability zones for which subnes will be created. By default all availability zones will be used. | list | `<list>` | no |
| aws_region | The Amazon region | string | n/a | yes |
| cidr_block | The CIDR block used for the VPC. | string | `"10.0.0.0/16"` | no |
| create_private_hosted_zone | Indicate to create a private hosted zone. | bool | `"true"` | no |
| create_private_subnets | Indicates to create private subnets. | bool | `"true"` | no |
| create_s3_vpc_endpoint | Whether to create a VPC Endpoint for S3, so the S3 buckets can be used from within the VPC without using the NAT gateway. | bool | `"true"` | no |
| environment | Environment name, will be added for resource tagging. | string | n/a | yes |
| project | Project name, will be added for resource tagging. | string | `""` | no |
| public_subnet_map_public_ip_on_launch | Enable public ip creaton by default on EC2 instance launch. | bool | `"false"` | no |
| tags | Map of tags to apply on the resources | map(string) | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| availability_zones | List of the availability zones. |
| nat_gateway_public_ip | Public IP address of the NAT gateway. |
| private_dns_zone_id | ID of the the private DNS zone, optional. |
| private_domain_name | Private domain name, optional. |
| private_subnets | List of the private subnets. |
| private_subnets_route_table |  |
| public_subnets | List of the public subnets. |
| public_subnets_route_table |  |
| vpc_cidr | VPC CDIR. |
| vpc_id | ID of the VPC. |

