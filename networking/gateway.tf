resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    App  = var.app_name
    Name = "internet_gw${local.suffix_name}"
    Env  = var.env
  }
}

resource "aws_route" "internet_route" {
  route_table_id         = aws_vpc.vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gw.id
}

resource "aws_eip" "nat_ip" {
  count      = var.zones_number
  vpc        = true
  depends_on = [aws_internet_gateway.internet_gw]
  tags = {
    App  = var.app_name
    Name = "nat_ip${local.suffix_name}"
    Env  = var.env
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.zones_number
  subnet_id     = element(aws_subnet.public_subnets.*.id, count.index)
  allocation_id = element(aws_eip.nat_ip.*.id, count.index)
  tags = {
    App  = var.app_name
    Name = "nat_gateway${local.suffix_name}"
    Env  = var.env
  }
}

resource "aws_route_table" "private_route_table" {
  count  = var.zones_number
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat_gateway.*.id, count.index)
  }
  tags = {
    App  = var.app_name
    Name = "private_route_table${local.suffix_name}"
    Env  = var.env
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = var.zones_number
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.private_route_table.*.id, count.index)
}
