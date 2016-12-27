# -*- coding: utf-8; mode: terraform; -*-

resource "aws_acm_certificate" "starterkit_acm_certificate" {
  domain_name               = "${var.starterkit_domain}"
  subject_alternative_names = ["www.${var.starterkit_domain}"]
  validation_method         = "DNS"
}

resource "aws_acm_certificate_validation" "starterkit_acm_certificate_validation" {
  certificate_arn = "${aws_acm_certificate.starterkit_acm_certificate.arn}"

  validation_record_fqdns = [
    "${aws_route53_record.starterkit_route53_certificate_validation_record_naked.fqdn}",
    "${aws_route53_record.starterkit_route53_certificate_validation_record_www.fqdn}",
  ]
}
