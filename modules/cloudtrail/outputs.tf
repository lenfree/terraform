output "id" {
  value = "${aws_cloudtrail.trail.id}"
}

output "home_region" {
  value = "${aws_cloudtrail.trail.home_region}"
}

output "arn" {
  value = "${aws_cloudtrail.trail.arn}"
}

output "s3_bucket_arn" {
  value = "${aws_s3_bucket.trail.arn}"
}

output "s3_bucket_id" {
  value = "${aws_s3_bucket.trail.id}"
}

output "s3_bucket_region" {
  value = "${aws_s3_bucket.trail.region}"
}

output "s3_bucket_bucket_domain_name" {
  value = "${aws_s3_bucket.trail.domain_name}"
}

output "s3_bucket_bucket_hosted_zone_id" {
  value = "${aws_s3_bucket.trail.hosted_zone_id}"
}
