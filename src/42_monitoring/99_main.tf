terraform {
  required_version = ">=1.3.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.114"
    }
    # null = {
    #   source  = "hashicorp/null"
    #   version = "~> 3.2"
    # }
    # random = {
    #   source  = "hashicorp/random"
    #   version = "~> 3.6"
    # }
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

module "__v3__" {
  # https://github.com/pagopa/terraform-azurerm-v3/releases/tag/v8.56.0
  source = "git::https://github.com/pagopa/terraform-azurerm-v3.git?ref=13a1b76bf4cf8b3709a4ca1afddb855aeec54304"
}
