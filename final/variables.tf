variable "region" {
  description = "AWS region"
  type        = string
}

variable "ami_id" {
  type = string
#  default = "ami-08895422b5f3aa64a" Suse
  default = "ami-0022f774911c1d690"
}
variable "ami_nat_id" {
  type = string
  default = "ami-003acd4f8da7e06f9" // amzn-ami-vpc-nat-2018.03.0.20220119.1-x86_64-ebs
}

variable "instance_type" {
  type = string
#  default = "t2.micro"
  default = "t2.nano"
}
variable "nat_instance_type" {
  type = string
  default = "t2.nano"
}

variable "ami_key_pair_name" {}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
  description = "The CIDR block of the vpc"
}

variable "public_subnets_cidr" {
  type        = list
  description = "The CIDR block for the public subnet"
}

variable "private_subnets_cidr" {
  type        = list
  description = "The CIDR block for the private subnet"
}
