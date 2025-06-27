resource "random_password" "bucket_suffix" {
  length  = 8
  special = false
  lower   = false
  upper   = false
}

module "bucket_state" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.10.1"

  bucket = "terraform-state-${var.aws_region}-${random_password.bucket_suffix.result}"

  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy      = true
  versioning = {
    status = true
  }
}
