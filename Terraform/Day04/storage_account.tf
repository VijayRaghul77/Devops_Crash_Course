resource "azurerm_storage_account" "devstg" {

  name                     = "devstg0098"
  resource_group_name      = azurerm_resource_group.devstg.name
  location                 = azurerm_resource_group.devstg.location # implicit dependency
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = local.common_tags.environment
  }

}
