resource "aws_security_group" "sg_lb" {
  name        = "sg_alb${local.suffix_name}"
  description = "It SG allows access to ALB ${local.suffix_name}"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg_alb${local.suffix_name}"
    Env  = var.env
    App  = var.app_name
  }
}


resource "aws_alb" "alb" {
  name            = "alb${var.app_name}${var.env}"
  subnets = [
      for num in var.public_subnets:
      num.id
  ]
  security_groups = [aws_security_group.sg_lb.id]
  tags = {
    Name = "alb_${local.suffix_name}"
    Env  = var.env
    App  = var.app_name
  }
}

resource "aws_alb_target_group" "app_target" {
  name        = "targetgroup${var.app_name}${var.env}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  stickiness {
    type = "lb_cookie"
    enabled = true
  }
  tags = {
    Name = "app_target_${local.suffix_name}"
    Env  = var.env
    App  = var.app_name
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "app_listener" {
  load_balancer_arn = aws_alb.alb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.app_target.id
    type             = "forward"
  }
  }

