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

resource "aws_db_instance" "postgresql" {
  allocated_storage                   = 10
  engine                              = "postgres"
  identifier                          = var.database_identifier
  engine_version                      = var.engine_version
  instance_class                      = var.instance_type
  username                            = var.database_username
  password                            = var.database_password
  skip_final_snapshot                 = true
  iam_database_authentication_enabled = true
  vpc_security_group_ids              = [aws_security_group.allow_postgresql.id]
#  provisioner "local-exec" {
#    command = "psql --host=${self.address} --port=${self.port} --username=${self.username} --password=${self.password} postgres < ./create_db.sql"
#  }
}