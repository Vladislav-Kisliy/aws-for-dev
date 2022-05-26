provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

#resource "aws_instance" "test_ec2_instance" {
#  ami           = "${var.ami_id}"
#  instance_type = "t2.micro"
#  key_name      = "${var.ami_key_pair_name}"
##  user_data     = file("${path.module}/startup.sh")
#  tags = {
#    Name = "test_instance"
#  }
#}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = "ami-0022f774911c1d690"
#  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
#  key_name      = "${var.ami_key_pair_name}"

  tags = {
    Name = "HelloWorld"
  }
}