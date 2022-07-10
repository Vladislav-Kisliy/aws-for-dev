resource "aws_instance" "bastion" {
  ami                    = "${var.ami_nat_id}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.ami_key_pair_name}"
  vpc_security_group_ids = [aws_security_group.public_sec_group.id]
  subnet_id              = aws_subnet.public_subnet[0].id
  source_dest_check      = false

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.id
  #  user_data            = "${file("webnode-init.sh")}"

  tags = {
    Name = "bastion"
  }
}

#resource "aws_instance" "private_web_instance" {
#  ami                    = "${var.ami_id}"
#  instance_type          = "${var.instance_type}"
#  key_name               = "${var.ami_key_pair_name}"
#  vpc_security_group_ids = [aws_security_group.service_sec_group.id]
#  subnet_id              = aws_subnet.private_subnet[0].id
#
#  iam_instance_profile = aws_iam_instance_profile.ec2_profile.id
#  #  user_data            = "${file("webnode-init.sh")}"
#
#  tags = {
#    Name = "private-web"
#  }
#}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "some_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role" "ec2_role" {
  name = "my_role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Sid       = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "my_queue_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.sqs_policy.arn
}

resource "aws_iam_role_policy_attachment" "my_sns_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.sns_policy.arn
}