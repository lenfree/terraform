variable "aws_region" {}

variable "http_port" {}

variable "ami" {}

variable "instance_type" {}

variable "key_name" {}

variable "environment" {}

variable "environment_short" {}

variable "availability_zones" {
  type = "list"
}

variable "s3_bucket_acl" {}

variable "prefix" {}

variable "domain_name" {}

variable "vpc_id" {}

variable "public_subnet_ids" {
  type = "list"
}

variable "route53_zone" {}

variable "route53_record_name" {}

variable "route53_record_type" {}
