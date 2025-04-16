
resource "aws_ecs_cluster" "ecs_fargate" {
  name = var.ecs_name

  setting {
    # Add CloudWatch Container Insights
    name  = "containerInsights"
    value = "enabled"
  }
}
#terraform import aws_iam_role.ecs_task_execution_role ecsTaskExecutionRole


