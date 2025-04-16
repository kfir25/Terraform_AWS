
variable "alb_name" {
  
}

variable "internal" {
  default = false
}

variable "load_balancer_type" {
  default = "application"
}

variable "tags" {
  type = map(any)
  default = {}
}

variable "public_subnets_ids" {
  
}

variable "target_group_arn" {
  
}

variable "security_groups" {
  
}