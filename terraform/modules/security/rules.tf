resource "aws_vpc_security_group_ingress_rule" "ingress_rule_443_alb_https" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow public HTTPS traffic to the ALB"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "egress_rule_alb_to_ecs" {
  security_group_id            = aws_security_group.alb.id
  description                  = "Allow the ALB to reach ECS tasks"
  from_port                    = 8000
  to_port                      = 8000
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.ecs.id
}


resource "aws_vpc_security_group_ingress_rule" "ingress_rule_ecs_from_alb" {
  security_group_id            = aws_security_group.ecs.id
  description                  = "Allow application traffic from the ALB"
  from_port                    = 8000
  to_port                      = 8000
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_vpc_security_group_egress_rule" "egress_rule_ecs_https" {
  security_group_id = aws_security_group.ecs.id
  description       = "Allow outbound HTTPS traffic for application and AWS services"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "egress_rule_ecs_to_rds" {
  security_group_id            = aws_security_group.ecs.id
  description                  = "Allow ECS tasks to reach PostgreSQL"
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.rds.id
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rule_rds_from_ecs" {
  security_group_id            = aws_security_group.rds.id
  description                  = "Allow PostgreSQL traffic from ECS tasks"
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.ecs.id
}


resource "aws_vpc_security_group_egress_rule" "egress_rule_dev_to_https" {
  security_group_id = aws_security_group.dev.id
  description       = "Allow development traffic to HTTPS"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}