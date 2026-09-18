terraform {
  required_version = "> 1.10.0"

  required_providers {
    awscc = {
      source  = "hashicorp/awscc"
      version = "~> 1.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.18"
    }
  }

  backend "s3" {}
}


provider "awscc" {
  region  = var.aws_region
  profile = var.aws_profile
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}
