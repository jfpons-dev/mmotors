resource "aws_security_group" "alb" {
  name        = "SG-ALB"
  description = "Security group for the ALB"
  vpc_id      = var.vpc_id

  tags = {
    Name = "SG-ALB"
  }

}

resource "aws_security_group" "ecs" {
  name        = "SG-ECS"
  description = "Security group for the application"
  vpc_id      = var.vpc_id

  tags = {
    Name = "SG-ECS"
  }
}

resource "aws_security_group" "rds" {
  name        = "SG-RDS"
  description = "Security group for the RDS"
  vpc_id      = var.vpc_id

  tags = {
    Name = "SG-RDS"
  }
}


# No ingress rule is required because DEV workstations are administered through SSM.
resource "aws_security_group" "dev" {
  name        = "SG-DEV"
  description = "Security group for the DEV workstations"
  vpc_id      = var.vpc_id

  tags = {
    Name = "SG-DEV"
  }
}
