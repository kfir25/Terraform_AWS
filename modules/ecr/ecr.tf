
# simple public ecr

resource "aws_ecr_repository" "ecr" {
  name = var.name
}