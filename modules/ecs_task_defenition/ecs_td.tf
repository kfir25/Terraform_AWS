# A task definition is like a Docker Compose file for ECS

# get my account id : aws sts get-caller-identity --query Account --output text

resource "aws_ecs_task_definition" "my_task" {
  family                   = var.task_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu #"256"
  memory                   = var.memory #"512"
  execution_role_arn       = var.execution_role_arn #"arn:aws:iam::${var.account_id}:role/ecsTaskExecutionRole"  # 145023112744
  task_role_arn            = try(var.task_role_arn, null)

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image  # Replace with your real image
      portMappings = [
        {
          containerPort = var.container_port #80
          hostPort      = var.container_port #80
          protocol      = "tcp"
        }
      ],
      environment = try(var.environment, null),
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


# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = var.log_group_name
  retention_in_days = 7
}
