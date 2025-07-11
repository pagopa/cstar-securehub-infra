module "default_resource_groups" {
  source = "./.terraform/modules/__v4__/payments_default_resource_groups"

  for_each = local.domains_setup

  resource_group_prefix = "${local.product_nodomain}-${each.key}"
  location              = var.location
  tags                  = merge(module.tag_config.tags, each.value.tags)

  additional_resource_groups = can(each.value.additional_resource_groups) ? each.value.additional_resource_groups : []
}
