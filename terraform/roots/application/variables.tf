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

# Public subnet configuration: CIDR blocks and availability zone suffixes (a, b)
variable "public_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
  description = "The CIDR blocks for the public subnets"
}

variable "private_subnets_app" {
  type = map(object({
    cidr = string
    az   = string
  }))
  description = "The CIDR blocks for the private subnets"
}

variable "private_subnets_db" {
  type = map(object({
    cidr = string
    az   = string
  }))
  description = "The CIDR blocks for the private subnets"
}


variable "private_subnets_dev" {
  type = map(object({
    cidr = string
    az   = string
  }))
  description = "The CIDR blocks for the private development subnets"
}