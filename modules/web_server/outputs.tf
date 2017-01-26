output "web_elb" {
  value = "${aws_elb.web.dns_name}"
}
