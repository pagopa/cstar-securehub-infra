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

provider "github" {
  owner = "pagopa"
}



import {
  to = github_repository.repository_settings["emd-ar-backoffice-fe"]
  id = "emd-ar-backoffice-fe"
}

import {
  to = github_branch_default.default["emd-ar-backoffice-fe"]
  id = "emd-ar-backoffice-fe"
}

import {
  to = github_actions_variable.repository_variables["emd-ar-backoffice-fe@SONARCLOUD_ORG"]
  id = "emd-ar-backoffice-fe:SONARCLOUD_ORG"
}

import {
  to = github_actions_variable.repository_variables["emd-ar-backoffice-fe@SONARCLOUD_PROJECT_KEY"]
  id = "emd-ar-backoffice-fe:SONARCLOUD_PROJECT_KEY"
}

import {
  to = github_actions_secret.repository_secrets["emd-ar-backoffice-fe@SONAR_TOKEN"]
  id = "emd-ar-backoffice-fe:SONAR_TOKEN"
}
