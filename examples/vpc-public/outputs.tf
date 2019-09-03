

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}

output "private_dns_zone_id" {
  value = module.vpc.private_dns_zone_id
}

output "private_domain_name" {
  value = module.vpc.private_domain_name
}

output "nat_gateway_public_ip" {
  value = module.vpc.nat_gateway_public_ip
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "availability_zones" {
  value = module.vpc.availability_zones
}

output "public_subnets_route_table" {
  value = module.vpc.public_subnets_route_table
}

output "private_subnets_route_table" {
  value = module.vpc.private_subnets_route_table
}

