data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  az = length(var.availability_zones) > 0 ? var.availability_zones : data.aws_availability_zones.available.names

  tags_without_name = merge(
    {
      "Environment" = format("%s", var.environment)
    },
    {
      "Project" = format("%s", var.project)
    },
    var.tags,
  )
  tags = merge(
    {
      "Name" = format("%s-vpc", var.environment)
    },
    local.tags_without_name,
  )
}

resource "aws_vpc" "vpc" {
  cidr_block           = cidrsubnet(var.cidr_block, 0, 0)
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = local.tags
}

resource "aws_default_network_acl" "default" {
  count = var.enable_create_defaults ? 1 : 0

  default_network_acl_id = aws_vpc.vpc.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

resource "aws_default_route_table" "route_table" {
  count = var.enable_create_defaults ? 1 : 0

  default_route_table_id = aws_vpc.vpc.default_route_table_id

  tags = local.tags
}

resource "aws_default_security_group" "default" {
  count = var.enable_create_defaults ? 1 : 0

  vpc_id = aws_vpc.vpc.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = local.tags
}

resource "aws_route_table" "public_routetable" {
  vpc_id = aws_vpc.vpc.id

  tags = local.tags
}

resource "aws_route" "public_route" {
  depends_on = [aws_route_table.public_routetable]

  route_table_id         = aws_route_table.public_routetable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone       = element(local.az, count.index)
  map_public_ip_on_launch = var.public_subnet_map_public_ip_on_launch
  count                   = length(local.az)

  tags = merge(
    {
      "Name" = format(
        "%s-%s-public",
        var.environment,
        element(local.az, count.index),
      )
    },
    {
      "Tier" = "public"
    },
    local.tags_without_name,
    var.public_subnet_tags
  )
}

resource "aws_route_table_association" "public_routing_table" {
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_routetable.id
  count          = length(local.az)
}

resource "aws_route_table" "private_routetable" {
  count  = var.create_private_subnets ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = local.tags
}

resource "aws_route" "private_route" {
  count      = var.create_private_subnets ? 1 : 0
  depends_on = [aws_route_table.private_routetable]

  route_table_id         = element(aws_route_table.private_routetable.*.id, 0)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat.*.id, 0)
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(
    var.cidr_block,
    8,
    length(local.az) + count.index,
  )

  availability_zone       = element(local.az, count.index)
  map_public_ip_on_launch = false
  count                   = var.create_private_subnets ? length(local.az) : 0

  tags = merge(
    {
      "Name" = format(
        "%s-%s-private",
        var.environment,
        element(local.az, count.index),
      )
    },
    {
      "Tier" = "private"
    },
    local.tags_without_name,
    var.private_subnet_tags
  )
}

resource "aws_route_table_association" "private_routing_table" {
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private_routetable.*.id, 0)
  count          = var.create_private_subnets ? length(local.az) : 0
}

data "aws_vpc_endpoint_service" "s3" {
  count   = var.create_s3_vpc_endpoint ? 1 : 0
  service = "s3"
}

resource "aws_vpc_endpoint" "s3_vpc_endpoint" {
  count        = var.create_s3_vpc_endpoint ? 1 : 0
  vpc_id       = aws_vpc.vpc.id
  service_name = element(data.aws_vpc_endpoint_service.s3.*.service_name, 0)

  tags = local.tags
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  count = var.create_s3_vpc_endpoint && var.create_private_subnets ? 1 : 0

  vpc_endpoint_id = element(aws_vpc_endpoint.s3_vpc_endpoint.*.id, 0)
  route_table_id  = element(aws_route_table.private_routetable.*.id, count.index)
}

resource "aws_vpc_endpoint_route_table_association" "public_s3" {
  count = var.create_s3_vpc_endpoint ? 1 : 0

  vpc_endpoint_id = element(aws_vpc_endpoint.s3_vpc_endpoint.*.id, 0)
  route_table_id  = element(aws_route_table.public_routetable.*.id, count.index)
}

resource "aws_eip" "nat" {
  count = var.create_private_subnets ? 1 : 0
  vpc   = true

  tags = local.tags
}

resource "aws_nat_gateway" "nat" {
  count         = var.create_private_subnets ? 1 : 0
  allocation_id = element(aws_eip.nat.*.id, 0)
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = local.tags
}

resource "aws_route53_zone" "local" {
  count   = var.create_private_hosted_zone ? 1 : 0
  name    = "${var.environment}.local"
  comment = "${var.environment} - route53 - local hosted zone"

  tags = local.tags

  vpc {
    vpc_id = aws_vpc.vpc.id
  }
}

