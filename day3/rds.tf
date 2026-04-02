# ─── RDS SECURITY GROUP ──────────────────────────────────────────────
resource "aws_security_group" "rds_sg" {
  name        = "day3-rds-sg"
  description = "Allow MySQL from private subnets only"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.11.0/24", "10.0.12.0/24"] # Private subnets only
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "day3-rds-sg" }
}

# ─── RDS SUBNET GROUP ────────────────────────────────────────────────
resource "aws_db_subnet_group" "main" {
  name       = "day3-rds-subnet-group"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]

  tags = { Name = "day3-rds-subnet-group" }
}

# ─── RDS INSTANCE ────────────────────────────────────────────────────
resource "aws_db_instance" "mysql" {
  identifier             = "day3-mysql"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_encrypted      = true
  db_name                = "appdb"
  username               = var.db_username
  password               = var.db_password # Passed via TF_VAR_db_password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true  # Set false in prod
  multi_az               = false # Set true in prod
  publicly_accessible    = false # Always false — DB in private subnet

  tags = { Name = "day3-mysql" }
}
