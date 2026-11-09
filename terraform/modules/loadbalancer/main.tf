resource "aws_lb_target_group" "app_tg" {
  name = "m-motors-backend-tg"
  port        = 8000
  target_type = "ip" # Fargate tasks use private IP addresses
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  health_check {
    path     = "/"
    port     = "traffic-port"
    protocol = "HTTP"
    matcher  = "200"
  }
}

resource "aws_lb" "main" {
  name               = "m-motors-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = values(var.public_subnet_ids)
}

resource "aws_lb_listener" "app_alb_listener" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80 // HTTP port listener
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}