terraform {
  required_version = ">=1.10.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "~> 3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

provider "grafana" {
  alias = "cloud"

  url  = data.azurerm_dashboard_grafana.grafana_managed.endpoint
  auth = data.azurerm_key_vault_secret.grafana_service_account_token.value
}

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

module "__v4__" {
  # https://github.com/pagopa/terraform-azurerm-v4/releases/tag/v7.52.0
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git?ref=fa7a4a628ebd1281bf9ad469948ee004a031a21f"
}
