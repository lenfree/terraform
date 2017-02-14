resource "aws_security_group" "logstash_cluster" {
  name        = "logstash"
  description = "ELB for logstash cluster"
  vpc_id      = "${var.vpc_id}"

  tags {
    Terraform = true
  }
}

resource "aws_security_group_rule" "allow_any_to_logstash_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.logstash_cluster.id}"
}

resource "aws_security_group_rule" "allow_logstash_out_tcp" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.logstash_cluster.id}"
}

resource "aws_security_group_rule" "allow_logstash_out_udp" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.logstash_cluster.id}"
}

resource "aws_security_group_rule" "allow_logstash_out_icmp" {
  type              = "egress"
  from_port         = 8
  to_port           = 8
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.logstash_cluster.id}"
}

resource "aws_autoscaling_group" "logstash" {
  name                 = "logstash_autoscaling_group"
  min_size             = 1
  max_size             = 2
  launch_configuration = "${aws_launch_configuration.logstash.name}"
  desired_capacity     = 1
  vpc_zone_identifier  = ["${var.private_subnet_ids}"]

  tag {
    key                 = "terraform"
    value               = true
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "logstash"
    propagate_at_launch = true
  }
}

data "template_file" "init" {
  template = "${file("${path.module}/init.tpl")}"

  vars {
    elasticsearch_host = "${var.elasticsearch_endpoint}"
  }
}

resource "aws_launch_configuration" "logstash" {
  name                 = "logstash_launch_config"
  image_id             = "${var.ami}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${aws_security_group.logstash_cluster.id}"]
  key_name             = "${var.key_name}"
  user_data            = "${data.template_file.init.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.logstash.id}"

  # Temporarily assign public address for troubleshooting.
  associate_public_ip_address = true
}

resource "aws_iam_role_policy" "ec2_es" {
  name = "ec2_es_policy"
  role = "${aws_iam_role.logstash.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "es:AddTags",
                "es:CreateElasticsearchDomain",
                "es:DescribeElasticsearchDomain",
                "es:DescribeElasticsearchDomains",
                "es:DescribeElasticsearchDomainConfig",
                "es:ListDomainNames",
                "es:ListTags"
            ],
            "Resource": [
                "${var.elasticsearch_arn}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "ec2_s3_trail" {
  name = "ec2_s3_trail_policy"
  role = "${aws_iam_role.logstash.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketAcl",
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "${var.cloudtrail_s3_bucket_arn}",
                "${var.cloudtrail_s3_bucket_arn}/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role" "logstash" {
  name = "logstash_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "logstash" {
  name  = "logstash_instance_profile"
  roles = ["${aws_iam_role.logstash.name}"]
}
