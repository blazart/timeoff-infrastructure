resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "app_execution_role${local.suffix_name}"
  tags = {
    Name = "app_execution_role${local.suffix_name}"
    Env  = var.env
    App  = var.app_name
  }
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "task_execution_role_attach_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
