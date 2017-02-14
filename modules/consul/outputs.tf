output "consul_elb" {
  value = "${aws_elb.consul.dns_name}"
}

output "consul_fqdn" {
  value = "${aws_route53_record.consul.fqdn}"
}

output "consul_cluster_sg_id" {
  value = "${aws_security_group.consul_cluster.id}"
}
