
#Create an ECS Service

resource "aws_ecs_service" "my_service" {
  name            = var.name #"my-service"
  cluster         = var.cluster #aws_ecs_cluster.my_cluster.id
  launch_type     = "FARGATE"
  desired_count   = 1
  task_definition = var.task_definition #aws_ecs_task_definition.my_task.arn

  network_configuration {
    subnets          = var.private_subnet_ids  # or public, depending on setup
    security_groups  = var.security_groups # [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn #aws_lb_target_group.my_tg.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

}