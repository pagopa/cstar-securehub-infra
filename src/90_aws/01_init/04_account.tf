resource "aws_iam_account_alias" "alias" {
  account_alias = "${var.prefix}-${var.env}"
}
