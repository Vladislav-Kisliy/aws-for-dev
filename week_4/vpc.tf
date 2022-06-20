resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = {
    Name = "w4-vpc"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags   = {
    Name = "w4-igw"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = "${aws_vpc.vpc.id}"
  count      = "${length(var.public_subnets_cidr)}"
  cidr_block = "${element(var.public_subnets_cidr, count.index)}"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags                    = {
    Name = "w4-public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  count                   = "${length(var.private_subnets_cidr)}"
  cidr_block              = "${element(var.private_subnets_cidr, count.index)}"
  map_public_ip_on_launch = false
  availability_zone = "us-east-1b"

  tags                    = {
    Name = "w4-private-subnet"
  }
}

resource "aws_route_table" "private_main" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags   = {
    Name = "w4-private-route-table"
  }
}
resource "aws_route_table" "private_route_table" {
  vpc_id     = aws_vpc.vpc.id
  depends_on = [
    aws_vpc.vpc,
    aws_network_interface.network_interface,
    aws_instance.public_nat_instance
  ]
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_network_interface.network_interface.id
  }
  route {
    ipv6_cidr_block      = "::/0"
    network_interface_id = aws_network_interface.network_interface.id
  }
}

resource "aws_main_route_table_association" "private_route_table_main" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.private_main.id
}

resource "aws_route_table_association" "private_route_table_association" {
  subnet_id      = aws_subnet.private_subnet[0].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block             = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.ig.id
  }
  tags   = {
    Name = "w4-public-route-table"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.ig.id}"
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_network_interface" "network_interface" {
  subnet_id         = aws_subnet.public_subnet[0].id
  source_dest_check = false
  security_groups   = [aws_security_group.public_nat_group.id]

  tags = {
    Name = "nat_instance_network_interface"
  }
}