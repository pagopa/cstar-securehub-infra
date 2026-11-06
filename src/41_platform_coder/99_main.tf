terraform {
  required_version = ">=1.11.0"

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
      version = "~> 5.0"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "~> 7.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.26.0"
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

provider "postgresql" {
  host      = module.keycloak_pgflex.fqdn
  port      = 5432
  database  = azurerm_postgresql_flexible_server_database.listmonk_db.name
  username  = azurerm_key_vault_secret.keycloak_db_admin_user.value
  password  = azurerm_key_vault_secret.keycloak_db_admin_password.value
  sslmode   = "require"
  superuser = false
}

module "__v4__" {
  # https://github.com/pagopa/terraform-azurerm-v4/releases/tag/v10.43.0
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git?ref=7e5635fc04118ced0abbf7089611b4178d447322"
}

provider "argocd" {
  server_addr = local.listmonk_argocd_hostname
  username    = data.azurerm_key_vault_secret.listmonk_argocd_username.value
  password    = data.azurerm_key_vault_secret.listmonk_argocd_password.value
}
