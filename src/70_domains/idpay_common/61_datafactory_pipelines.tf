locals {
  pipeline_templates = {
    for file in fileset("${path.module}/data_factory_pipelines", "*.json") :
    jsondecode(file("${path.module}/data_factory_pipelines/${file}")).name => jsondecode(file("${path.module}/data_factory_pipelines/${file}"))
  }

  # path to the trx report pipeline
  pipeline_trx_report_file = "${path.module}/data_factory_pipelines/templated/idpay_transaction_report.json"
  pipeline_trx_report_json = jsondecode(templatefile(local.pipeline_trx_report_file, {
    data_factory_api_base_url = var.data_factory_api_base_url,
    kv_url                    = data.azurerm_key_vault.domain_kv.vault_uri
  }))

  # path to the user details report pipeline
  pipeline_user_details_report_file = "${path.module}/data_factory_pipelines/templated/idpay_user_details_report.json"
  pipeline_user_details_report_json = jsondecode(templatefile(local.pipeline_user_details_report_file, {
    data_factory_api_base_url = var.data_factory_api_base_url,
    kv_url                    = data.azurerm_key_vault.domain_kv.vault_uri
  }))

  # path to the approved reward batch csv pipeline
  pipeline_reward_batch_csv_file = "${path.module}/data_factory_pipelines/templated/idpay_reward_batch_csv.json"
  pipeline_reward_batch_csv_json = jsondecode(templatefile(local.pipeline_reward_batch_csv_file, {
    data_factory_api_base_url = var.data_factory_api_base_url,
    kv_url                    = data.azurerm_key_vault.domain_kv.vault_uri
  }))

  # path to the producers import pipeline
  pipeline_producers_import = "${path.module}/data_factory_pipelines/templated/idpay_producers_import.json"
  pipeline_producers_import_json = jsondecode(templatefile(local.pipeline_producers_import, {
    data_factory_api_base_url = var.data_factory_api_base_url,
    kv_url                    = data.azurerm_key_vault.domain_kv.vault_uri
  }))

  # path to the merchant batch csv pipeline
  pipeline_merchant_batch_csv_file = "${path.module}/data_factory_pipelines/templated/idpay_merchant_batch_csv.json"
  pipeline_merchant_batch_csv_json = jsondecode(templatefile(local.pipeline_merchant_batch_csv_file, {
    data_factory_api_base_url = var.data_factory_api_base_url,
    kv_url                    = data.azurerm_key_vault.domain_kv.vault_uri
  }))
}

resource "azurerm_data_factory_pipeline" "pipelines" {
  for_each = local.pipeline_templates

  name            = each.key
  data_factory_id = data.azurerm_data_factory.data_factory.id
  annotations     = []

  parameters = try(
    { for k, v in each.value.properties.parameters : k => "" },
    {}
  )

  activities_json = jsonencode(each.value.properties.activities)

  depends_on = [
    azurerm_data_factory_custom_dataset.datasets,
    azurerm_data_factory_data_flow.dataflows
  ]
}

resource "azurerm_data_factory_pipeline" "idpay_transaction_report" {
  name            = local.pipeline_trx_report_json.name
  data_factory_id = data.azurerm_data_factory.data_factory.id

  description = try(local.pipeline_trx_report_json.properties.description, null)
  concurrency = try(local.pipeline_trx_report_json.properties.concurrency, null)
  annotations = try(local.pipeline_trx_report_json.properties.annotations, [])
  parameters = try(
    {
      for k, v in local.pipeline_trx_report_json.properties.parameters :
      k => try(v.defaultValue, "")
    },
    {}
  )
  activities_json = jsonencode(local.pipeline_trx_report_json.properties.activities)
}

resource "azurerm_data_factory_pipeline" "idpay_user_details_report" {
  name            = local.pipeline_user_details_report_json.name
  data_factory_id = data.azurerm_data_factory.data_factory.id

  description = try(local.pipeline_user_details_report_json.properties.description, null)
  concurrency = try(local.pipeline_user_details_report_json.properties.concurrency, null)
  annotations = try(local.pipeline_user_details_report_json.properties.annotations, [])
  parameters = try(
    {
      for k, v in local.pipeline_user_details_report_json.properties.parameters :
      k => try(v.defaultValue, "")
    },
    {}
  )
  activities_json = jsonencode(local.pipeline_user_details_report_json.properties.activities)
}

