
module "ecs_fargate" {
  source = "./modules/ECS"
  ecs_name = local.ecs_name
}

# Create an IAM Role for ECS Task Execution if not created automaticly by AWS
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Effect = "Allow",
      Sid     = ""
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


module "ecs_task_definition" {
  source = "./modules/ecs_task_defenition"

    task_name = local.task_name
    account_id = local.account_id
    cpu = local.cpu
    memory = local.memory
    container_name = local.container_name
    container_image = local.container_image
    container_port = local.container_port
    log_group_name = local.log_group_name
    aws_region = var.region

}

resource "aws_security_group" "ecs_sg" {
  name        = "ecs-service-sg"
  description = "Allow inbound HTTP traffic from the ALB and allow all egress"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "HTTP from ALB"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb_sg.id] # Only allow ALB to talk to ECS
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-service-sg"
  }
}


module "ecs_service" {
  source = "./modules/ecs_service"

  name = local.ecs_service_name
  cluster = module.ecs_fargate.cluster_id
  task_definition = module.ecs_task_definition.task_definition_arn
  private_subnet_ids = module.vpc.subnets
  security_groups = [aws_security_group.ecs_sg.id]
  target_group_arn = aws_lb_target_group.ecs_tg.arn
  container_name = local.container_name
  container_port = local.container_port

  depends_on = [module.alb]
}