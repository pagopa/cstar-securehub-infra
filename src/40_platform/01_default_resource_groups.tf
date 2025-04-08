module "default_resource_groups" {
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//payments_default_resource_groups?ref=v1.28.0"

  for_each = local.domains_setup

  resource_group_prefix = "${local.product_nodomain}-${each.key}"
  location              = var.location
  tags                  = merge(var.tags, each.value.tags)
  enable_resource_locks = var.env == "prod" ? false : true # in prod there are policies that create locks for us

  additional_resource_groups = can(each.value.additional_resource_groups) ? each.value.additional_resource_groups : []
}
