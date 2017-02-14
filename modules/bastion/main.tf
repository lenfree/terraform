resource "aws_security_group" "bastion_elb" {
  name        = "Bastion ELB"
  description = "ELB for bastion cluster"
  vpc_id      = "${var.vpc_id}"

  tags {
    Terraform = true
  }
}

resource "aws_security_group_rule" "allow_any_to_elb" {
  type              = "ingress"
  from_port         = "${var.ssh_port}"
  to_port           = "${var.ssh_port}"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.bastion_elb.id}"
}

resource "aws_security_group_rule" "allow_elb_out" {
  type              = "egress"
  from_port         = "${var.ssh_port}"
  to_port           = "${var.ssh_port}"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.bastion_elb.id}"
}

resource "aws_security_group" "bastion_cluster" {
  name        = "Bastion cluster"
  description = "Bastion cluster"
  vpc_id      = "${var.vpc_id}"

  tags {
    Terraform = true
  }
}

resource "aws_security_group_rule" "allow_in_ssh" {
  type                     = "ingress"
  from_port                = "${var.ssh_port}"
  to_port                  = "${var.ssh_port}"
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.bastion_cluster.id}"
  source_security_group_id = "${aws_security_group.bastion_elb.id}"
}

resource "aws_security_group_rule" "allow_ssh_out" {
  type                     = "egress"
  from_port                = "${var.ssh_port}"
  to_port                  = "${var.ssh_port}"
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.bastion_cluster.id}"
  source_security_group_id = "${aws_security_group.bastion_elb.id}"
}

resource "aws_security_group_rule" "allow_ssh_out_vpc" {
  type              = "egress"
  from_port         = "${var.ssh_port}"
  to_port           = "${var.ssh_port}"
  protocol          = "tcp"
  security_group_id = "${aws_security_group.bastion_cluster.id}"
  cidr_blocks       = ["${data.aws_vpc.main.cidr_block}"]
}

resource "aws_security_group_rule" "allow_80_out" {
  type              = "egress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.bastion_cluster.id}"
}

resource "aws_security_group_rule" "allow_443_out" {
  type              = "egress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.bastion_cluster.id}"
}

resource "aws_security_group_rule" "allow_icmp_out" {
  type              = "egress"
  from_port         = 8
  to_port           = 8
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.bastion_cluster.id}"
}

resource "aws_security_group_rule" "allow_8500_out" {
  type              = "egress"
  from_port         = "8500"
  to_port           = "8500"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.bastion_cluster.id}"
}

resource "aws_autoscaling_group" "bastion_cluster" {
  name                 = "Bastion Autoscaling Group"
  min_size             = "${var.asg_min_size}"
  max_size             = "${var.asg_max_size}"
  launch_configuration = "${aws_launch_configuration.bastion.name}"
  desired_capacity     = "${var.asg_desired_capacity}"
  load_balancers       = ["${aws_elb.bastion.name}"]
  vpc_zone_identifier  = ["${var.private_subnet_ids}"]

  tag {
    key                 = "terraform"
    value               = true
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "bastion"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "bastion" {
  name            = "Bastion Launch Configuration"
  image_id        = "${var.ami}"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.bastion_cluster.id}"]
  key_name        = "${var.key_name}"
}

resource "aws_elb" "bastion" {
  name            = "bastion-elb"
  subnets         = ["${var.public_subnet_ids}"]
  security_groups = ["${aws_security_group.bastion_elb.id}"]

  listener {
    instance_port     = "22"
    instance_protocol = "tcp"
    lb_port           = "22"
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "tcp:22"
    interval            = 5
  }

  tags {
    Terraform = true
  }
}

resource "aws_route53_record" "bastion" {
  zone_id = "${var.route53_zone}"
  name    = "${var.route53_record_name}"
  type    = "${var.route53_record_type}"

  alias {
    name                   = "${aws_elb.bastion.dns_name}"
    zone_id                = "${aws_elb.bastion.zone_id}"
    evaluate_target_health = true
  }
}
