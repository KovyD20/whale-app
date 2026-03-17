resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_a_association" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_b_association" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_c_association" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public_rt.id
}

#NAT Gateway
resource "aws_eip" "nat_eip" {}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_a.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "nat_gateway_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

resource "aws_route_table_association" "private_server_a_association" {
  subnet_id      = aws_subnet.server_a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_server_b_association" {
  subnet_id      = aws_subnet.server_b.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_server_c_association" {
  subnet_id      = aws_subnet.server_c.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_db_a_association" {
  subnet_id      = aws_subnet.database_a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_db_b_association" {
  subnet_id      = aws_subnet.database_b.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_db_c_association" {
  subnet_id      = aws_subnet.database_c.id
  route_table_id = aws_route_table.private_rt.id
}