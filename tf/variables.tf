variable "region" {
  description = "AWS region"
  type        = string
}

variable "ami_id" {
  type = string
  default = "ami-08895422b5f3aa64a"
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
