output "id" {
  value = "${aws_cloudtrail.trail.id}"
}

output "home_region" {
  value = "${aws_cloudtrail.trail.home_region}"
}

output "arn" {
  value = "${aws_cloudtrail.trail.arn}"
}
