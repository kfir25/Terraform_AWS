
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
