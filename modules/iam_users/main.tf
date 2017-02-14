resource "aws_iam_user" "administrators" {
  count = "${length(var.list_of_users)}"
  name  = "${element(var.list_of_users, count.index)}"
}

resource "aws_iam_group" "admin" {
  count = "${length(var.list_of_groups)}"
  name  = "${element(var.list_of_groups, count.index)}"
}

resource "aws_iam_group_membership" "administrators" {
  name  = "administrators"
  users = ["${join(",", aws_iam_user.administrators.*.name)}"]
  group = "${aws_iam_group.admin.name}"
}
