variable "region" {
  type        = string
  description = "The region to deploy the resources"
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "vpc_name" {
  type        = string
  description = "The name for the VPC"
}