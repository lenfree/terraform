resource "aws_elasticsearch_domain" "es" {
  domain_name           = "${var.elasticsearch_domain_name}"
  elasticsearch_version = "${var.elasticsearch_version}"

  advanced_options {
    # This parameter expects string instead of boolean
    # up to v8.5.
    "rest.action.multi.allow_explicit_index" = "${var.allow_explicit_index}"
  }

  access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Condition": {
                "IpAddress": {
                  "aws:SourceIp": ["${var.allow_source_cidrs}"]
                }
            }
        }
    ]
}
CONFIG

  snapshot_options {
    automated_snapshot_start_hour = "${var.automated_snapshot_start_hour}"
  }

  cluster_config {
    instance_type            = "${var.instance_type}"
    instance_count           = "${var.instance_count}"
    dedicated_master_enabled = "${var.dedicated_master_enabled}"
    dedicated_master_type    = "${var.dedicated_master_type}"
    dedicated_master_count   = "${var.dedicated_master_count}"
    zone_awareness_enabled   = "${var.zone_awareness_enabled}"
  }

  tags {
    Domain    = "${var.elasticsearch_domain_name}"
    Terraform = true
  }
}

resource "aws_route53_record" "es" {
  zone_id = "${var.route53_zone}"
  name    = "${var.route53_record_name}"
  type    = "${var.route53_record_type}"
  ttl     = "300"
  records = ["${aws_elasticsearch_domain.es.endpoint}"]
}
