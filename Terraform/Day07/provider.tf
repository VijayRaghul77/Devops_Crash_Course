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

}
