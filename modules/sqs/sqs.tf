
resource "aws_sqs_queue" "microservice_queue" {
  name = var.name

  tags = var.tags
}