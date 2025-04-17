
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
  container_image = "977037036498.dkr.ecr.us-east-1.amazonaws.com/microservice1:latest" #"amazonlinux:latest" #"nginx"
  container_port = 80
  log_group_name = "/ecs/my-task"
  ecs_service_assign_public_ip_ms1 = true

  ecs_service_name = "my_service"
  environment_vars_ecs_task = [
      {
        name  = "AWS_REGION"
        value = "us-east-1"
      },
      {
        name  = "SSM_PARAM"
        value = "/microservice/token"
      },
      {
        name  = "SQS_URL"
        value = module.sqs.sqs_queue_url   # "https://sqs.us-east-1.amazonaws.com/123456789012/my-queue"
      }
    ]


  task_name_ms2 = "microservice2"
  ecs_service_name_ms2 = "microservice2_service"
  ecs_service_assign_public_ip_ms2 = false
  log_group_name_ms2 = "/ecs/my-task-2"



##############################################################################
### ALB
##############################################################################
 

alb_name = "ecs-alb"
alb_subnet = "public_subnet"
load_balancer_type = "application"
internal = false









##############################################################################
### SQS
##############################################################################

sqs_name = "microservice-queue"
sqs_tags = {
  Service =  "microservice2"
}


##############################################################################
### S3
##############################################################################


bucket_name = "ms-bucket-uploads"
s3_tags = {
  Service =  "microservice2"
}


##############################################################################
### SSM Parameter Store
##############################################################################

ssm_name = "/microservice/token"

##############################################################################
### ECR
##############################################################################


ecr_name = "microservice1"

ecr_name_ms2 = "microservice2"

}





