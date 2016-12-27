# -*- coding: utf-8; mode: terraform; -*-

resource "aws_elb" "starterkit_elb" {
  name = "starterkit-elb"

  subnets = [
    "${aws_subnet.starterkit_public_subnet.*.id}",
  ]

  security_groups = [
    "${aws_security_group.starterkit_allow_all_outbound_to_everywhere.id}",
    "${aws_security_group.starterkit_allow_web_inbound_from_everywhere.id}",
  ]

  instances = [
    "${aws_instance.starterkit_instance.*.id}",
  ]

  listener {
    instance_port      = 8443
    instance_protocol  = "https"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${aws_acm_certificate.starterkit_acm_certificate.arn}"
  }

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 2
    interval            = 5
    target              = "SSL:8443" # TODO: "HTTP:8443/healthcheck"
    timeout             = 2
  }

  tags {
    Name = "starterkit-elb"
  }
}
