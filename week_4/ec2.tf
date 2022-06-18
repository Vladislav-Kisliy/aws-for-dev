#resource "aws_instance" "public_web_instance" {
#  ami                    = "${var.ami_id}"
#  instance_type          = "${var.instance_type}"
#  key_name               = "${var.ami_key_pair_name}"
#  vpc_security_group_ids = [aws_security_group.public_sec_group.id]
#  subnet_id              = aws_subnet.public_subnet[0].id
#
#  iam_instance_profile = aws_iam_instance_profile.some_profile.id
#
#  tags = {
#    Name = "w4-public-web"
#  }
#}

resource "aws_instance" "public_nat_instance" {
  ami           = "${var.ami_nat_id}"
  instance_type = "${var.nat_instance_type}"
  key_name      = "${var.ami_key_pair_name}"
  network_interface {
    network_interface_id = aws_network_interface.network_interface.id
    device_index         = 0
  }
  iam_instance_profile = aws_iam_instance_profile.some_profile.id
  tags = {
    Name = "w4-public-nat"
  }
}

resource "aws_instance" "private_web_instance" {
  ami                    = "${var.ami_id}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.ami_key_pair_name}"
  vpc_security_group_ids = [aws_security_group.private_sec_group.id]
  subnet_id              = aws_subnet.private_subnet[0].id

  iam_instance_profile = aws_iam_instance_profile.some_profile.id
  tags                 = {
    Name = "w4-private-web"
  }
}

