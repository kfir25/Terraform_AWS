
resource "aws_s3_bucket" "microservice_bucket" {
  bucket = "${var.bucket}-${random_id.suffix.hex}"

  force_destroy = true

  tags = var.tags
}

resource "random_id" "suffix" {
  byte_length = 4
}