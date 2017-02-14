output "bastion_elb" {
  value = "${aws_elb.bastion.dns_name}"
}

output "bastion_fqdn" {
  value = "${aws_route53_record.bastion.fqdn}"
}

output "bastion_cluster_sg_id" {
  value = "${aws_security_group.bastion_cluster.id}"
}
