
module "vpc" {
  source = "./modules/vpc"
  
  subnets       =  local.subnets
  vpc_cidr_block = local.vpc_cidr_block
  vpc_tags = local.vpc_tags
  routes = local.routes

}




resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow inbound HTTP traffic from the internet"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to the internet
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

module "alb" {
  source = "./modules/alb"

  alb_name = local.alb_name
  internal = try(local.internal, null)
  load_balancer_type = try(local.load_balancer_type, null)
  public_subnets_ids = module.vpc.subnets
  target_group_arn = aws_lb_target_group.ecs_tg.arn
  security_groups = aws_security_group.alb_sg


}


resource "aws_lb_target_group" "ecs_tg" {
  name     = "ecs-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  target_type = "ip"  # Required for Fargate

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "ecs-tg"
  }
}
