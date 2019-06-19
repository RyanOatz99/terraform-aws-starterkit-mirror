# _*_ coding: utf_8; mode: terraform; _*_

resource "aws_db_subnet_group" "starterkit_database_subnet_group" {
  name = "starterkit-database-subnet-group"

  subnet_ids = aws_subnet.starterkit_private_subnet.*.id

  tags = {
    Name = "starterkit-database-subnet-group"
  }
}

resource "aws_db_instance" "starterkit_database_instance" {
  engine         = "postgres"
  engine_version = "10"

  db_subnet_group_name = aws_db_subnet_group.starterkit_database_subnet_group.id

  allocated_storage         = var.starterkit_database_instance["allocated_storage"]
  deletion_protection       = var.starterkit_database_instance["deletion_protection"]
  final_snapshot_identifier = var.starterkit_database_instance["final_snapshot_identifier"]
  identifier                = var.starterkit_database_instance["identifier"]
  instance_class            = var.starterkit_database_instance["instance_class"]
  storage_encrypted         = var.starterkit_database_instance["storage_encrypted"]

  username = var.starterkit_database_username
  password = var.starterkit_database_password
  port     = var.starterkit_database_tcp_port

  vpc_security_group_ids = [
    aws_security_group.starterkit_allow_all_outbound_to_vpc.id,
    aws_security_group.starterkit_allow_database_inbound_from_vpc.id,
  ]

  tags = {
    Name = "starterkit-database-instance"
  }
}
