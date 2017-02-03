output "web_elb" {
  value = "${aws_elb.web.dns_name}"
}

output "www_fqdn" {
  value = "${aws_route53_record.www.fqdn}"
}
