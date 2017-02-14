# Thanks to
# http://mpas.github.io/post/2016/11/16/20161116_building_a_consul_cluster_using_terraform_aws/
resource "aws_security_group_rule" "allow_bastion_in_22" {
  type                     = "ingress"
  from_port                = "22"
  to_port                  = "22"
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.consul_cluster.id}"
  source_security_group_id = "${var.bastion_sg_id}"
}

resource "aws_security_group_rule" "allow_bastion_out_22" {
  type                     = "egress"
  from_port                = "22"
  to_port                  = "22"
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.consul_cluster.id}"
  source_security_group_id = "${var.bastion_sg_id}"
}

resource "aws_security_group_rule" "allow_consul_out_tcp" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.consul_cluster.id}"
}

resource "aws_security_group_rule" "allow_consul_out_udp" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.consul_cluster.id}"
}

resource "aws_security_group_rule" "allow_consul_out_icmp" {
  type              = "egress"
  from_port         = 8
  to_port           = 8
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.consul_cluster.id}"
}

resource "aws_security_group_rule" "consul_cluster_nodes_8300_in" {
  type              = "ingress"
  from_port         = 8300
  to_port           = 8300
  protocol          = "tcp"
  self              = true
  security_group_id = "${aws_security_group.consul_cluster.id}"
}

resource "aws_security_group_rule" "consul_cluster_nodes_8300_out" {
  type              = "egress"
  from_port         = 8300
  to_port           = 8300
  protocol          = "tcp"
  self              = true
  security_group_id = "${aws_security_group.consul_cluster.id}"
}

resource "aws_security_group_rule" "consul_cluster_nodes_8301_in" {
  type              = "ingress"
  from_port         = 8301
  to_port           = 8301
  protocol          = "tcp"
  self              = true
  security_group_id = "${aws_security_group.consul_cluster.id}"
}

resource "aws_security_group_rule" "consul_cluster_nodes_8301_out" {
  type              = "egress"
  from_port         = 8301
  to_port           = 8301
  protocol          = "tcp"
  self              = true
  security_group_id = "${aws_security_group.consul_cluster.id}"
}

resource "aws_security_group_rule" "consul_cluster_nodes_8400_in" {
  type              = "ingress"
  from_port         = 8400
  to_port           = 8400
  protocol          = "tcp"
  self              = true
  security_group_id = "${aws_security_group.consul_cluster.id}"
}

resource "aws_security_group_rule" "consul_cluster_nodes_8400_out" {
  type              = "egress"
  from_port         = 8400
  to_port           = 8400
  protocol          = "tcp"
  self              = true
  security_group_id = "${aws_security_group.consul_cluster.id}"
}

resource "aws_security_group_rule" "consul_cluster_nodes_8500_in" {
  type              = "ingress"
  from_port         = 8500
  to_port           = 8500
  protocol          = "tcp"
  self              = true
  security_group_id = "${aws_security_group.consul_cluster.id}"
}

resource "aws_security_group_rule" "consul_cluster_nodes_8500_out" {
  type              = "egress"
  from_port         = 8500
  to_port           = 8500
  protocol          = "tcp"
  self              = true
  security_group_id = "${aws_security_group.consul_cluster.id}"
}

resource "aws_security_group_rule" "consul_cluster_nodes_8600_in_tcp" {
  type              = "ingress"
  from_port         = 8600
  to_port           = 8600
  protocol          = "tcp"
  self              = true
  security_group_id = "${aws_security_group.consul_cluster.id}"
}

resource "aws_security_group_rule" "consul_cluster_nodes_8600_out_tcp" {
  type              = "egress"
  from_port         = 8600
  to_port           = 8600
  protocol          = "tcp"
  self              = true
  security_group_id = "${aws_security_group.consul_cluster.id}"
}

resource "aws_security_group_rule" "consul_cluster_nodes_8600_in_udp" {
  type              = "ingress"
  from_port         = 8600
  to_port           = 8600
  protocol          = "udp"
  self              = true
  security_group_id = "${aws_security_group.consul_cluster.id}"
}

resource "aws_security_group_rule" "consul_cluster_nodes_8600_out_udp" {
  type              = "egress"
  from_port         = 8600
  to_port           = 8600
  protocol          = "udp"
  self              = true
  security_group_id = "${aws_security_group.consul_cluster.id}"
}

## ELB to Consul cluster security group rules.
resource "aws_security_group_rule" "consul_cluster_nodes_8300_in_elb" {
  type                     = "ingress"
  from_port                = 8300
  to_port                  = 8300
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.consul_cluster.id}"
  source_security_group_id = "${aws_security_group.consul_elb.id}"
}

