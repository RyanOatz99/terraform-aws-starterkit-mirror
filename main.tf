# -*- coding: utf-8; mode: terraform; -*-

provider "aws" {
  # https://www.terraform.io/docs/providers/aws/index.html
  version = "~> 2"

  region = var.starterkit_region
}
