# Terraform tf file for vnet_2

resource "azurerm_virtual_network" "vnet2" {
  resource_group_name = azurerm_resource_group.rg.name
  name                = "vnet2"
  location            = var.resource_group_location
  address_space       = var.address_space_vnet2

  tags = var.resource_tags
}

resource "azurerm_subnet" "subnet1_vnet2" {
  name                 = "subnet1_vnet2"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = var.subnet1_vnet2
}

resource "azurerm_public_ip" "mypublicip_2" {
  name                = "MyPublicIP2"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"

  tags = var.resource_tags
}


# Reference VM linux basic
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine

resource "azurerm_network_interface" "nic_vm2" {
  name                = "nic_vm2"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.resource_tags

  ip_configuration {

    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1_vnet2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypublicip_2.id
  }
}

resource "azurerm_linux_virtual_machine" "vmvnet2" {
  name                            = "vmvnet2"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.resource_group_location
  size                            = "Standard_F2"
  admin_username                  = var.vm_username
  disable_password_authentication = false
  admin_password                  = var.vm_password


  network_interface_ids = [
    azurerm_network_interface.nic_vm2.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "myOSdisk2"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}



### DOC says some parameters are optionnal, but they are not, will give an error
#https://stackoverflow.com/questions/67800978/how-to-correct-this-error-in-creating-azure-nsg-with-terraform
resource "azurerm_network_security_group" "mynsg2" {
  name                = "mynsg2"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.resource_tags

  security_rule = [{
    access                                     = "Allow"
    description                                = "AllowInboundSSHHome"
    destination_address_prefix                 = "*"
    destination_port_range                     = ""
    direction                                  = "Inbound"
    name                                       = "AllowInboundSSHhome"
    priority                                   = 100 # between 100 - 4096
    protocol                                   = "Tcp"
    source_address_prefix                      = "${chomp(data.http.myip.body)}" # nsg dont do FQDN, maybe a way to resolve it w powershell and send trhough variable
    source_port_range                          = "*"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_ranges                    = ["22"]
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_ranges                         = []
  }]
}

resource "azurerm_network_interface_security_group_association" "nicnsg2" {
  network_interface_id      = azurerm_network_interface.nic_vm2.id
  network_security_group_id = azurerm_network_security_group.mynsg2.id

}