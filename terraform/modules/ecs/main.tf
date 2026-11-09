resource "aws_ecs_cluster" "main" {
  name = "m-motors-cluster"
}

# Task definition for the backend service
resource "aws_ecs_task_definition" "backend" {
  family                   = "m-motors-backend"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.m_motors_ecs_execution_role.arn


  container_definitions = jsonencode([
    {
      name      = "fastapi"
      image     = "${var.ecr_repository_url}:v2"
      essential = true

      portMappings = [
        {
          containerPort = 8000
          protocol      = "tcp"
        }

      ]
      logConfiguration = {
        logDriver = "awslogs"

        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.m_motors_backend.name
          "awslogs-region"        = "eu-west-3"
          "awslogs-stream-prefix" = "fastapi"
        }
      }
    }
  ])
}

# How many instances of the task to run
resource "aws_ecs_service" "backend" {
  name            = "m-motors-backend-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 2
  launch_type     = "FARGATE"

network_configuration {
  subnets          = values(var.private_subnet_app_ids)
  security_groups  = [var.ecs_security_group_id]
  assign_public_ip = false
}

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "fastapi"
    container_port   = 8000
  }

}