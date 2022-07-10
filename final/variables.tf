variable "region" {
  description = "AWS region"
  type        = string
}

variable "ami_id" {
  type    = string
  #  default = "ami-08895422b5f3aa64a" Suse
  default = "ami-0022f774911c1d690"
}
variable "ami_nat_id" {
  type    = string
  default = "ami-003acd4f8da7e06f9" // amzn-ami-vpc-nat-2018.03.0.20220119.1-x86_64-ebs
}

variable "instance_type" {
  type    = string
  #  default = "t2.micro"
  default = "t2.nano"
}
variable "nat_instance_type" {
  type    = string
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
  default     = "10.0.0.0/16"
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

variable "sqs_name" {
  type    = string
  default = "edu-lohika-training-aws-sqs-queue"

}

variable "sns_topic" {
  type    = string
  default = "edu-lohika-training-aws-sns-topic"
}
variable "db_instance_type" {
  default     = "db.t3.micro"
  type        = string
  description = "Instance type for database instance"
}

variable "database_identifier" {
  default     = "edulohikatrainingawsrds"
  type        = string
  description = "Identifier for RDS instance"
}

variable "engine_version" {
  default     = "12.10"
  type        = string
  description = "Database engine version"
}

variable "database_username" {
  type        = string
  description = "Name of user inside storage engine"
  default     = "rootuser"
}

variable "database_password" {
  type        = string
  description = "Database password inside storage engine"
}

variable "dynamo_table_name" {
  type = string
  default = "edu-lohika-training-aws-dynamodb"
}