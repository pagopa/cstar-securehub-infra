terraform {
  required_version = ">=1.10.0"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.4"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.33"
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

data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

module "__v4__" {
  # https://github.com/pagopa/terraform-azurerm-v4/releases/tag/v7.51.1
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git?ref=2af8a000f8e3ac6c78944d1aad6be020ad8f0f63"
}
