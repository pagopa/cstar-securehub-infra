terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.16"
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
  source = "git::https://github.com/pagopa/terraform-azurerm-v4?ref=fa7a4a628ebd1281bf9ad469948ee004a031a21f" # v7.52.0
}
