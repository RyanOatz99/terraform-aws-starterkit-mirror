# -*- coding: utf-8; mode: terraform; -*-

resource "aws_route53_zone" "starterkit_route53_zone" {
  name = "${var.starterkit_domain}"

  tags {
    Name = "starterkit-route53-zone"
  }
}

resource "aws_route53_record" "starterkit_route53_record_naked" {
  name    = "${var.starterkit_domain}"
  type    = "A"
  zone_id = "${aws_route53_zone.starterkit_route53_zone.zone_id}"

  alias {
    evaluate_target_health = true
    name                   = "${aws_elb.starterkit_elb.dns_name}"
    zone_id                = "${aws_elb.starterkit_elb.zone_id}"
  }
}

resource "aws_route53_record" "starterkit_route53_record_www" {
  name    = "www.${var.starterkit_domain}"
  records = ["${var.starterkit_domain}"]
  ttl     = "300"
  type    = "CNAME"
  zone_id = "${aws_route53_zone.starterkit_route53_zone.zone_id}"
}

resource "aws_route53_record" "starterkit_route53_certificate_validation_record_naked" {
  name    = "${aws_acm_certificate.starterkit_acm_certificate.domain_validation_options.0.resource_record_name}"
  records = ["${aws_acm_certificate.starterkit_acm_certificate.domain_validation_options.0.resource_record_value}"]
  type    = "${aws_acm_certificate.starterkit_acm_certificate.domain_validation_options.0.resource_record_type}"
  zone_id = "${aws_route53_zone.starterkit_route53_zone.id}"
  ttl     = 60
}

resource "aws_route53_record" "starterkit_route53_certificate_validation_record_www" {
  name    = "${aws_acm_certificate.starterkit_acm_certificate.domain_validation_options.1.resource_record_name}"
  records = ["${aws_acm_certificate.starterkit_acm_certificate.domain_validation_options.1.resource_record_value}"]
  type    = "${aws_acm_certificate.starterkit_acm_certificate.domain_validation_options.1.resource_record_type}"
  zone_id = "${aws_route53_zone.starterkit_route53_zone.id}"
  ttl     = 60
}
