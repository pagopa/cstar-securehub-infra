terraform {
  required_version = ">= 1.10.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.36"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "~> 7.0"
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

provider "kubernetes" {
  config_path = "${var.k8s_kube_config_path_prefix}/config-${local.aks_name}"
}

provider "argocd" {
  server_addr = local.argocd_internal_url
  username    = data.azurerm_key_vault_secret.argocd_admin_username.value
  password    = data.azurerm_key_vault_secret.argocd_admin_password.value
  kubernetes {
    config_context = "config-${local.aks_name}"
  }
}

provider "keycloak" {
  client_id     = "terraform"
  client_secret = data.azurerm_key_vault_secret.terraform_client_secret_for_keycloak.value
  url           = "https://${data.azurerm_key_vault_secret.keycloak_url.value}"
  realm         = "master"
}

module "__v4__" {
  # https://github.com/pagopa/terraform-azurerm-v4/releases/tag/v7.43.1
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git?ref=40a33b4b83bc0746150b16505ea839925a94321a"
}
