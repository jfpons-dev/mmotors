data "aws_iam_policy_document" "ecs_trust" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "m_motors_ecs_execution_role" {
  name               = "m-motors-ecs-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_trust.json
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.m_motors_ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}