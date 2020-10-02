data "aws_availability_zones" "zones" {}

resource "aws_vpc" "vpc" {
  tags = {
    Name = "vpc${local.suffix_name}"
    Env  = var.env
    App  = var.app_name
  }
  cidr_block = "10.77.0.0/16"
}

