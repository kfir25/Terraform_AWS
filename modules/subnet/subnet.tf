
################################################################################
# Publiс Subnets
################################################################################

resource "aws_subnet" "public" {
  availability_zone                              = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  cidr_block                                     = var.public_subnet_ipv6_native ? null : element(concat(var.public_subnets, [""]), count.index)
#   enable_dns64                                   = var.enable_ipv6 && var.public_subnet_enable_dns64
#   enable_resource_name_dns_aaaa_record_on_launch = var.enable_ipv6 && var.public_subnet_enable_resource_name_dns_aaaa_record_on_launch
#   enable_resource_name_dns_a_record_on_launch    = !var.public_subnet_ipv6_native && var.public_subnet_enable_resource_name_dns_a_record_on_launch
#   map_public_ip_on_launch                        = var.map_public_ip_on_launch
#   private_dns_hostname_type_on_launch            = var.public_subnet_private_dns_hostname_type_on_launch
  vpc_id                                         = local.vpc_id

  tags = var.tags
}


resource "aws_route_table_association" "public" {

}


resource "aws_route" "public_internet_gateway" {

}