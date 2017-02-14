output "ssh_public_keys" {
  value = "${aws_key_pair.lenfree_yeung.key_name}"
}
