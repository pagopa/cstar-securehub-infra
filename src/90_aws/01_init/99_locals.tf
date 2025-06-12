resource "random_password" "bucket_suffix" {
  length  = 8
  special = false
  lower   = false
  upper   = false
}

locals {
  tags = {
    for key, value in module.tag_config.tags : key => replace(value, "&", "e")
  }
}
