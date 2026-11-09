resource "aws_cloudwatch_log_group" "m_motors_backend" {
  name              = "/ecs/m-motors-backend"
  retention_in_days = 7
}