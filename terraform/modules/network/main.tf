resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
  for_each          = var.public_subnets
  cidr_block        = each.value.cidr
  availability_zone = "${var.region}${each.value.az}"
  vpc_id            = aws_vpc.main.id
  tags = {
    Name = each.key
  }
}

resource "aws_subnet" "private_app" {
  for_each          = var.private_subnets_app
  cidr_block        = each.value.cidr
  availability_zone = "${var.region}${each.value.az}"
  vpc_id            = aws_vpc.main.id
  tags = {
    Name = each.key
  }
}


resource "aws_subnet" "private_db" {
  for_each          = var.private_subnets_db
  cidr_block        = each.value.cidr
  availability_zone = "${var.region}${each.value.az}"
  vpc_id            = aws_vpc.main.id
  tags = {
    Name = each.key
  }
}

# Use for_each to allow additional development subnets if needed
resource "aws_subnet" "private_dev" {
  for_each          = var.private_subnets_dev
  cidr_block        = each.value.cidr
  availability_zone = "${var.region}${each.value.az}"
  vpc_id            = aws_vpc.main.id
  tags = {
    Name = each.key
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "mmotors-prod-vpc-igw"
  }
}

# Elastic IP for Nat Gateway
resource "aws_eip" "nat_eip" {
  for_each = var.public_subnets
  domain   = "vpc"
  tags = {
    Name = "mmotors-prod-vpc-${each.key}-nat-eip"
  }
}

# Nat Gateway
resource "aws_nat_gateway" "nat_gateway" {
  for_each      = var.public_subnets
  allocation_id = aws_eip.nat_eip[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  depends_on = [aws_internet_gateway.main] // ensure the NAT gateway is created after the internet gateway

  tags = {
    Name = "mmotors-prod-vpc-${each.key}-nat-gateway"
  }
}


# Public Route Table

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "mmotors-prod-vpc-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Private Route Tables for App Subnets.
resource "aws_route_table" "private_app" {
  for_each = var.private_subnets_app
  vpc_id   = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway["public-${each.value.az}"].id
  }
  tags = {
    Name = "mmotors-prod-vpc-${each.key}-private-app-rt"
  }
}

resource "aws_route_table_association" "private_app" {
  for_each       = aws_subnet.private_app
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_app[each.key].id
}

# Private Route Table for DB Subnets, only one route table for all DB subnets
resource "aws_route_table" "private_db" {

  vpc_id = aws_vpc.main.id
  tags = {
    Name = "mmotors-prod-vpc-private-db-rt"
  }
}

resource "aws_route_table_association" "private_db" {
  for_each       = aws_subnet.private_db
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_db.id
}

# Dedicated route table to allow independent routing changes
# for developer workstations without impacting application subnets
resource "aws_route_table" "private_dev" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway["public-a"].id
  }
  tags = {
    Name = "mmotors-prod-vpc-private-dev-rt"
  }
}

resource "aws_route_table_association" "private_dev" {
  subnet_id      = aws_subnet.private_dev["dev-a"].id
  route_table_id = aws_route_table.private_dev.id
}

# Gateway Endpoint for private access to Amazon S3
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  # Add the route table ids for the private app and development subnets, loop is used to be scalable for future subnets.
  route_table_ids = concat(
    [for rt in aws_route_table.private_app : rt.id],
    [aws_route_table.private_dev.id]
  )
  tags = {
    Name = "mmotors-prod-vpc-s3-endpoint"
  }

}