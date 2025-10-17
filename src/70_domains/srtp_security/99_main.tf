terraform {
  required_version = ">=1.10.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3"
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
  # https://github.com/pagopa/terraform-azurerm-v4/releases/tag/v7.40.2
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git?ref=1b507dcbfc89880e17ff6722fb69b10dfda9368d"
}
