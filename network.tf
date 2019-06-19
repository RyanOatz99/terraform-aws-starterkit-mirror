# -*- coding: utf-8; mode: terraform; -*-

data "aws_availability_zones" "starterkit_availability_zones" {
}

resource "aws_vpc" "starterkit_vpc" {
  cidr_block = var.starterkit_vpc_cidr_block

  tags = {
    Name = "starterkit-vpc"
  }
}

resource "aws_default_network_acl" "starterkit_default_network_acl" {
  default_network_acl_id = aws_vpc.starterkit_vpc.default_network_acl_id

  tags = {
    Name = "starterkit-default-network-acl"
  }

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_default_route_table" "starterkit_default_route_table" {
  default_route_table_id = aws_vpc.starterkit_vpc.default_route_table_id

  tags = {
    Name = "starterkit-default-route-table"
  }
}

resource "aws_internet_gateway" "starterkit_internet_gateway" {
  vpc_id = aws_vpc.starterkit_vpc.id

  tags = {
    Name = "starterkit-internet-gateway"
  }
}

resource "aws_subnet" "starterkit_public_subnet" {
  availability_zone = element(
    data.aws_availability_zones.starterkit_availability_zones.names,
    count.index,
  )
  cidr_block = cidrsubnet(var.starterkit_vpc_cidr_block, 8, count.index + 101)
  count = length(
    data.aws_availability_zones.starterkit_availability_zones.names,
  )
  vpc_id = aws_vpc.starterkit_vpc.id

  tags = {
    Name = "starterkit-public-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "starterkit_public_route_table" {
  vpc_id = aws_vpc.starterkit_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.starterkit_internet_gateway.id
  }

  tags = {
    Name = "starterkit-public-route-table"
  }
}

resource "aws_route_table_association" "starterkit_public_route_table_association" {
  count = length(
    data.aws_availability_zones.starterkit_availability_zones.names,
  )
  route_table_id = aws_route_table.starterkit_public_route_table.id
  subnet_id      = element(aws_subnet.starterkit_public_subnet.*.id, count.index)
}

resource "aws_eip" "starterkit_nat_gateway_eip" {
  vpc = true
}

resource "aws_nat_gateway" "starterkit_nat_gateway" {
  allocation_id = aws_eip.starterkit_nat_gateway_eip.id
  subnet_id     = element(aws_subnet.starterkit_public_subnet.*.id, 0)
}

resource "aws_subnet" "starterkit_private_subnet" {
  availability_zone = element(
    data.aws_availability_zones.starterkit_availability_zones.names,
    count.index,
  )
  cidr_block = cidrsubnet(var.starterkit_vpc_cidr_block, 8, count.index + 201)
  count = length(
    data.aws_availability_zones.starterkit_availability_zones.names,
  )
  vpc_id = aws_vpc.starterkit_vpc.id

  tags = {
    Name = "starterkit-private-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "starterkit_private_route_table" {
  count = length(
    data.aws_availability_zones.starterkit_availability_zones.names,
  )
  vpc_id = aws_vpc.starterkit_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.starterkit_nat_gateway.*.id, count.index)
  }

  tags = {
    Name = "starterkit-private-route-table-${count.index + 1}"
  }
}

resource "aws_route_table_association" "starterkit_private_route_table_association" {
  count = length(
    data.aws_availability_zones.starterkit_availability_zones.names,
  )
  route_table_id = element(
    aws_route_table.starterkit_private_route_table.*.id,
    count.index,
  )
  subnet_id = element(aws_subnet.starterkit_private_subnet.*.id, count.index)
}
