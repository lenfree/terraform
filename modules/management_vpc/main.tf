resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Terraform = true
    Name      = "${var.vpc_tag_name}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Terraform = true
  }
}

resource "aws_subnet" "public" {
  count                   = "${length(var.public_subnets)}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${element(var.public_subnets, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name      = "public_subnet_${element(var.availability_zones, count.index)}"
    Terraform = true
  }
}

resource "aws_subnet" "private" {
  count             = "${length(var.private_subnets)}"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${element(var.private_subnets, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"

  tags {
    Name      = "private_subnet_${element(var.availability_zones, count.index)}"
    Terraform = true
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name      = "public_route_table"
    Terraform = true
  }
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route" "public_to_internet" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.gw.id}"
  }

  tags {
    Name      = "private_route_table"
    Terraform = true
  }
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public.0.id}"
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnets)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_s3_bucket" "remote_state" {
  bucket = "${var.prefix}-remote_state-${var.environment}"

  versioning {
    enabled = "${var.s3_bucket_versioning}"
  }

  tags {
    Name        = "${var.prefix}-remote_state-${var.environment}"
    Environment = "${var.environment}"
    Terraform   = true
  }
}

resource "aws_route53_zone" "main" {
  name = "${var.domain_name}"

  tags {
    Terraform   = true
    Environment = "${var.environment}"
  }
}
