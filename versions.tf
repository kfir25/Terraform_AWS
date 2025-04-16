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

provider "aws" {
  region = var.region #"us-east-1"  # You can change the region as per your requirement
  }


# provider "aws" {
#   region                      = "us-east-1"
#   access_key                  = "test"
#   secret_key                  = "test"
#   skip_credentials_validation = true
#   skip_metadata_api_check     = true
#   skip_requesting_account_id  = true

#   endpoints {
#     s3                         = "http://localhost:4566"
#     sqs                        = "http://localhost:4566"
#     iam                        = "http://localhost:4566"
#     ecs                        = "http://localhost:4566"
#     ec2                        = "http://localhost:4566"
#     logs                       = "http://localhost:4566"
#     elasticloadbalancing       = "http://localhost:4566"
#     sts                        = "http://localhost:4566"
#     cloudwatch                 = "http://localhost:4566"
#     ssm                        = "http://localhost:4566"
#   }
# }
