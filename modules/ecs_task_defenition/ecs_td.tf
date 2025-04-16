# A task definition is like a Docker Compose file for ECS

# get my account id : aws sts get-caller-identity --query Account --output text

resource "aws_ecs_task_definition" "my_task" {
  family                   = var.task_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu #"256"
  memory                   = var.memory #"512"
  execution_role_arn       = "arn:aws:iam::${var.account_id}:role/ecsTaskExecutionRole"  # 145023112744

  container_definitions = jsonencode([
    {
      name      = var.container_name #"my-container"
      image     = var.container_image  #"nginx"  # Replace with your real image
      portMappings = [
        {
          containerPort = var.container_port #80
          hostPort      = var.container_port #80
          protocol      = "tcp"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = var.log_group_name,
          awslogs-region        = var.aws_region,
          awslogs-stream-prefix = var.container_name
        }
      }
    }
  ])
}
