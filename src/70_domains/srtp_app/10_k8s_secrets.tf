resource "kubernetes_secret" "fileshare" {
  metadata {
    name      = "rtp-sender-microservice-chart-azure-file"
    namespace = var.domain
  }

  data = {
    azurestorageaccountname = data.azurerm_storage_account.rtp_share_storage_account.name
    azurestorageaccountkey  = data.azurerm_storage_account.rtp_share_storage_account.primary_access_key
  }

  type = "Opaque"
}

resource "kubernetes_secret" "rtp_activator_fileshare" {
  metadata {
    name      = "rtp-activator-microservice-chart-azure-file"
    namespace = var.domain
  }

  data = {
    azurestorageaccountname = data.azurerm_storage_account.rtp_share_storage_account.name
    azurestorageaccountkey  = data.azurerm_storage_account.rtp_share_storage_account.primary_access_key
  }

  type = "Opaque"
}
