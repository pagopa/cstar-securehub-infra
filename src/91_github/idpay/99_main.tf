terraform {
  required_version = ">=1.10.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.33"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.6"
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

provider "github" {
  owner = "pagopa"
}

module "__v4__" {
  # https://github.com/pagopa/terraform-azurerm-v4/releases/tag/v7.12.0
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git?ref=0a7c2d5439660df28f2154eb86f5a8af0bbe8892"
}
