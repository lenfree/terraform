output "id" {
  value = "${aws_vpc.main.id}"
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public.*.id}"]
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private.*.id}"]
}

output "route_table_public_id" {
  value = "${aws_route_table.public.id}"
}

output "route_table_private_id" {
  value = "${aws_route_table.private.id}"
}

output "nat_gw" {
  value = "${aws_nat_gateway.gw.id}"
}

output "internet_gw" {
  value = "${aws_internet_gateway.igw.id}"
}

output "zone_id" {
  value = "${aws_route53_zone.main.zone_id}"
}
