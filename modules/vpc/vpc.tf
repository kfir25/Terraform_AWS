
locals { 
  subnets = { for vpc_key,v in var.subnets: vpc_key => {
    subnet_name = v.subnet_name
    subnet_cidr_block  = v.subnet_cidr_block 
    vpc_id = try(v.vpc_id, aws_vpc.main_vpc.id)
    availability_zone = try(v.availability_zone, "")
   }
  }

  routes = { for rt_key,v in var.routes: rt_key => {
    cidr_block = v.cidr_block
    gateway_id  = v.gateway_id 
   }
  }

}
################################################################################
# VPC
################################################################################

resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr_block

#   instance_tenancy                     = var.instance_tenancy
#   enable_dns_hostnames                 = var.enable_dns_hostnames
#   enable_dns_support                   = var.enable_dns_support  #defualt is true
#   enable_network_address_usage_metrics = var.enable_network_address_usage_metrics
  
  tags = var.vpc_tags
  
}

################################################################################
# VPC Internet Gateway
################################################################################

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = var.vpc_tags
}

################################################################################
# VPC routing table
################################################################################

resource "aws_route_table" "vpc_rt" {
  vpc_id = aws_vpc.main_vpc.id

  # for_each = local.routes


}
################################################################################
# Publiс Subnets
################################################################################

resource "aws_subnet" "public" {
    for_each = local.subnets
    availability_zone                              = each.value.availability_zone
    cidr_block                                     = each.value.subnet_cidr_block
#   enable_dns64                                   = var.enable_ipv6 && var.public_subnet_enable_dns64
#   enable_resource_name_dns_aaaa_record_on_launch = var.enable_ipv6 && var.public_subnet_enable_resource_name_dns_aaaa_record_on_launch
#   enable_resource_name_dns_a_record_on_launch    = !var.public_subnet_ipv6_native && var.public_subnet_enable_resource_name_dns_a_record_on_launch
#   map_public_ip_on_launch                        = var.map_public_ip_on_launch
#   private_dns_hostname_type_on_launch            = var.public_subnet_private_dns_hostname_type_on_launch
    vpc_id                                         = each.value.vpc_id

    tags = "${each.value.subnet_name}"


}


resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.vpc_rt.id
}

resource "aws_route" "routes" {
  for_each = local.routes
  route_table_id            = aws_route_table.vpc_rt.id
  destination_cidr_block = each.value.cidr_block
  gateway_id = each.value.gateway_id
}


################################################################################
# Public Network ACLs
################################################################################

# resource "aws_network_acl" "public" {

# }

# resource "aws_network_acl_rule" "public_inbound" {

# }

# resource "aws_network_acl_rule" "public_outbound" {

# }

################################################################################
# Public Security Group
################################################################################


################################################################################
# Private Subnets
################################################################################

# resource "aws_subnet" "private" {

# }

# resource "aws_route_table" "private" {

# }

# resource "aws_route_table_association" "private" {

# }

################################################################################
# Private Network ACLs
################################################################################

# resource "aws_network_acl" "private" {

# }

# resource "aws_network_acl_rule" "private_inbound" {

# }

