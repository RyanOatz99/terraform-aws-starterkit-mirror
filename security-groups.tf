# _*_ coding: utf_8; mode: terraform; _*_

resource "aws_default_security_group" "starterkit_default_security_group" {
  vpc_id = aws_vpc.starterkit_vpc.id

  tags = {
    Name = "starterkit-default-security-group"
  }
}

resource "aws_security_group" "starterkit_allow_all_outbound_to_everywhere" {
  name   = "starterkit-allow-all-outbound-to-everywhere"
  vpc_id = aws_vpc.starterkit_vpc.id

  egress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags = {
    Name = "starterkit-allow-all-outbound-to-everywhere"
  }
}

resource "aws_security_group" "starterkit_allow_all_outbound_to_vpc" {
  name   = "starterkit-allow-all-outbound-to-vpc"
  vpc_id = aws_vpc.starterkit_vpc.id

  egress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"

    cidr_blocks = [
      aws_vpc.starterkit_vpc.cidr_block,
    ]
  }

  tags = {
    Name = "starterkit-allow-all-outbound-to-vpc"
  }
}

resource "aws_security_group" "starterkit_allow_web_inbound_from_everywhere" {
  name   = "starterkit-allow-web-inbound-from-everywhere"
  vpc_id = aws_vpc.starterkit_vpc.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags = {
    Name = "starterkit-allow-web-inbound-from-everywhere"
  }
}

resource "aws_security_group" "starterkit_allow_ssh_inbound_from_everywhere" {
  name   = "starterkit-allow-ssh-inbound-from-everywhere"
  vpc_id = aws_vpc.starterkit_vpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags = {
    Name = "starterkit-allow-ssh-inbound-from-everywhere"
  }
}

resource "aws_security_group" "starterkit_allow_web_inbound_from_vpc" {
  name   = "starterkit-allow-web-inbound-from-vpc"
  vpc_id = aws_vpc.starterkit_vpc.id

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"

    cidr_blocks = [
      aws_vpc.starterkit_vpc.cidr_block,
    ]
  }

  ingress {
    from_port = 8443
    to_port   = 8443
    protocol  = "tcp"

    cidr_blocks = [
      aws_vpc.starterkit_vpc.cidr_block,
    ]
  }

  tags = {
    Name = "starterkit-allow-web-inbound-from-vpc"
  }
}

resource "aws_security_group" "starterkit_allow_database_inbound_from_vpc" {
  name   = "starterkit-allow-database-inbound-from-vpc"
  vpc_id = aws_vpc.starterkit_vpc.id

  ingress {
    from_port = var.starterkit_database_tcp_port
    to_port   = var.starterkit_database_tcp_port
    protocol  = "tcp"

    cidr_blocks = [
      aws_vpc.starterkit_vpc.cidr_block,
    ]
  }

  tags = {
    Name = "starterkit-allow-database-inbound-from-vpc"
  }
}

resource "aws_security_group" "starterkit_allow_etcd_inbound_from_vpc" {
  name   = "starterkit-allow-etcd-inbound-from-vpc"
  vpc_id = aws_vpc.starterkit_vpc.id

  ingress {
    from_port = 2379
    to_port   = 2380
    protocol  = "tcp"

    cidr_blocks = [
      aws_vpc.starterkit_vpc.cidr_block,
    ]
  }

  tags = {
    Name = "starterkit-allow-etcd-inbound-from-vpc"
  }
}

resource "aws_security_group" "starterkit_allow_ssh_inbound_from_vpc" {
  name   = "starterkit-allow-ssh-inbound-from-vpc"
  vpc_id = aws_vpc.starterkit_vpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      aws_vpc.starterkit_vpc.cidr_block,
    ]
  }

  tags = {
    Name = "starterkit-allow-ssh-inbound-from-vpc"
  }
}
