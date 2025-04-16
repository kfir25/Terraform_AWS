
module "vpc" {
  source = "./modules/vpc"
  
  subnets       =  local.subnets
  vpc_cidr_block = local.vpc_cidr_block
  vpc_tags = local.vpc_tags
  routes = local.routes


}