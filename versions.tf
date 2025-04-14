terraform {
  required_version = ">= 1.11.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

    # I can use S3 bucket with DynamoDB as backend for statelock
  backend "local" {
    path = "terraform.tfstate"
  }
}