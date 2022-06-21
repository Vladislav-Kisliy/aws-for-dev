provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_sns_topic" "sns_topic" {
  name = "${var.sns_name}"
  tags = {
    Name = "week5"
  }
}

resource "aws_sqs_queue" "sqs_queue" {
  name = "${var.sqs_name}"
  tags = {
    Name = "week5"
  }
}

resource "aws_iam_policy" "sqs_policy" {
  name        = "sqs_policy"
  path        = "/"
  description = "Allow "

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "sqs:GetQueueUrl",
          "sqs:ReceiveMessage",
          "sqs:SendMessage"
        ],
        "Resource" : [
          aws_sqs_queue.sqs_queue.arn
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "sns_policy" {
  name        = "sns_policy"
  path        = "/"
  description = "Allow "

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "sns:Publish"
        ],
        "Resource" : [
          aws_sns_topic.sns_topic.arn
        ]
      }
    ]
  })
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

  #  inline_policy {
  #    name   = "allow-access-to-s3-sqs"
  #    policy = data.aws_iam_policy_document.policy_document.json
  #  }
}

resource "aws_security_group" "allow_ssh_web" {
  name = "ssh_web"
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

resource "aws_iam_role_policy_attachment" "my_queue_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.sqs_policy.arn
}

resource "aws_iam_role_policy_attachment" "my_sns_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.sns_policy.arn
}

resource "aws_iam_role_policy_attachment" "cloud_watch_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "some_profile" {
  name = "some_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "web_instances" {
  ami                    = "${var.ami_id}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.ami_key_pair_name}"
  vpc_security_group_ids = [aws_security_group.allow_ssh_web.id]

  iam_instance_profile = aws_iam_instance_profile.some_profile.id
  #  user_data            = file("startup.sh")
  tags                 = {
    Name = "Week5Node"
  }
}