resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = {
    Name = "project-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = "${aws_vpc.vpc.id}"
  count      = "${length(var.public_subnets_cidr)}"
  cidr_block = "${element(var.public_subnets_cidr, count.index)}"
  map_public_ip_on_launch = true

  tags                    = {
    Name = "project-public-subnet"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags   = {
    Name = "project-igw"
  }
}

resource "aws_route_table" "public_routes" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block             = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.ig.id
  }
  tags   = {
    Name = "project-public-route-table"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public_routes.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.ig.id}"
}

resource "aws_route_table_association" "public_route_associat" {
  count          = "${length(var.public_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_routes.id}"
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  count                   = "${length(var.private_subnets_cidr)}"
  cidr_block              = "${element(var.private_subnets_cidr, count.index)}"
  map_public_ip_on_launch = false

  tags                    = {
    Name = "service-private-subnet"
  }
}

resource "aws_route_table" "private_routes" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags   = {
    Name = "service-private-route-table"
  }
}
resource "aws_route_table" "private_route_table" {
  vpc_id     = aws_vpc.vpc.id
  depends_on = [
    aws_vpc.vpc,
    aws_instance.bastion
  ]
  route {
    cidr_block           = "0.0.0.0/0"
    instance_id = aws_instance.bastion.id
#    network_interface_id = aws_instance.bastion.network_interface[0].id
#    network_interface_id = aws_network_interface.network_interface.id
  }
  route {
    ipv6_cidr_block      = "::/0"
    instance_id = aws_instance.bastion.id
#    network_interface_id = aws_instance.bastion.network_interface[0].id
#    network_interface_id = aws_network_interface.network_interface.id
  }
}

#resource "aws_main_route_table_association" "private_route_table_main" {
#  vpc_id         = aws_vpc.vpc.id
#  route_table_id = aws_route_table.private_routes.id
#}

resource "aws_route_table_association" "private_route_associat" {
  subnet_id      = aws_subnet.private_subnet[0].id
  route_table_id = aws_route_table.private_route_table.id
}