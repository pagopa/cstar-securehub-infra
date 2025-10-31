terraform {
  required_version = ">=1.10.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
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

module "__v4__" {
  # https://github.com/pagopa/terraform-azurerm-v4/releases/tag/v7.43.1
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git?ref=40a33b4b83bc0746150b16505ea839925a94321a"
}
