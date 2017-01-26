variable "aws_region" {}

variable "http_port" {}

variable "ami" {}

variable "instance_type" {}

variable "key_name" {}

variable "environment" {}

variable "disable_api_termination" {}

variable "environment_short" {}

variable "availability_zones" {
  type = "list"
}

variable "s3_bucket_terraform" {}

variable "s3_bucket_versioning" {}

variable "s3_bucket_acl" {}

variable "prefix" {}

variable "domain_name" {}

variable "vpc_id" {}

variable "public_subnet_ids" {
  type = "list"
}
