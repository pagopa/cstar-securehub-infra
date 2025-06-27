locals {
  tags = {
    for key, value in module.tag_config.tags : key => replace(value, "&", "e")
  }
}
