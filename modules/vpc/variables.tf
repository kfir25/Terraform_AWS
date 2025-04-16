variable "subnets" {
  type = map(any)
}

variable "routes" {
  type = map(any)
}
variable vpc_cidr_block {
  type        = string
}


variable "vpc_tags" {
  type = map(any)
}