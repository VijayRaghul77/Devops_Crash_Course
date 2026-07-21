terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.8.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate-day04"         # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "day0429685"            # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "tfstate"               # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "dev.terraform.tfstate" # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }
  required_version = ">=1.9.0"
}

provider "azurerm" {
  features {}
  subscription_id = "aa2cd9ce-8c46-463c-91db-74bf555e2097"
  tenant_id       = "955ca1aa-6ef6-4a8f-b03c-8a34e73b8c73"

}
variable "environment" {
  type        = string
  description = "the env type"
  default     = "staging"

}

locals {
  common_tags = {
    environment = "dev"
    lob         = "banking"
    stage       = "alpha"
  }
}
resource "azurerm_resource_group" "dev" {
  name     = "dev-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "dev" {

  name                     = "bmalpha897"
  resource_group_name      = azurerm_resource_group.dev.name
  location                 = azurerm_resource_group.dev.location # implicit dependency
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = local.common_tags.environment
  }
}

output "storage_account_name" {
  value = azurerm_storage_account.dev.name
}

output "storage_account_tier" {
  value = azurerm_storage_account.dev.account_tier
}

output "storage_account_replication_type" {
  value = azurerm_storage_account.dev.account_replication_type
}
