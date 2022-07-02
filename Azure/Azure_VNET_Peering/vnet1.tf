# Terraform tf file for vnet_1

resource "azurerm_virtual_network" "vnet1" {
  resource_group_name = azurerm_resource_group.rg.name
  name                = "vnet1"
  location            = var.resource_group_location
  address_space       = var.address_space_vnet1

  tags = var.resource_tags
}

# Can also create subnet as a nested block inside a vnet, but then cant use it as reference
# Ref: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet

resource "azurerm_subnet" "subnet1_vnet1" {
  name                 = "subnet1_vnet1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = var.subnet1_vnet1
}


resource "azurerm_public_ip" "mypublicip" {
  name                = "MyPublicIP"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"

  tags = var.resource_tags
}


# Reference VM linux basic
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine

resource "azurerm_network_interface" "nic_vm1" {
  name                = "nic_vm1"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.resource_tags

  ip_configuration {

    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1_vnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypublicip.id
  }
}

resource "azurerm_linux_virtual_machine" "vmvnet1" {
  name                = "vmvnet1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.resource_group_location
  size                = "Standard_F2"
  admin_username      = var.vm_username
  tags                = var.resource_tags

  # If not using ssh key, require to set password auth to false
  disable_password_authentication = false
  admin_password                  = var.vm_password


  network_interface_ids = [
    azurerm_network_interface.nic_vm1.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "myOSdisk"
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
resource "azurerm_network_security_group" "mynsg" {
  name                = "mynsg"
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

resource "azurerm_network_interface_security_group_association" "nicnsg" {
  network_interface_id      = azurerm_network_interface.nic_vm1.id
  network_security_group_id = azurerm_network_security_group.mynsg.id

}

