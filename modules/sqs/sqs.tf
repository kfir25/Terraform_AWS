
resource "aws_sqs_queue" "microservice_queue" {
  name = var.name "microservice-queue"

  tags = var.tags {
    Service     = "microservice2"
  }
}