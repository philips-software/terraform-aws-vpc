terraform {
  required_version = ">= 0.8"
}

resource "aws_vpc" "vpc" {
  cidr_block           = "${cidrsubnet(var.cidr_block, 0, 0)}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = "${merge(map("Name", format("%s-vpc", var.environment)),
          map("Environment", format("%s", var.environment)),
          map("Project", format("%s", var.project)),
          var.tags)}"
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = "${aws_vpc.vpc.default_network_acl_id}"

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

  tags = "${merge(map("Name", format("%s-acl", var.environment)),
          map("Environment", format("%s", var.environment)),
          map("Project", format("%s", var.project)),
          var.tags)}"

  lifecycle {
    ignore_changes = ["subnet_ids"]
  }
}

resource "aws_default_route_table" "route_table" {
  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"

  tags = "${merge(map("Name", format("%s-default-routetable", var.environment)),
          map("Environment", format("%s", var.environment)),
          map("Project", format("%s", var.project)),
          var.tags)}"
}

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.vpc.id}"

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

  tags = "${merge(map("Name", format("%s-default-sg", var.environment)),
          map("Environment", format("%s", var.environment)),
          map("Project", format("%s", var.project)),
          var.tags)}"
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(map("Name", format("%s-internet-gateway", var.environment)),
          map("Environment", format("%s", var.environment)),
          map("Project", format("%s", var.project)),
          var.tags)}"
}

resource "aws_route_table" "public_routetable" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(map("Name", format("%s-public-routetable", var.environment)),
          map("Environment", format("%s", var.environment)),
          map("Project", format("%s", var.project)),
          var.tags)}"
}

resource "aws_route" "public_route" {
  depends_on = ["aws_route_table.public_routetable"]

  route_table_id         = "${aws_route_table.public_routetable.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet_gateway.id}"
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet(var.cidr_block, 8, count.index)}"
  availability_zone       = "${element(var.availability_zones[var.aws_region], count.index)}"
  map_public_ip_on_launch = "${var.public_subnet_map_public_ip_on_launch}"
  count                   = "${length(var.availability_zones[var.aws_region])}"

  tags = "${merge(map("Name", format("%s-%s-public", var.environment, element(var.availability_zones[var.aws_region], count.index))),
          map("Environment", format("%s", var.environment)),
          map("Project", format("%s", var.project)),
          map("Tier", "public"),
          var.tags)}"
}

resource "aws_route_table_association" "public_routing_table" {
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_routetable.id}"
  count          = "${length(var.availability_zones[var.aws_region])}"
}

resource "aws_route_table" "private_routetable" {
  count  = "${var.create_private_subnets ? 1 : 0}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(map("Name", format("%s-private-routetable", var.environment)),
          map("Environment", format("%s", var.environment)),
          map("Project", format("%s", var.project)),
          var.tags)}"
}

resource "aws_route" "private_route" {
  count      = "${var.create_private_subnets ? 1 : 0}"
  depends_on = ["aws_route_table.private_routetable"]

  route_table_id         = "${aws_route_table.private_routetable.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat.id}"
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet(var.cidr_block, 8, length(var.availability_zones[var.aws_region]) + count.index)}"
  availability_zone       = "${element(var.availability_zones[var.aws_region], count.index)}"
  map_public_ip_on_launch = false
  count                   = "${var.create_private_subnets ? length(var.availability_zones[var.aws_region]) : 0}"

  tags = "${merge(map("Name", format("%s-%s-private", var.environment, element(var.availability_zones[var.aws_region], count.index))),
          map("Environment", format("%s", var.environment)),
          map("Project", format("%s", var.project)),
          map("Tier", "private"),
          var.tags)}"
}

resource "aws_route_table_association" "private_routing_table" {
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.private_routetable.id}"
  count          = "${var.create_private_subnets ? length(var.availability_zones[var.aws_region]) : 0}"
}

data "aws_vpc_endpoint_service" "s3" {
  count   = "${var.create_s3_vpc_endpoint ? 1 : 0}"
  service = "s3"
}

resource "aws_vpc_endpoint" "s3_vpc_endpoint" {
  count           = "${var.create_s3_vpc_endpoint ? 1 : 0}"
  vpc_id          = "${aws_vpc.vpc.id}"
  service_name    = "${data.aws_vpc_endpoint_service.s3.service_name}"
  route_table_ids = ["${concat(aws_route_table.public_routetable.*.id, aws_route_table.private_routetable.*.id)}"]

  tags = "${merge(map("Name", format("%s-s3-endpoint", var.environment)),
          map("Environment", format("%s", var.environment)),
          map("Project", format("%s", var.project)),
          var.tags)}"
}

resource "aws_eip" "nat" {
  count = "${var.create_private_subnets ? 1 : 0}"
  vpc   = true

  tags = "${merge(map("Name", format("%s-eip", var.environment)),
           map("Environment", format("%s", var.environment)),
           map("Project", format("%s", var.project)),
           var.tags)}"
}

resource "aws_nat_gateway" "nat" {
  count         = "${var.create_private_subnets ? 1 : 0}"
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public_subnet.0.id}"

  tags = "${merge(map("Name", format("%s-nat-gateway", var.environment)),
          map("Environment", format("%s", var.environment)),
          map("Project", format("%s", var.project)),
          var.tags)}"
}

resource "aws_route53_zone" "local" {
  count   = "${var.create_private_hosted_zone ? 1 : 0}"
  name    = "${var.environment}.local"
  comment = "${var.environment} - route53 - local hosted zone"

  tags = "${merge(map("Name", format("%s-route53-private-hosted-zone", var.environment)),
          map("Environment", format("%s", var.environment)),
          map("Project", format("%s", var.project)),
          var.tags)}"

  vpc {
    vpc_id = "${aws_vpc.vpc.id}"
  }
}
