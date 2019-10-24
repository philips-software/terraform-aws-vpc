variable "environment" {
  description = "Environment name, will be added for resource tagging."
  type        = string
}

variable "project" {
  description = "Project name, will be added for resource tagging."
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "The Amazon region"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block used for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List to specify the availability zones for which subnes will be created. By default all availability zones will be used."
  type        = list
  default     = []
}

variable "create_private_subnets" {
  description = "Indicates to create private subnets."
  type        = bool
  default     = true
}

variable "create_private_hosted_zone" {
  description = "Indicate to create a private hosted zone."
  type        = bool
  default     = true
}

variable "public_subnet_map_public_ip_on_launch" {
  description = "Enable public ip creaton by default on EC2 instance launch."
  type        = bool
  default     = false
}

variable "create_s3_vpc_endpoint" {
  description = "Whether to create a VPC Endpoint for S3, so the S3 buckets can be used from within the VPC without using the NAT gateway."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Map of tags to apply on the resources"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Map of tags to apply on the public subnets"
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Map of tags to apply on the private subnets"
  type        = map(string)
  default     = {}
}

variable "enable_create_defaults" {
  description = "Add tags to the default resources."
  type        = bool
  default     = false
}
