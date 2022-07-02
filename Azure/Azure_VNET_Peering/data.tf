# Public IP Retrieval, use this as an output
# this give an example : https://www.reddit.com/r/Terraform/comments/j5siyl/getting_the_public_ip_address_of_a_vm_in_azure/
data "azurerm_public_ip" "dataip1" {
  name                = azurerm_public_ip.mypublicip.name
  resource_group_name = azurerm_resource_group.rg.name
  depends_on = [
    azurerm_linux_virtual_machine.vmvnet1
  ]
}

data "azurerm_public_ip" "dataip2" {
  name                = azurerm_public_ip.mypublicip_2.name
  resource_group_name = azurerm_resource_group.rg.name
  depends_on = [
    azurerm_linux_virtual_machine.vmvnet2
  ]
}

# Find your public ip to apply it inbound on NSG for SSH rules
# https://stackoverflow.com/questions/46763287/i-want-to-identify-the-public-ip-of-the-terraform-execution-environment-and-add
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}