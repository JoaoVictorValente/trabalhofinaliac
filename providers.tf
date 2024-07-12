terraform {
  required_version = ">=0.12"
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "recursosAula05"
    storage_account_name = "aulaterraformstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {

  features {}

}
