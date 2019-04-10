variable "environment" {
  type = "string"
}

variable "project" {
  type    = "string"
  default = ""
}

variable "aws_region" {
  type        = "string"
  description = "The Amazon region"
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type = "map"

  default = {
    us-east-1      = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
    us-east-2      = ["us-east-2a", "eu-east-2b", "eu-east-2c"]
    us-west-1      = ["us-west-1a", "us-west-1c"]
    us-west-2      = ["us-west-2a", "us-west-2b", "us-west-2c"]
    ca-central-1   = ["ca-central-1a", "ca-central-1b"]
    eu-west-1      = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
    eu-west-2      = ["eu-west-2a", "eu-west-2b"]
    eu-central-1   = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
    ap-south-1     = ["ap-south-1a", "ap-south-1b"]
    sa-east-1      = ["sa-east-1a", "sa-east-1c"]
    ap-northeast-1 = ["ap-northeast-1a", "ap-northeast-1c"]
    ap-southeast-1 = ["ap-southeast-1a", "ap-southeast-1b"]
    ap-southeast-2 = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
    ap-northeast-1 = ["ap-northeast-1a", "ap-northeast-1c"]
    ap-northeast-2 = ["ap-northeast-2a", "ap-northeast-2c"]
  }
}

variable "create_private_subnets" {
  default = "true"
}

variable "create_private_hosted_zone" {
  default = "true"
}

variable "public_subnet_map_public_ip_on_launch" {
  default = "false"
}

variable "create_s3_vpc_endpoint" {
  default = "true"
  description = "Whether to create a VPC Endpoint for S3, so the S3 buckets can be used from within the VPC without using the NAT gateway."
}

variable "tags" {
  type        = "map"
  description = "Map of tags to apply on the resources"
  default     = {}
}
