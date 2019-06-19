# -*- coding: utf-8; mode: terraform; -*-

resource "aws_instance" "starterkit_instance" {
  ami                         = var.starterkit_instance_ami[var.starterkit_region]
  associate_public_ip_address = false
  count = length(
    data.aws_availability_zones.starterkit_availability_zones.names,
  ) * var.starterkit_instances_per_availability_zone
  disable_api_termination = false
  key_name                = var.starterkit_instance_key_name
  instance_type           = var.starterkit_instance_type
  subnet_id               = element(aws_subnet.starterkit_private_subnet.*.id, count.index)

  vpc_security_group_ids = [
    aws_security_group.starterkit_allow_all_outbound_to_everywhere.id,
    aws_security_group.starterkit_allow_etcd_inbound_from_vpc.id,
    aws_security_group.starterkit_allow_ssh_inbound_from_vpc.id,
    aws_security_group.starterkit_allow_web_inbound_from_vpc.id,
  ]

  tags = {
    Name = "starterkit-instance-${count.index + 1}"
  }
}
