terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.8.0"
    }
  }
  required_version = ">=1.9.0"
}

provider "azurerm" {
  features {}
  subscription_id = "<YOUR_SUBSCRIPTION_ID>"
  tenant_id       = "<YOUR_TENANT_ID>"
}

resource "azurerm_resource_group" "storage_rg" {
  name     = "storage_rg"
  location = "East US"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "vrdevopsstorage101"
  resource_group_name      = azurerm_resource_group.storage_rg.name
  location                 = azurerm_resource_group.storage_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "production"
  }
}
