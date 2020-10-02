resource "aws_subnet" "private_subnets" {
  count             = var.zones_number
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.zones.names[count.index]
  vpc_id            = aws_vpc.vpc.id
  tags = {
    App  = var.app_name
    Name = "private_subnet${local.suffix_name}_${count.index}"
    Env  = var.env
  }
}

resource "aws_subnet" "public_subnets" {
  count                   = var.zones_number
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, var.zones_number + count.index)
  availability_zone       = data.aws_availability_zones.zones.names[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  tags = {
    App  = var.app_name
    Name = "public_subnet${local.suffix_name}_${count.index}"
    Env  = var.env
  }
}
