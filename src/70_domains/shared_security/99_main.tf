terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.16"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "<= 3.2.3"
    }
    external = {
      source  = "hashicorp/external"
      version = "<= 2.3.4"
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
  # https://github.com/pagopa/terraform-azurerm-v4/releases/tag/v10.20.1
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git?ref=639a4f39198027aa12d70db65aaaa585086366db"
}
