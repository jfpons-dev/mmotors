resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
for_each = var.public_subnets
cidr_block = each.value.cidr
availability_zone = "${var.region}${each.value.az}"
vpc_id = aws_vpc.main.id
tags = {
    Name = each.key
  }
}

resource "aws_subnet" "private_app" {
for_each = var.private_subnets_app
cidr_block = each.value.cidr
availability_zone = "${var.region}${each.value.az}"
vpc_id = aws_vpc.main.id
tags = {
    Name = each.key
  }
}

resource "aws_subnet" "private_db" {
for_each = var.private_subnets_db
cidr_block = each.value.cidr
availability_zone = "${var.region}${each.value.az}"
vpc_id = aws_vpc.main.id
tags = {
    Name = each.key
  }
}

# Use for_each to allow additional development subnets if needed
resource "aws_subnet" "private_dev" {
for_each = var.private_subnets_dev 
cidr_block = each.value.cidr
availability_zone = "${var.region}${each.value.az}"
vpc_id = aws_vpc.main.id
tags = {
    Name = each.key
  }
}