resource "azurerm_data_factory_pipeline" "idpay_reward_batch_csv" {
  name            = local.pipeline_reward_batch_csv_json.name
  data_factory_id = data.azurerm_data_factory.data_factory.id

  description = try(local.pipeline_reward_batch_csv_json.properties.description, null)
  concurrency = try(local.pipeline_reward_batch_csv_json.properties.concurrency, null)
  annotations = try(local.pipeline_reward_batch_csv_json.properties.annotations, [])
  parameters = try(
    {
      for k, v in local.pipeline_reward_batch_csv_json.properties.parameters :
      k => try(v.defaultValue, "")
    },
    {}
  )
  activities_json = jsonencode(local.pipeline_reward_batch_csv_json.properties.activities)
  depends_on      = [azurerm_data_factory_custom_dataset.datasets]
}

resource "azurerm_data_factory_pipeline" "idpay_merchant_batch_csv" {
  name            = local.pipeline_merchant_batch_csv_json.name
  data_factory_id = data.azurerm_data_factory.data_factory.id

  description = try(local.pipeline_merchant_batch_csv_json.properties.description, null)
  concurrency = try(local.pipeline_merchant_batch_csv_json.properties.concurrency, null)
  annotations = try(local.pipeline_merchant_batch_csv_json.properties.annotations, [])
  parameters = try(
    {
      for k, v in local.pipeline_merchant_batch_csv_json.properties.parameters :
      k => try(v.defaultValue, "")
    },
    {}
  )
  activities_json = jsonencode(local.pipeline_merchant_batch_csv_json.properties.activities)
  depends_on      = [azurerm_data_factory_custom_dataset.datasets]
}

resource "azapi_resource" "idpay_producers_import" {
  type      = "Microsoft.DataFactory/factories/pipelines@2018-06-01"
  name      = local.pipeline_producers_import_json.name
  parent_id = data.azurerm_data_factory.data_factory.id

  body = {
    properties = {
      activities  = local.pipeline_producers_import_json.properties.activities
      variables   = local.pipeline_producers_import_json.properties.variables
      parameters  = try(local.pipeline_producers_import_json.properties.parameters, {})
      annotations = try(local.pipeline_producers_import_json.properties.annotations, [])
    }
  }
}

# path to the onboarding census pipeline (BND-2482)
locals {
  pipeline_onboarding_census_file = "${path.module}/data_factory_pipelines/templated/idpay_onboarding_census.json"
  pipeline_onboarding_census_json = jsondecode(templatefile(local.pipeline_onboarding_census_file, {
    kv_url                          = data.azurerm_key_vault.domain_kv.vault_uri
    onboarding_census_blob_endpoint = module.storage_idpay_onboarding_census.primary_blob_endpoint
  }))

  # child pipeline with the retry loop: ADF does not allow an Until inside an IfCondition
  pipeline_onboarding_census_retry_json = jsondecode(file("${path.module}/data_factory_pipelines/templated/idpay_onboarding_census_retry.json"))
}

resource "azapi_resource" "idpay_onboarding_census_retry" {
  type      = "Microsoft.DataFactory/factories/pipelines@2018-06-01"
  name      = local.pipeline_onboarding_census_retry_json.name
  parent_id = data.azurerm_data_factory.data_factory.id

  body = {
    properties = {
      description = local.pipeline_onboarding_census_retry_json.properties.description
      activities  = local.pipeline_onboarding_census_retry_json.properties.activities
      variables   = local.pipeline_onboarding_census_retry_json.properties.variables
      parameters  = local.pipeline_onboarding_census_retry_json.properties.parameters
      annotations = local.pipeline_onboarding_census_retry_json.properties.annotations
    }
  }

  depends_on = [
    azurerm_data_factory_custom_dataset.datasets,
    azurerm_data_factory_data_flow.dataflows
  ]
}

resource "azapi_resource" "idpay_onboarding_census" {
  type      = "Microsoft.DataFactory/factories/pipelines@2018-06-01"
  name      = local.pipeline_onboarding_census_json.name
  parent_id = data.azurerm_data_factory.data_factory.id

  body = {
    properties = {
      description = local.pipeline_onboarding_census_json.properties.description
      concurrency = local.pipeline_onboarding_census_json.properties.concurrency
      activities  = local.pipeline_onboarding_census_json.properties.activities
      variables   = local.pipeline_onboarding_census_json.properties.variables
      parameters  = local.pipeline_onboarding_census_json.properties.parameters
      annotations = local.pipeline_onboarding_census_json.properties.annotations
    }
  }

  depends_on = [
    azapi_resource.idpay_onboarding_census_retry,
    azurerm_data_factory_custom_dataset.datasets,
    azurerm_data_factory_data_flow.dataflows,
    azurerm_data_factory_linked_custom_service.idpay_onboarding_census_blob_ls,
    azurerm_data_factory_linked_custom_service.idpay_df_apim_rest_ls,
    azurerm_role_assignment.adf_can_access_onboarding_census_storage
  ]
}
