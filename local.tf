
locals {

##############################################################################
### VPC - subnets - routes
##############################################################################
  
  #vpc1
  vpc_tags = {
    Name = "vpc_test_name"
  }
  vpc_cidr_block = "10.0.0.0/24"

  subnets = {
    public_subnet = {
      subnet_name = {
        Name = "public_subnet"
      }
      subnet_cidr_block  = "10.0.0.0/25"
      # vpc_id = ""
      availability_zone = "us-east-1a"

    }

    demo_subnet = {
      subnet_name = {
        # Just for demo the creation of multi-subnets
        Name = "demo_subnet"
      }
      subnet_cidr_block  = "10.0.0.128/25"
      # vpc_id = ""
      availability_zone = "us-east-1b"

    }

  }

  routes = {

  #   route = {
  #   AWS create this route automaticly
  #   cidr_block = local.vpc_cidr_block
  #   gateway_id = "local"
  # }

    route_igw = {
      #This will make the subnet public internet facing
    cidr_block = "0.0.0.0/0"
    gateway_id = module.vpc.aws_internet_gateway
  }
  }





##############################################################################
### ECS - fargate
##############################################################################
  
  ecs_name = "fargate-cluster"

  task_name = "my_task"
  account_id = 977037036498
  cpu = 256
  memory = 512
  container_name = "my_container"
  container_image = "nginx"
  container_port = 80
  log_group_name = "/ecs/my-task"










}
