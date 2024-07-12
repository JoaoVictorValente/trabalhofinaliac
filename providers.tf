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
<<<<<<< HEAD
    resource_group_name  = "recursosAula05"
=======
    resource_group_name  = "teste"
>>>>>>> 0e3af883e01a1a6ce581744ffaa7bb4f7db32214
    storage_account_name = "aulaterraformstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {

  features {}

}
