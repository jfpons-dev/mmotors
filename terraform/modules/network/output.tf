output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = { for key, value in aws_subnet.public : key => value.id }
}

output "private_subnet_app_ids" {
  value = { for key, value in aws_subnet.private_app : key => value.id }
}

output "private_subnet_db_ids" {
  value = { for key, value in aws_subnet.private_db : key => value.id }
}

output "private_subnet_dev_ids" {
  value = { for key, value in aws_subnet.private_dev : key => value.id }
}

output "s3_endpoint_id" {
  value = aws_vpc_endpoint.s3.id
}