variable "aws_region" {}

variable "ami" {}

variable "instance_type" {}

variable "key_name" {}

variable "environment" {}

variable "environment_short" {}

variable "availability_zones" {
  type = "list"
}

variable "prefix" {}

variable "domain_name" {}

variable "vpc_id" {}

variable "private_subnet_ids" {
  type = "list"
}

variable "elasticsearch_endpoint" {}

variable "elasticsearch_arn" {}

variable "cloudtrail_s3_bucket_arn" {}
