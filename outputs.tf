# -*- coding: utf-8; mode: terraform; -*-

output "starterkit_bastion_public_ip_address" {
  value = aws_instance.starterkit_bastion[0].public_ip
}

output "starterkit_instance_private_ip_addresses" {
  value = join(", ", aws_instance.starterkit_instance.*.private_ip)
}

output "starterkit_route53_zone_nameservers" {
  value = join(", ", aws_route53_zone.starterkit_route53_zone.name_servers)
}

output "starterkit_database_hostname" {
  value = aws_db_instance.starterkit_database_instance.address
}
