terraform {
  required_version = ">=1.10.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.25"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "~> 7.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17"
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

provider "argocd" {
  server_addr = local.argocd_internal_url
  username    = module.secrets.values["argocd-admin-username"].value
  password    = module.secrets.values["argocd-admin-password"].value
  kubernetes {
    config_context = "config-${local.aks_name}"
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

module "__v4__" {
  # https://github.com/pagopa/terraform-azurerm-v4/releases/tag/v9.2.2
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git?ref=a2e23657aae1ba42f837b6f8f2f827566d476ca0"
}
