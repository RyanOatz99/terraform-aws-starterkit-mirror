# -*- coding: utf-8; mode: terraform; -*-

variable "starterkit_domain" {
  # This must not have a default.
}

variable "starterkit_region" {
  # This must not have a default.
}

variable "starterkit_vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "starterkit_instances_per_availability_zone" {
  default = 1
}

variable "starterkit_instance_type" {
  default = "t2.micro"
}

variable "starterkit_instance_ami" {
  default = {
    # Container Linux (CoreOS) 1967.3.0 Stable Channel (HVM)
    # https://coreos.com/os/docs/latest/booting-on-ec2.html
    us-west-2 = "ami-0c1cc1260c7828fcb"
  }
}

variable "starterkit_instance_key_name" {
  default = "starterkit-instance"
}

variable "starterkit_bastion_type" {
  default = "t2.micro"
}

variable "starterkit_bastion_ami" {
  default = {
    # Amazon Linux 2 AMI (HVM), SSD Volume Type - (64-bit x86)
    us-west-2 = "ami-01bbe152bf19d0289"
  }
}

variable "starterkit_bastion_key_name" {
  default = "starterkit-bastion"
}

variable "starterkit_database_username" {
  # This must not have a default.
}

variable "starterkit_database_password" {
  # This must not have a default.
}

variable "starterkit_database_tcp_port" {
  # This must not have a default.
}

variable "starterkit_database_instance" {
  default = {
    # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.DBInstance.html
    allocated_storage         = 20
    deletion_protection       = true
    final_snapshot_identifier = "starterkit-final-database-snapshot"
    identifier                = "starterkit-database-instance"
    instance_class            = "db.t2.micro"
    storage_encrypted         = false
  }
}