resource "aws_security_group_rule" "consul_cluster_nodes_8300_out_elb" {
  type                     = "egress"
  from_port                = 8300
  to_port                  = 8300
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.consul_cluster.id}"
  source_security_group_id = "${aws_security_group.consul_elb.id}"
}

resource "aws_security_group_rule" "consul_cluster_nodes_8301_in_elb" {
  type                     = "ingress"
  from_port                = 8301
  to_port                  = 8301
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.consul_cluster.id}"
  source_security_group_id = "${aws_security_group.consul_elb.id}"
}

resource "aws_security_group_rule" "consul_cluster_nodes_8301_out_elb" {
  type                     = "egress"
  from_port                = 8301
  to_port                  = 8301
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.consul_cluster.id}"
  source_security_group_id = "${aws_security_group.consul_elb.id}"
}

resource "aws_security_group_rule" "consul_cluster_nodes_8400_in_elb" {
  type                     = "ingress"
  from_port                = 8400
  to_port                  = 8400
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.consul_cluster.id}"
  source_security_group_id = "${aws_security_group.consul_elb.id}"
}

resource "aws_security_group_rule" "consul_cluster_nodes_8400_out_elb" {
  type                     = "egress"
  from_port                = 8400
  to_port                  = 8400
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.consul_cluster.id}"
  source_security_group_id = "${aws_security_group.consul_elb.id}"
}

resource "aws_security_group_rule" "consul_cluster_nodes_8500_in_elb" {
  type                     = "ingress"
  from_port                = 8500
  to_port                  = 8500
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.consul_cluster.id}"
  source_security_group_id = "${aws_security_group.consul_elb.id}"
}

resource "aws_security_group_rule" "consul_cluster_nodes_8500_out_elb" {
  type              = "egress"
  from_port         = 8500
  to_port           = 8500
  protocol          = "tcp"
  security_group_id = "${aws_security_group.consul_cluster.id}"
}

resource "aws_security_group_rule" "consul_cluster_nodes_8600_in_tcp_elb" {
  type                     = "ingress"
  from_port                = 8600
  to_port                  = 8600
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.consul_cluster.id}"
  source_security_group_id = "${aws_security_group.consul_elb.id}"
}

resource "aws_security_group_rule" "consul_cluster_nodes_8600_out_tcp_elb" {
  type                     = "egress"
  from_port                = 8600
  to_port                  = 8600
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.consul_cluster.id}"
  source_security_group_id = "${aws_security_group.consul_elb.id}"
}

resource "aws_security_group_rule" "consul_cluster_nodes_8600_in_udp_elb" {
  type                     = "ingress"
  from_port                = 8600
  to_port                  = 8600
  protocol                 = "udp"
  security_group_id        = "${aws_security_group.consul_cluster.id}"
  source_security_group_id = "${aws_security_group.consul_elb.id}"
}

resource "aws_security_group_rule" "consul_cluster_nodes_8600_out_udp_elb" {
  type                     = "egress"
  from_port                = 8600
  to_port                  = 8600
  protocol                 = "udp"
  security_group_id        = "${aws_security_group.consul_cluster.id}"
  source_security_group_id = "${aws_security_group.consul_elb.id}"
}

resource "aws_security_group" "consul_cluster" {
  name        = "consul cluster"
  description = "Consul cluster"
  vpc_id      = "${var.vpc_id}"

  tags {
    Terraform = true
  }
}

