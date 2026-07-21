output "vm_name" {
  value = azurerm_virtual_machine.dev-vm.name
}

output "nic_name" {
  value = azurerm_network_interface.dev-vm.name
}

output "rg_name" {
  value = azurerm_resource_group.dev-rg.name
}

output "vnet_name" {
  value = azurerm_virtual_network.dev-vm.name
}
