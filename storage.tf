
module "sqs" {
  source = "./modules/sqs"

  name = local.sqs_name
  tags = local.sqs_tags

}


module "s3" {
  source = "./modules/s3"

  bucket = local.bucket_name
  tags = local.s3_tags
}


resource "aws_iam_role" "ecs_task_role_microservice2" {
  name = "ecsTaskRole-microservice2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "ecs_task_policy_microservice2" {
  name = "ecsTaskPolicy-microservice2"
  role = aws_iam_role.ecs_task_role_microservice2.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = module.sqs.sqs_queue_arn
      },
      {
        Effect   = "Allow"
        Action   = [
          "s3:PutObject"
        ]
        Resource = "${module.s3.s3_bucket_arn}/*"
      }
    ]
  })
}


module "ssm_parameter" {
  source = "./modules/ssm_parameter"

  name = local.ssm_name
  microservice_token = var.microservice_token
}

module "ecr" {
    source = "./modules/ecr"
    
  
}