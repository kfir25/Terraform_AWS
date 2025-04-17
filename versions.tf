terraform {
  required_version = ">= 1.11.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # I can use S3 bucket with DynamoDB as backend for statelock or local for test
#   backend "local" {
#     path = "terraform.tfstate"
#   }



  backend "s3" {
    bucket         = "kfir-terraform-state-bucket"
    key            = "test/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    # dynamodb_table = "terraform-locks" # Optional: for state locking
  }

}

provider "aws" {
  region = var.region #"us-east-1"  # You can change the region as per your requirement
  }
