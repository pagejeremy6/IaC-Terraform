terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {

  }
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = join("", [var.project, "-rg"])
  location = var.location
  tags     = var.resource_tags
}

# VNET
resource "azurerm_virtual_network" "vnet" {
  name                = join("", [var.project, "-vnet"])
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = [var.subnet_vnet]
  tags                = var.resource_tags
}

# Subnet
resource "azurerm_subnet" "subnet_0" {
  name                 = join("", ["subnet_0", var.suffix_0])
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_0]
}

resource "azurerm_subnet" "subnet_1" {
  name                 = join("", ["subnet_1", var.suffix_1])
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_1]
}

resource "azurerm_subnet" "subnet_2" {
  name                 = join("", ["subnet_2", var.suffix_2])
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_2]
}

resource "azurerm_subnet" "subnet_10" {
  name                 = join("", ["subnet_10", var.suffix_10])
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_10]
}

#Route Table
resource "azurerm_route_table" "udr_0" {
  name                          = join("", ["udr_0", var.suffix_0])
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  tags                          = var.resource_tags
  disable_bgp_route_propagation = true
  ##route syntax https://github.com/hashicorp/terraform-provider-azurerm/issues/6898
  route {
    name           = "BlackholeToSubnet1"
    address_prefix = var.subnet_1
    next_hop_type  = "None"
  }
  route {
    name           = "BlackholeToSubnet2"
    address_prefix = var.subnet_2
    next_hop_type  = "None"
  }
  route {
    name           = "BlackholeToSubnet10"
    address_prefix = var.subnet_10
    next_hop_type  = "None"
  }
}

resource "azurerm_route_table" "udr_1" {
  name                          = join("", ["udr_1", var.suffix_1])
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  tags                          = var.resource_tags
  disable_bgp_route_propagation = true
  route {
    name           = "BlackholeToSubnet0"
    address_prefix = var.subnet_0
    next_hop_type  = "None"
  }
  route {
    name           = "BlackholeToSubnet2"
    address_prefix = var.subnet_2
    next_hop_type  = "None"
  }
  route {
    name           = "BlackholeToSubnet10"
    address_prefix = var.subnet_10
    next_hop_type  = "None"
  }
}

resource "azurerm_route_table" "udr_2" {
  name                          = join("", ["udr_2", var.suffix_2])
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  tags                          = var.resource_tags
  disable_bgp_route_propagation = true
  route {
    name           = "BlackholeToSubnet0"
    address_prefix = var.subnet_0
    next_hop_type  = "None"
  }
  route {
    name                   = "DefaultRoute"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.subnet_2_first_ip
  }
  route {
    name                   = "ToPublicSubnet"
    address_prefix         = var.subnet_1
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.subnet_2_first_ip
  }
}

resource "azurerm_route_table" "udr_10" {
  name                          = join("", ["udr_10", var.suffix_10])
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  tags                          = var.resource_tags
  disable_bgp_route_propagation = true
  route {
    name           = "BlackholeToSubnet0"
    address_prefix = var.subnet_0
    next_hop_type  = "None"
  }
  route {
    name                   = "DefaultRoute"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.subnet_2_first_ip
  }
  route {
    name                   = "ToPublicSubnet"
    address_prefix         = var.subnet_1
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.subnet_2_first_ip
  }
}

# Associate route with subnet
resource "azurerm_subnet_route_table_association" "association_subnet_0" {
  subnet_id      = azurerm_subnet.subnet_0.id
  route_table_id = azurerm_route_table.udr_0.id
}

resource "azurerm_subnet_route_table_association" "association_subnet_1" {
  subnet_id      = azurerm_subnet.subnet_1.id
  route_table_id = azurerm_route_table.udr_1.id
}

resource "azurerm_subnet_route_table_association" "association_subnet_2" {
  subnet_id      = azurerm_subnet.subnet_2.id
  route_table_id = azurerm_route_table.udr_2.id
}

resource "azurerm_subnet_route_table_association" "association_subnet_10" {
  subnet_id      = azurerm_subnet.subnet_10.id
  route_table_id = azurerm_route_table.udr_10.id
}