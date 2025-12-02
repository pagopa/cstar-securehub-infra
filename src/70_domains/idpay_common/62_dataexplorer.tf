resource "azurerm_kusto_database" "db" {
  for_each = local.kusto_database

  name                = each.key
  resource_group_name = data.azurerm_kusto_cluster.kusto_cluster.resource_group_name
  location            = data.azurerm_kusto_cluster.kusto_cluster.location
  cluster_name        = data.azurerm_kusto_cluster.kusto_cluster.name

  hot_cache_period   = each.value.hot_cache_period
  soft_delete_period = each.value.soft_delete_period
}

resource "null_resource" "trigger_create_tables_idpay" {
  triggers = {
    file_hash = filesha256("${path.module}/data_explorer_kql/create_tables_idpay.kql")
  }
}

resource "azapi_resource" "create_tables_idpay" {
  type      = "Microsoft.Kusto/clusters/databases/scripts@2023-08-15"
  name      = "create-table-idpay"
  parent_id = "${data.azurerm_kusto_cluster.kusto_cluster.id}/databases/idpay"

  body = {
    properties = {
      scriptContent    = file("${path.module}/data_explorer_kql/create_tables_idpay.kql")
      continueOnErrors = false
    }
  }

  response_export_values = ["properties.provisioningState"]
  depends_on = [
    azurerm_kusto_database.db
  ]
  lifecycle {
    replace_triggered_by = [null_resource.trigger_create_tables_idpay]
  }
}

resource "azurerm_data_factory_managed_private_endpoint" "adf_dataexplorer_mpe" {
  name               = "${local.project}-kusto-mpe"
  data_factory_id    = data.azurerm_data_factory.data_factory.id
  target_resource_id = data.azurerm_kusto_cluster.kusto_cluster.id
  subresource_name   = "cluster"
}

data "azapi_resource" "privatelink_private_endpoint_connection" {
  type                   = "Microsoft.Kusto/clusters@2023-08-15"
  resource_id            = data.azurerm_kusto_cluster.kusto_cluster.id
  response_export_values = ["properties.privateEndpointConnections."]

  depends_on = [
    azurerm_data_factory_managed_private_endpoint.adf_dataexplorer_mpe
  ]
}

locals {
  privatelink_private_endpoint_connection_name = data.azapi_resource.privatelink_private_endpoint_connection.output.properties.privateEndpointConnections[0].id
}
resource "azapi_resource_action" "kusto_approve_pe" {
  type        = "Microsoft.Kusto/clusters/privateEndpointConnections@2024-04-13"
  resource_id = local.privatelink_private_endpoint_connection_name
  method      = "PUT"

  body = {
    properties = {
      privateLinkServiceConnectionState = {
        description = "Approved via Terraform - ${azurerm_data_factory_managed_private_endpoint.adf_dataexplorer_mpe.name}"
        status      = "Approved"
      }
    }
  }
}

resource "azurerm_data_factory_linked_service_kusto" "kusto" {
  for_each = local.kusto_database

  name                 = "${var.domain}-Kusto-${each.key}-ls"
  data_factory_id      = data.azurerm_data_factory.data_factory.id
  kusto_endpoint       = data.azurerm_kusto_cluster.kusto_cluster.uri
  kusto_database_name  = azurerm_kusto_database.db[each.key].name
  use_managed_identity = true

  integration_runtime_name = "AutoResolveIntegrationRuntime"
}

resource "azurerm_kusto_database_principal_assignment" "adf_mi" {
  for_each = local.kusto_database

  name                = "adf-managed-identity"
  database_name       = azurerm_kusto_database.db[each.key].name
  cluster_name        = data.azurerm_kusto_cluster.kusto_cluster.name
  resource_group_name = data.azurerm_kusto_cluster.kusto_cluster.resource_group_name

  principal_id   = data.azurerm_data_factory.data_factory.identity[0].principal_id
  principal_type = "App"
  tenant_id      = data.azurerm_client_config.current.tenant_id
  role           = "Admin"
}

locals {
  ad_groups_adx = flatten([
    # General Group
    [{
      id             = data.azuread_group.adgroup_admin.object_id
      name           = data.azuread_group.adgroup_admin.display_name
      role           = "Admin"
      principal_type = "Group"
    }],
    # IDPAY GROUP
    [{
      id             = data.azuread_group.adgroup_idpay_admin.object_id,
      name           = data.azuread_group.adgroup_idpay_admin.display_name
      role           = "Admin"
      principal_type = "Group"
    }],
    [
      {
        id             = data.azuread_group.adgroup_idpay_developers.object_id,
        name           = data.azuread_group.adgroup_idpay_developers.display_name
        role           = var.env_short == "p" ? "Viewer" : "Admin"
        principal_type = "Group"
      }
    ],
    [
      for g in data.azuread_group.adgroup_idpay_oncall[*] : {
        id             = g.object_id,
        name           = g.display_name
        role           = "Admin"
        principal_type = "Group"
      }
    ],
    contains(["d", "u"], var.env_short) ? [{
      id             = data.azuread_group.adgroup_idpay_externals.object_id,
      name           = data.azuread_group.adgroup_idpay_externals.display_name
      role           = "Admin"
      principal_type = "Group"
    }] : [],
    # IAC
    [
      for i in local.azdo_iac_managed_identities_write : {
        id             = data.azurerm_user_assigned_identity.iac_federated_azdo[i].principal_id
        name           = data.azurerm_user_assigned_identity.iac_federated_azdo[i].name
        role           = "Admin"
        principal_type = "App"
      }
    ]
  ])

  db_group_flatten = flatten([
    for db in keys(local.kusto_database) : [
      for ad_group in local.ad_groups_adx : {
        db_key         = db
        ad_group_id    = ad_group.id
        ad_group_name  = ad_group.name
        role           = ad_group.role
        principal_type = ad_group.principal_type
      }
    ]
  ])
}

resource "azurerm_kusto_database_principal_assignment" "kusto_ad_groups" {
  for_each = {
    for i in local.db_group_flatten : "${i.db_key}-${i.ad_group_name}" => i
  }

  name                = "ad-group-${each.value.ad_group_name}"
  database_name       = azurerm_kusto_database.db[each.value.db_key].name
  cluster_name        = data.azurerm_kusto_cluster.kusto_cluster.name
  resource_group_name = data.azurerm_kusto_cluster.kusto_cluster.resource_group_name

  principal_id   = each.value.ad_group_id
  principal_type = each.value.principal_type
  tenant_id      = data.azurerm_client_config.current.tenant_id
  role           = each.value.role
}
