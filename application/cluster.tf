resource "aws_ecs_cluster" "cluster" {
  name = "cluster${local.suffix_name}"
  tags = {
    Name = "cluster${local.suffix_name}"
    Env  = var.env
    App  = var.app_name
  }
}
