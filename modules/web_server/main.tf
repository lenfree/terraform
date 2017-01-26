resource "aws_security_group" "web_elb" {
  name        = "web_elb"
  description = "ELB for web cluster"
  vpc_id      = "${var.vpc_id}"

  tags {
    Terraform = true
  }
}

resource "aws_security_group_rule" "allow_any_to_elb" {
  type              = "ingress"
  from_port         = "${var.http_port}"
  to_port           = "${var.http_port}"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.web_elb.id}"
}

resource "aws_security_group_rule" "allow_elb_out" {
  type              = "egress"
  from_port         = "${var.http_port}"
  to_port           = "${var.http_port}"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.web_elb.id}"
}

resource "aws_security_group" "web_cluster" {
  name        = "web_cluster"
  description = "WEB cluster"
  vpc_id      = "${var.vpc_id}"

  tags {
    Terraform = true
  }
}

resource "aws_security_group_rule" "allow_in_http" {
  type                     = "ingress"
  from_port                = "${var.http_port}"
  to_port                  = "${var.http_port}"
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.web_cluster.id}"
  source_security_group_id = "${aws_security_group.web_elb.id}"
}

resource "aws_security_group_rule" "allow_http_out" {
  type                     = "egress"
  from_port                = "${var.http_port}"
  to_port                  = "${var.http_port}"
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.web_cluster.id}"
  source_security_group_id = "${aws_security_group.web_elb.id}"
}

resource "aws_autoscaling_group" "web_cluster" {
  name                 = "web_autoscaling_group"
  min_size             = 1
  max_size             = 2
  launch_configuration = "${aws_launch_configuration.web.name}"
  desired_capacity     = 1
  load_balancers       = ["${aws_elb.web.name}"]
  vpc_zone_identifier  = ["${var.public_subnet_ids}"]

  tag {
    key                 = "terraform"
    value               = true
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "web" {
  name            = "web_launch_config"
  image_id        = "${var.ami}"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.web_cluster.id}"]
  key_name        = "${var.key_name}"

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" >> index.html
              nohup busybox httpd -f -p 8080 &
              EOF
}

resource "aws_elb" "web" {
  name            = "web-elb"
  subnets         = ["${var.public_subnet_ids}"]
  security_groups = ["${aws_security_group.web_elb.id}"]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 8080
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/"
    interval            = 5
  }

  tags {
    Terraform = true
  }
}
