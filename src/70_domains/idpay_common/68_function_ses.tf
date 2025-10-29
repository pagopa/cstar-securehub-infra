locals {
  function_location = "westeurope"
  ses_func_name     = "fa-idpay-ses-mailer"
  ses_plan_name     = "plan-idpay-ses-mailer"
  ses_zip_name      = "ses_mailer.zip"
  ses_src_dir       = "${path.module}/ses_mailer_src"
}

resource "random_string" "fa_suffix" {
  length  = 6
  upper   = false
  lower   = true
  special = false
}

resource "azurerm_storage_account" "ses_fa_sa" {
  name                     = "sesfa${random_string.fa_suffix.result}"
  resource_group_name      = data.azurerm_resource_group.idpay_data_rg.name
  location                 = local.function_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}

resource "azurerm_service_plan" "ses_plan" {
  name                = local.ses_plan_name
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name
  location            = local.function_location
  os_type             = "Linux"
  sku_name            = "Y1"
}

/* === Codice Function: usa MSI per leggere Blob e SES per inviare mail === */
/* __init__.py */
resource "local_file" "fa_init" {
  filename = "${local.ses_src_dir}/__init__.py"
  content  = <<-PY
    import os, json, base64, boto3
    from azure.identity import DefaultAzureCredential
    from azure.storage.blob import BlobClient
    from email.mime.multipart import MIMEMultipart
    from email.mime.text import MIMEText
    from email.mime.application import MIMEApplication

    def _attach(name, content_bytes):
        part = MIMEApplication(content_bytes)
        part.add_header("Content-Disposition", "attachment", filename=name)
        return part

    def main(req):
        try:
            body = req.get_json()
        except Exception:
            body = json.loads(req.get_body() or "{}")

        to_field  = body.get("to")
        to_list   = to_field if isinstance(to_field, list) else [to_field] if to_field else []
        subject   = body.get("subject", "Esportazione CSV")
        text      = body.get("body", "Ciao,\\nIn allegato trovi il CSV generato.")
        container = body.get("container")
        blob_path = body.get("blob_path")

        account   = os.environ.get("EXPORTS_ACCOUNT")
        source    = os.environ.get("SES_FROM")
        if not all([to_list, container, blob_path, account, source]):
            return {"statusCode": 400, "body": "Missing fields (to/container/blob_path/ENV)."}

        # Legge il blob via MSI
        url = f"https://{account}.blob.core.windows.net/{container}/{blob_path}"
        try:
            cred = DefaultAzureCredential()
            blob = BlobClient(account_url=f"https://{account}.blob.core.windows.net",
                              container_name=container, blob_name=blob_path,
                              credential=cred)
            content = blob.download_blob().readall()
        except Exception as e:
            return {"statusCode": 500, "body": f"Blob read error: {e}"}

        # Costruisce MIME
        msg = MIMEMultipart()
        msg["Subject"] = subject
        msg["From"] = source
        msg["To"] = ", ".join(to_list)
        msg.attach(MIMEText(text, "plain", "utf-8"))
        msg.attach(_attach(blob_path.split("/")[-1], content))

        # Invia con SES
        try:
            ses = boto3.client("ses",
                               region_name=os.environ.get("AWS_REGION", "eu-central-1"),
                               aws_access_key_id=os.environ.get("AWS_ACCESS_KEY_ID"),
                               aws_secret_access_key=os.environ.get("AWS_SECRET_ACCESS_KEY"))
            resp = ses.send_raw_email(Source=source, Destinations=to_list, RawMessage={"Data": msg.as_bytes()})
            return {"statusCode": 200, "headers": {"Content-Type":"application/json"}, "body": json.dumps(resp, default=str)}
        except Exception as e:
            return {"statusCode": 500, "body": f"SES error: {e}"}
  PY
}

/* function.json */
resource "local_file" "fa_function_json" {
  filename = "${local.ses_src_dir}/function.json"
  content  = <<-JSON
    {
      "scriptFile": "__init__.py",
      "entryPoint": "main",
      "bindings": [
        { "authLevel": "function", "type": "httpTrigger", "direction": "in", "name": "req", "methods": ["post"], "route": "send_email" },
        { "type": "http", "direction": "out", "name": "$return" }
      ]
    }
  JSON
}

/* host.json */
resource "local_file" "fa_host_json" {
  filename = "${local.ses_src_dir}/host.json"
  content  = <<-JSON
    { "version": "2.0" }
  JSON
}

/* requirements.txt */
resource "local_file" "fa_reqs" {
  filename = "${local.ses_src_dir}/requirements.txt"
  content  = <<-TXT
    boto3==1.34.131
    azure-identity==1.17.1
    azure-storage-blob==12.23.1
  TXT
}

data "archive_file" "fa_zip" {
  type        = "zip"
  source_dir  = local.ses_src_dir
  output_path = "${path.module}/${local.ses_zip_name}"
  depends_on  = [local_file.fa_init, local_file.fa_function_json, local_file.fa_host_json, local_file.fa_reqs]
}

resource "azurerm_linux_function_app" "ses" {
  name                        = local.ses_func_name
  resource_group_name         = data.azurerm_resource_group.idpay_data_rg.name
  location                    = local.function_location
  service_plan_id             = azurerm_service_plan.ses_plan.id
  storage_account_name        = azurerm_storage_account.ses_fa_sa.name
  storage_account_access_key  = azurerm_storage_account.ses_fa_sa.primary_access_key
  functions_extension_version = "~4"
  https_only                  = true

  site_config {
    application_stack { python_version = "3.10" }
    ftps_state = "Disabled"
  }

  identity { type = "SystemAssigned" }

  app_settings = {
    AWS_REGION            = "eu-central-1"
    AWS_ACCESS_KEY_ID     = data.azurerm_key_vault_secret.ses_access_key.value
    AWS_SECRET_ACCESS_KEY = data.azurerm_key_vault_secret.ses_secret_key.value
    SES_FROM              = data.azurerm_key_vault_secret.ses_from_address.value

    EXPORTS_ACCOUNT = module.storage_idpay_exports.name

    SCM_DO_BUILD_DURING_DEPLOYMENT = "1"
    ENABLE_ORYX_BUILD              = "true"
    WEBSITE_RUN_FROM_PACKAGE       = "1"
  }

  zip_deploy_file = data.archive_file.fa_zip.output_path

  depends_on = [data.archive_file.fa_zip]
}

# Chiave host per chiamarla da ADF
data "azurerm_function_app_host_keys" "ses_keys" {
  name                = azurerm_linux_function_app.ses.name
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name
}

output "ses_function_url" {
  value = "https://${azurerm_linux_function_app.ses.default_hostname}/api/send_email"
}
output "ses_function_key" {
  value     = data.azurerm_function_app_host_keys.ses_keys.default_function_key
  sensitive = true
}
