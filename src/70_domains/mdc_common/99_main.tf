terraform {
  required_version = ">=1.10.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.0"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "~> 7.0"
    }
    keycloak = {
      source  = "keycloak/keycloak"
      version = ">= 5.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
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

provider "keycloak" {
  client_id     = "terraform"
  client_secret = data.azurerm_key_vault_secret.terraform_client_secret_for_keycloak.value
  url           = data.azurerm_key_vault_secret.keycloak_url.value
  realm         = "master"
}

module "__v4__" {
  # https://github.com/pagopa/terraform-azurerm-v4/releases/tag/v9.8.1
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git?ref=b08aa6d9dc188ffaf98423c974a90ab9f0cece1f"
}
