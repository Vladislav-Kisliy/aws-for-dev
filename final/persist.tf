resource "aws_sns_topic" "sns_topic" {
  name = "${var.sns_topic}"
  tags = {
    Name = "${var.sns_topic}"
  }
}

resource "aws_sqs_queue" "sqs_queue" {
  name = "${var.sqs_name}"
  tags = {
    Name = "${var.sqs_name}"
  }
}
resource "aws_db_instance" "postgresql" {
  allocated_storage                   = 10
  engine                              = "postgres"
  identifier                          = var.database_identifier
  engine_version                      = var.engine_version
  instance_class                      = var.db_instance_type
  username                            = var.database_username
  password                            = var.database_password
  skip_final_snapshot                 = true
  iam_database_authentication_enabled = true
  vpc_security_group_ids              = [aws_security_group.allow_postgresql.id]
  #  provisioner "local-exec" {
  #    command = "psql --host=${self.address} --port=${self.port} --username=${self.username} --password=${self.password} postgres < ./create_db.sql"
  #  }
}

resource "aws_dynamodb_table" "dynamodb_table" {
  name           = "${var.dynamo_table_name}"
  billing_mode   = "PROVISIONED"
  read_capacity  = "1"
  write_capacity = "1"
  hash_key       = "UserName"
  attribute {
    name = "UserName"
    type = "S"
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

resource "aws_security_group" "allow_postgresql" {
  name        = "main_rds_sg"
  description = "Allow postgresl inbound traffic"
  ingress {
    from_port   = 5432
    protocol    = "tcp"
    to_port     = 5432
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_postgresql"
  }
}

resource "aws_iam_policy" "dynamodb_table_policy" {
  name        = "dynamodb_table"
  path        = "/"
  description = "Allow "

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "ListAndDescribe",
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:List*",
          "dynamodb:DescribeReservedCapacity*",
          "dynamodb:DescribeLimits",
          "dynamodb:DescribeTimeToLive"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "SpecificTable",
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:BatchGet*",
          "dynamodb:DescribeStream",
          "dynamodb:DescribeTable",
          "dynamodb:Get*",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchWrite*",
          "dynamodb:CreateTable",
          "dynamodb:Delete*",
          "dynamodb:Update*",
          "dynamodb:PutItem"
        ],
        "Resource" : "arn:aws:dynamodb:*:*:table/${var.dynamo_table_name}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "some_dynamodb_table" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.dynamodb_table_policy.arn
}