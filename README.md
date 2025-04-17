# Microservices ECS Fargate Project

## Overview
This project provides a complete, automated deployment of a system with two Docker-based microservices using Amazon ECS with Fargate. It includes:

- Elastic Load Balancer (ALB)
- Amazon S3 Bucket
- Amazon SQS Queue
- AWS Systems Manager Parameter Store
- GitHub Actions CI/CD pipeline
- Infrastructure managed via Terraform

## Architecture Summary
- **ECS Fargate Cluster** – Serverless hosting for microservices
- **Microservice 1** – REST API behind an ALB that validates a token and sends data to SQS
- **Microservice 2** – Consumes messages from SQS and writes them to S3
- **S3** – Stores data from Microservice 2
- **SQS** – Acts as a queue between the services
- **SSM Parameter Store** – Securely stores the token
- **IAM Roles** – Provides least-privilege access between services
- **GitHub Actions** – Automates build, push, and deploy steps

## Prerequisites

### Local Requirements
- Terraform
- AWS CLI
- Git
- Docker

### GitHub Setup
- GitHub account with a public repository
- AWS credentials (access key and secret key)

## GitHub Secrets Configuration

### 1. Set Up AWS Credentials
In AWS Console:
1. Go to IAM → Users → Create or select a user
2. Attach the `AdministratorAccess` policy (or scoped one)
3. Generate access keys

In GitHub:
1. Go to your repo → Settings → Secrets and variables → Actions → New repository secret
2. Add the following secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `MICROSERVICE_TOKEN` – Custom token for API validation

### 2. Terraform Backend Configuration
1. Create an S3 bucket for the Terraform state
2. (Optional) Create a DynamoDB table for state locking
3. Edit the `backend` block in `main.tf` to include the S3 bucket name and key

Example policy for S3 bucket access:
```json
"Action": [
  "s3:GetObject",
  "s3:PutObject",
  "s3:DeleteObject",
  "s3:ListBucket"
]
```

### 3. Create ECR Repositories
In AWS ECR Console, create two repositories:
- `microservice1`
- `microservice2`

These will store the container images for both services.

## Microservices Description

### Microservice 1 (API Service)
- Listens for HTTP POST requests via ALB
- Validates a token from AWS SSM
- Checks timestamp format
- Publishes the payload to SQS

### Microservice 2 (Worker Service)
- Periodically pulls messages from SQS
- Stores the parsed payload in S3 with a structured path

## CI/CD Pipeline
GitHub Actions is used for CI/CD.

### Workflows
- **Deploy Microservice1** – Builds and pushes the first microservice image to ECR
- **Deploy Microservice2** – Builds and pushes the second microservice image to ECR
- **Terraform CI/CD** –
  - `terraform-apply`: Provisions the infrastructure
  - Leave empty for `terraform plan` (dry run)
  - `terraform-destroy`: Destroys all infrastructure

You can trigger these workflows manually from the **Actions** tab in GitHub.

## Terraform Infrastructure
The following resources are provisioned by Terraform:

### ✅ Amazon ECS (Elastic Container Service)
- Clusters
- Task Definitions for both microservices
- ECS Services for both microservices

### ✅ Amazon ECR
- `microservice1` and `microservice2` repositories (as data sources)

### ✅ Amazon SQS
- Queue for microservice communication
- IAM policy attachments for SQS access

### ✅ Amazon S3
- S3 bucket to store Microservice 2 output

### ✅ AWS IAM
- Execution roles for ECS tasks
- Role policies for accessing S3, SQS, and SSM

### ✅ AWS SSM Parameter Store
- Secure token storage for Microservice 1

### ✅ Amazon VPC
- VPC with subnets and routing

### ✅ Elastic Load Balancer (ALB)
- ALB for exposing Microservice 1
- Target groups for ECS tasks

### ✅ Security Groups
- ALB and ECS task security groups

### ✅ Terraform Data Sources
- `aws_caller_identity`
- `aws_ecr_repository.service1`
- `aws_ecr_repository.service2`

## Configuration Files

### `test.tfvars`
- Region selection
- Global tags and shared variables

### `local.tf`
- Infrastructure configs like names, CPU, memory, etc.

> ⚠️ Do not modify any code inside the `module` folders.

## Security Considerations
- AWS credentials and tokens are securely stored in GitHub Secrets and SSM
- IAM roles follow least-privilege principle
- Public subnets are used for demonstration only — for production, move sensitive components (like Microservice 2) to private subnets

## Verification & Testing
Once deployed:
- Test Microservice 1 via the ALB endpoint: `https://your-alb-dns-name/api`
- Send a POST request with token and payload
- Verify that Microservice 2 writes the message to the S3 bucket

### 🔬 Example Test Request

Once the infrastructure is up and running, you can test Microservice 1 with the following `curl` command:

```bash
curl -X POST http://<ALB-DNS>/process \
  -H "Content-Type: application/json" \
  -H "Authorization: supersecrettoken123" \
  -d '{"email_timestream": "user@example.com_2025-04-17T12:00:00Z"}'
✅ Replace <ALB-DNS> with the actual DNS name of your Application Load Balancer.

✅ Replace the token with the one stored in your MICROSERVICE_TOKEN secret (if different).
---

