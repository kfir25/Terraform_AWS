variable region {
  type        = string
  default     = "us-east-1"
  description = "region"
}

variable "microservice_token" {
  type      = string
  sensitive = true
  description = "Use github action secret"
}