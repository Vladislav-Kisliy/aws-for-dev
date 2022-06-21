variable "region" {
  description = "AWS region"
  type        = string
}

variable "ami_id" {
  type = string
#  default = "ami-08895422b5f3aa64a" Suse
  default = "ami-0022f774911c1d690"
}
variable "instance_type" {
  type = string
  #  default = "t2.micro"
  default = "t2.nano"
}

variable "ami_key_pair_name" {}

variable "sqs_name" {
  type = string
  default = "5week"
}

variable "sns_name" {
  type = string
  default = "5week"
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
}
