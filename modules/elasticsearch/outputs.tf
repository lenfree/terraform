output "arn" {
  value = "${aws_elasticsearch_domain.es.arn}"
}

output "domain_id" {
  value = "${aws_elasticsearch_domain.es.domain_id}"
}

output "endpoint" {
  value = "${aws_elasticsearch_domain.es.endpoint}"
}

output "fqdn" {
  value = "${aws_route53_record.es.fqdn}"
}
