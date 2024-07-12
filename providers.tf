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
}

provider "azurerm" {
  
  features {
    
  }

  subscription_id   = "insira aqui"
  tenant_id         = "insira aqui"
  client_id         = "insira aqui"
  client_secret     = "insira aqui"
}