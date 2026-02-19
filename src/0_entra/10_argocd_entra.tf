// ⚠️ Manual step required after apply:
// ⚠️ Manual step required after apply:
// ⚠️ Manual step required after apply:
// App > API permissions > Microsoft Graph > User.Read > Grant admin consent

module "argocd_entra" {
  source = "./.terraform/modules/__v4__/kubernetes_argocd_entra"

  name_identifier                = local.project
  argocd_hostname                = local.argocd_hostname
  entra_app_owners_object_ids    = data.azuread_users.argocd_application_owners.object_ids
  entra_sp_groups_with_user_role = concat(local.argocd_entra_groups_allowed, var.argocd_entra_groups_allowed_extra)
  aks_name                       = local.kubernetes_cluster_name
  aks_resource_group_name        = local.kubernetes_cluster_resource_group_name
  argocd_namespace               = local.argocd_namespace
  argocd_service_account_name    = local.argocd_service_account_name
  key_vault_id                   = data.azurerm_key_vault.kv_core_ita.id

  tags = module.tag_config.tags
}
