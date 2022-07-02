output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}

output "vnet1_id" {
  value = azurerm_virtual_network.vnet1.id
}

output "vnet2_id" {
  value = azurerm_virtual_network.vnet2.id
}

output "public_ip_addr_1" {
  value = data.azurerm_public_ip.dataip1.ip_address
}

output "public_ip_addr_2" {
  value = data.azurerm_public_ip.dataip2.ip_address
}