resource "aws_db_instance" "nubble_rds" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "16.1"
  instance_class       = "db.t3.micro"
  identifier           = var.rds_name
  db_name              = var.rds_database_name
  username             = var.rds_database_db_username
  password             = var.rds_database_db_password
  parameter_group_name = "default.postgres16"
  skip_final_snapshot  = true

  vpc_security_group_ids = [aws_security_group.nubble_rds_security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.private_subnet_group.name
}


resource "aws_security_group" "nubble_rds_security_group" {
  name        = "nubble-rds-sg"
  description = "Allowed access to RDS"
  vpc_id      = aws_vpc.nubble_vpc.id

  ingress {
    description = "Postgress ingress"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
