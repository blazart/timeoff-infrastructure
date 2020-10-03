resource "aws_ecr_repository" "repository" {
  name = "${var.env}/${var.app_name}"
  tags = {
    Name = "ecr_${local.suffix_name}"
    Env  = var.env
    App  = var.app_name
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name  = "/ecs/${local.suffix_name}"
  tags = {
    Name = "ecs_${local.suffix_name}"
    Env  = var.env
    App  = var.app_name
  }
}

resource "aws_ecs_task_definition" "app_task_definition" {
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  family                   = local.suffix_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.app_cpu
  memory                   = var.app_memory
  tags = {
    Name = "task_definition_${local.suffix_name}"
    Env  = var.env
    App  = var.app_name
  }
  container_definitions = <<DEFINITION
[
  {
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": null,
      "options": {
        "awslogs-group": "/ecs/${local.suffix_name}",
        "awslogs-region": "${var.region}",
        "awslogs-stream-prefix": "${var.app_name}"
      }
    },
    "cpu": ${var.app_cpu},
    "image": "${aws_ecr_repository.repository.repository_url}",
    "memory": ${var.app_memory},
    "name": "${var.app_name}",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${var.app_port},
        "hostPort": ${var.app_port}
      }
    ]
  }
]
DEFINITION
}


# Traffic to the ECS Cluster should only come from the ALB
resource "aws_security_group" "sg_app" {
  name        = "sg_app_${local.suffix_name}"
  description = "It controls access to application"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = [aws_security_group.sg_lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg_app_${local.suffix_name}"
    Env  = var.env
    App  = var.app_name
  }
}

resource "aws_ecs_service" "main" {
  name            = "time_off_service${local.suffix_name}"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.app_task_definition.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.sg_app.id]
    subnets = [
    for num in var.private_subnets:
    num.id
    ]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app_target.id
    container_name   = var.app_name
    container_port   = var.app_port
  }

  depends_on = [
    aws_alb_listener.app_listener,
  ]
}
