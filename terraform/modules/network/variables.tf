variable "region" {
  type        = string
  description = "The region to deploy the resources"
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC"
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "public_subnets" {
  type        = map(object({
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
  description = "The CIDR blocks for the private application subnets"
}

variable "private_subnets_db" {
  type = map(object({
    cidr = string
    az   = string 
  }))
  description = "The CIDR blocks for the private database subnets"
}

variable "private_subnets_dev" {
  type = map(object({
    cidr = string
    az   = string
  }))
  description = "The CIDR blocks for the private development subnets"
}