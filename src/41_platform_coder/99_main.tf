terraform {
  required_version = ">=1.10.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.32.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2"
    }
    keycloak = {
      source  = "keycloak/keycloak"
      version = ">= 5.0.0"
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

provider "kubernetes" {
  config_path = "${var.k8s_kube_config_path_prefix}/config-${local.aks_name}"
}

provider "helm" {
  kubernetes {
    config_path = "${var.k8s_kube_config_path_prefix}/config-${local.aks_name}"
  }
}

provider "keycloak" {
  client_id     = "terraform"
  client_secret = data.azurerm_key_vault_secret.terraform_client_secret_for_keycloak.value
  url           = "https://${data.azurerm_key_vault_secret.keycloak_url.value}"
  realm         = "master"
}

module "__v4__" {
  # https://github.com/pagopa/terraform-azurerm-v4/releases/tag/v7.45.1
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git?ref=8e15cac233fead870817f0bdcbe07d0490b70245"
}
