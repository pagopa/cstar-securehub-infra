terraform {
  required_version = ">=1.10.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.33"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.11"
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

provider "azurerm" {
  alias           = "uat"
  subscription_id = var.subscription_id_for_uat
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

provider "github" {
  owner = "pagopa"
}
