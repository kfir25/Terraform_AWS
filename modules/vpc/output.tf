
output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(aws_vpc.main_vpc.id, null)
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = try(aws_vpc.main_vpc.arn, null)
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(aws_vpc.main_vpc.cidr_block, null)
}


output "aws_internet_gateway" {
  value =  aws_internet_gateway.gw.id
}