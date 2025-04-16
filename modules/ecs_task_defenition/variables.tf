
variable "task_name" {
    type = string
}

# variable "account_id" {
#   type = number
# }

variable "cpu" {
  type = number
}

variable "memory" {
  type = number
}

variable "container_name" {}
variable "container_image" {}
variable "container_port" { default = 80 }
variable "log_group_name" {}
variable "aws_region" {}
variable "task_role_arn" {}
variable "execution_role_arn"{}
