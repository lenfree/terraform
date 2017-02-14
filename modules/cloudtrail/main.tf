resource "aws_cloudtrail" "trail" {
  name                          = "${var.prefix}"
  s3_bucket_name                = "${aws_s3_bucket.trail.id}"
  include_global_service_events = true

  tags {
    Terraform = true
  }
}

resource "aws_s3_bucket" "trail" {
  bucket        = "cloudtrail-${var.prefix}-${var.environment_short}"
  force_destroy = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::cloudtrail-${var.prefix}-${var.environment_short}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::cloudtrail-${var.prefix}-${var.environment_short}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}
