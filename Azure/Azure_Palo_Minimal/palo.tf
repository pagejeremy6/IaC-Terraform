
#NSG
resource "azurerm_network_security_group" "nsg_0" {
  name                = join("", ["nsg_0", var.suffix_0])
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.resource_tags

  security_rule = [{
    access                                     = "Allow"
    description                                = "AllowInboundHome"
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
    destination_port_ranges                    = ["22", "443"]
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_ranges                         = []
  }]

}

# Empty NSG for the untrust interface
resource "azurerm_network_security_group" "nsg_1" {
  name                = join("", ["nsg_1", var.suffix_1])
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.resource_tags
}

#NSG Association
resource "azurerm_subnet_network_security_group_association" "association_0" {
  subnet_id                 = azurerm_subnet.subnet_0.id
  network_security_group_id = azurerm_network_security_group.nsg_0.id
}

resource "azurerm_subnet_network_security_group_association" "association_1" {
  subnet_id                 = azurerm_subnet.subnet_1.id
  network_security_group_id = azurerm_network_security_group.nsg_1.id
}

# Public IP
resource "azurerm_public_ip" "pip_0" {
  name                = join("", ["pip_0", var.suffix_0])
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  tags                = var.resource_tags
  sku                 = "Standard"
  domain_name_label   = join("", ["jayhomelab", var.suffix_0])
}

resource "azurerm_public_ip" "pip_1" {
  name                = join("", ["pip_1", var.suffix_1])
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  tags                = var.resource_tags
  sku                 = "Standard"
  domain_name_label   = join("", ["jayhomelab-", var.suffix_1])
}

# Network interfaces
resource "azurerm_network_interface" "nic_0" {
  name                = join("", ["nic_0", var.suffix_0])
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_0.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.subnet_0_first_ip
    public_ip_address_id          = azurerm_public_ip.pip_0.id
  }
}

resource "azurerm_network_interface" "nic_1" {
  name                          = join("", ["nic_1", var.suffix_1])
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  enable_accelerated_networking = true
  enable_ip_forwarding          = true
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_1.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.subnet_1_first_ip
    public_ip_address_id          = azurerm_public_ip.pip_1.id
  }
}

resource "azurerm_network_interface" "nic_2" {
  name                          = join("", ["nic_2", var.suffix_2])
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  enable_accelerated_networking = true
  enable_ip_forwarding          = true
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_2.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.subnet_2_first_ip
  }
}

# VM
resource "azurerm_virtual_machine" "vm_palo" {
  name                = join("", ["vm", var.project])
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.resource_tags
  vm_size             = "Standard_D3_v2"

  plan {
    name      = var.vm_sku
    publisher = var.vm_publisher
    product   = var.vm_offer
  }

  storage_image_reference {
    publisher = var.vm_publisher
    offer     = var.vm_offer
    sku       = var.vm_sku
    version   = "latest"
  }

# FromImage will automatically create it
  storage_os_disk {
    name          = "osDisk"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = join("", ["vm", var.project])
    admin_username = var.vm_username
    admin_password = var.vm_password

  }

  primary_network_interface_id = azurerm_network_interface.nic_0.id
  network_interface_ids = [
    azurerm_network_interface.nic_0.id,
    azurerm_network_interface.nic_1.id,
    azurerm_network_interface.nic_2.id
  ]

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
