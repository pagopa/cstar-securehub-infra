module "tag_config" {
  source      = "../../00_tag_config"
  domain      = var.domain
  environment = var.env
}
