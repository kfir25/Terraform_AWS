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

variable "microservice1_image" {
  default = "nginx"
}

variable "microservice2_image" {
  default = "nginx"
}