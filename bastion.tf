# -*- coding: utf-8; mode: terraform; -*-

resource "aws_instance" "starterkit_bastion" {
  ami                         = "${var.starterkit_bastion_ami[var.starterkit_region]}"
  associate_public_ip_address = true
  count                       = 1
  disable_api_termination     = false
  key_name                    = "${var.starterkit_bastion_key_name}"
  instance_type               = "${var.starterkit_bastion_type}"
  subnet_id                   = "${element(aws_subnet.starterkit_public_subnet.*.id, count.index)}"

  vpc_security_group_ids = [
    "${aws_security_group.starterkit_allow_all_outbound_to_everywhere.id}",
    "${aws_security_group.starterkit_allow_ssh_inbound_from_everywhere.id}",
  ]

  tags {
    Name = "starterkit-bastion-${count.index + 1}"
  }
}
