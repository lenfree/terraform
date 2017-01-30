variable "aws_region" {}

variable "vpc_tag_name" {}

variable "vpc_cidr" {}

variable "public_subnets" {
  type = "list"
}

variable "private_subnets" {
  type = "list"
}

variable "availability_zones" {
  type = "list"
}

variable "domain_name" {}

variable "environment_short" {}

variable "s3_bucket_terraform" {}

variable "s3_bucket_versioning" {}

variable "s3_bucket_acl" {}

variable "prefix" {}

variable "environment" {}
