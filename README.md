[![build status](https://gitlab.com/tvaughan/terraform-aws-starterkit/badges/master/build.svg)](https://gitlab.com/tvaughan/terraform-aws-starterkit/commits/master)

Terraform AWS StarterKit
===

Quick Start
---

* Purchase a domain name somewhere.

* Download and install [Docker](https://www.docker.com).

* Go to https://console.aws.amazon.com/iam/home?region=us-west-2#/users and
  create an IAM user with the `AWSCertificateManagerFullAccess`,
  `AmazonEC2FullAccess`, `AmazonRoute53DomainsFullAccess`, and
  `AmazonRoute53FullAccess` permissions.

* Go to
  https://us-west-2.console.aws.amazon.com/ec2/v2/home?region=us-west-2#KeyPairs:sort=keyName
  and create two key pairs, one each for the instances and bastion. These are
  assumed to be called `starterkit-instance` and `starterkit-bastion`.

* Set some environment variables. For example:

        AWS_ACCESS_KEY_ID="IAKA..."
        AWS_SECRET_ACCESS_KEY="PkZ0..."
        STARTERKIT_DATABASE_USERNAME="username"
        STARTERKIT_DATABASE_PASSWORD="password"
        STARTERKIT_DATABASE_TCP_PORT="5432"
        STARTERKIT_DOMAIN="starterkit.xyz"
        STARTERKIT_REGION="us-west-2"

* `make create-nameservers`

    This creates a [Route53 hosted zone](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html).
    [DNS is used to validate ownership](https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-validate-dns.html)
    of `$STARTERKIT_DOMAIN`.

* `make show-outputs`

    Replace the name servers held by the registrar of `$STARTERKIT_DOMAIN`
    with the Route53 name servers listed by this command.

    Allow enough time (possibly as much as 24 hours) for the DNS records to
    propagate before continuing.

* `make`

    Carefully review the plan. Press `Y + <return>` to apply the plan. Press
    `N + <return>` to cancel.

* `make ssh-bastion` or `make ssh-instance`

    This step is optional. Some additional environment variables are
    required. For example:

        STARTERKIT_BASTION_IP_ADDR=123.123.123.123
        STARTERKIT_BASTION_SSH_PRIVKEY="
        -----BEGIN RSA PRIVATE KEY-----
        SO/g+bkWs3Q8XbpFKVM94gC4t8VU0+uJf0vVbQvP7zIjR1qWaMNQ8ALEnMLRXJ0uxz+UFp3GBfrA
        BdKSotAvIuuinfG84KyW1bjVKjSGIjLOy/d9uPk2vQbZhFeA85CA3gGYyEwhfHqyzkZ+RDE2dycy
        ...
        -----END RSA PRIVATE KEY-----
        "
        STARTERKIT_INSTANCE_IP_ADDR=10.0.1.1
        STARTERKIT_INSTANCE_SSH_PRIVKEY="
        -----BEGIN RSA PRIVATE KEY-----
        Pk2vQbZhFeA85CA3gGYyEwhfHqyzkZ+RDE2dycyBdKSotAvIuuinfG84KyW1bjVKjSGIjLOy/d9u
        P7zIjR1qWaMNQ8ALEnMLRXJ0uxz+UFp3GBfrASO/g+bkWs3Q8XbpFKVM94gC4t8VU0+uJf0vVbQv
        ...
        -----END RSA PRIVATE KEY-----
        "

What?
---

AWS Certificate Manager is used to create an SSL certificate with
`$STARTERKIT_DOMAIN` as the Common Name and `www.$STARTERKIT_DOMAIN` as a
Subject Alternative Name. Two Route53 DNS entries are created,
`$STARTERKIT_DOMAIN` and `www.$STARTERKIT_DOMAIN`, which point to the public
IP address of the load balancer.

EC2 instances are spread across private subnets, one per availability zone,
behind a load balancer. A bastion host (another EC2 instance) is created on a
public subnet with access to the private subnets. An elastic IP address is
assigned to the bastion host.

HTTP requests on port 80 to the load balancer are routed to the EC2 instances
over HTTP on port 8080. These are expected to redirect clients back to the
load balancer over HTTPS on port 443. HTTPS requests on port 443 to the load
balancer are routed to the EC2 instances over HTTPS on port 8443.

A Postgres [Amazon Relational Database Service (RDS)](https://aws.amazon.com/rds/)
is provisioned with access to the private subnets. Use the value of
`starterkit_database_hostname` shown by `make show-outputs` on the EC2
instances to connect to it.

See Also
---

* https://gitlab.com/tvaughan/docker-flask-starterkit
