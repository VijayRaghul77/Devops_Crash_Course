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
  subscription_id = "aa2cd9ce-8c46-463c-91db-74bf555e2097"
  tenant_id       = "955ca1aa-6ef6-4a8f-b03c-8a34e73b8c73"
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
