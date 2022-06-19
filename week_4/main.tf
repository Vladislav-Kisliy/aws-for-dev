provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_security_group" "public_sec_group" {
  name        = "public_sec_group"
  description = "Public security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_ssh_web"
  }
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

resource "aws_iam_role_policy_attachment" "cloud_watch_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "some_profile" {
  name = "some_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_security_group" "public_nat_group" {
  name        = "public_nat_group"
  description = "Public security group to allow connections to NAT instance"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_ssh_ping"
  }
}

resource "aws_security_group" "private_sec_group" {
  name        = "private_sec_group"
  description = "Private security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8
    protocol    = "icmp"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_ssh_web_ping"
  }
}