resource "aws_iam_role" "consul_cluster" {
  name = "consul_read_ec2"

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

resource "aws_iam_role_policy" "ec2_read_policy" {
  name = "ec2_read_policy"
  role = "${aws_iam_role.consul_cluster.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeInstances"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "consul_cluster" {
  name  = "consul_cluster"
  roles = ["${aws_iam_role.consul_cluster.name}"]
}

resource "aws_launch_configuration" "consul_cluster" {
  image_id             = "${var.ami}"
  user_data            = "${data.template_file.consul-cluster.rendered}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.consul_cluster.id}"

  /* Server RPC (Default 8300). This is used by servers to handle incoming requests from other agents. TCP only.
  Serf LAN (Default 8301). This is used to handle gossip in the LAN. Required by all agents. TCP and UDP.
  Serf WAN (Default 8302). This is used by servers to gossip over the WAN to other servers. TCP and UDP.
  CLI RPC (Default 8400). This is used by all agents to handle RPC from the CLI. TCP only.
  HTTP API (Default 8500). This is used by clients to talk to the HTTP API. TCP only.
  DNS Interface (Default 8600). Used to resolve DNS queries. TCP and UDP. */
  security_groups = ["${aws_security_group.consul_cluster.id}"]
}

/*
    The template file used for the user-data
*/
data "template_file" "consul-cluster" {
  template = "${file("${path.module}/init.tpl")}"

  vars {
    // the name must match the Name tag of the autoscaling group
    consul_cluster_name = "consul-cluster-member"

    // the number of instances that need to be in the cluster to be healthy
    consul_cluster_min_size = 3
  }
}

resource "aws_autoscaling_group" "consul_cluster" {
  min_size             = 1
  max_size             = 3
  desired_capacity     = 3
  min_elb_capacity     = 3
  vpc_zone_identifier  = ["${var.private_subnet_ids}"]
  launch_configuration = "${aws_launch_configuration.consul_cluster.name}"
  load_balancers       = ["${aws_elb.consul.id}"]

  tag {
    key                 = "Name"
    value               = "consul-cluster-member"
    propagate_at_launch = true
  }

  tag {
    key                 = "terraform"
    value               = true
    propagate_at_launch = true
  }
}

resource "aws_security_group" "consul_elb" {
  name        = "consul cluster elb"
  description = "Consul cluster elb"
  vpc_id      = "${var.vpc_id}"

  tags {
    Terraform = true
  }
}

resource "aws_security_group_rule" "consul_elb_8300_in" {
  type              = "ingress"
  from_port         = 8300
  to_port           = 8300
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.consul_elb.id}"
}

resource "aws_security_group_rule" "consul_elb_8300_out" {
  type              = "egress"
  from_port         = 8300
  to_port           = 8300
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.consul_elb.id}"
}

resource "aws_security_group_rule" "consul_elb_8301_in" {
  type              = "ingress"
  from_port         = 8301
  to_port           = 8301
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.consul_elb.id}"
}

resource "aws_security_group_rule" "consul_elb_8301_out" {
  type              = "egress"
  from_port         = 8301
  to_port           = 8301
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.consul_elb.id}"
}

resource "aws_security_group_rule" "consul_elb_8400_in" {
  type              = "ingress"
  from_port         = 8400
  to_port           = 8400
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.consul_elb.id}"
}

resource "aws_security_group_rule" "consul_elb_8400_out" {
  type              = "egress"
  from_port         = 8400
  to_port           = 8400
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.consul_elb.id}"
}

resource "aws_security_group_rule" "consul_elb_8500_in" {
  type              = "ingress"
  from_port         = 8500
  to_port           = 8500
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.consul_elb.id}"
}

resource "aws_security_group_rule" "consul_elb_8500_out" {
  type              = "egress"
  from_port         = 8500
  to_port           = 8500
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.consul_elb.id}"
}

resource "aws_security_group_rule" "consul_elb_8600_in_tcp" {
  type              = "ingress"
  from_port         = 8600
  to_port           = 8600
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.consul_elb.id}"
}

resource "aws_security_group_rule" "consul_elb_8600_out_tcp" {
  type              = "egress"
  from_port         = 8600
  to_port           = 8600
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.consul_elb.id}"
}

resource "aws_security_group_rule" "consul_elb_8600_in_udp" {
  type              = "ingress"
  from_port         = 8600
  to_port           = 8600
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.consul_elb.id}"
}

resource "aws_security_group_rule" "consul_elbs_8600_out_udp" {
  type              = "egress"
  from_port         = 8600
  to_port           = 8600
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.consul_elb.id}"
}

resource "aws_elb" "consul" {
  name            = "consul-cluster"
  subnets         = ["${var.private_subnet_ids}"]
  security_groups = ["${aws_security_group.consul_elb.id}"]
  internal        = true

  listener {
    instance_port     = 8300
    instance_protocol = "tcp"
    lb_port           = 8300
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 8301
    instance_protocol = "tcp"
    lb_port           = 8301
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 8302
    instance_protocol = "tcp"
    lb_port           = 8302
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 8400
    instance_protocol = "tcp"
    lb_port           = 8400
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 8500
    instance_protocol = "http"
    lb_port           = 8500
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 8600
    instance_protocol = "tcp"
    lb_port           = 8600
    lb_protocol       = "tcp"
  }

  health_check {
    target              = "HTTP:8500/v1/status/leader"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
  }
}

resource "aws_route53_record" "consul" {
  zone_id = "${var.route53_zone}"
  name    = "${var.route53_record_name}"
  type    = "${var.route53_record_type}"

  alias {
    name                   = "${aws_elb.consul.dns_name}"
    zone_id                = "${aws_elb.consul.zone_id}"
    evaluate_target_health = true
  }
}
