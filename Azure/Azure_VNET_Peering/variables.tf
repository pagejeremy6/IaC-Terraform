
variable "resource_group_location" {
  default     = "canadaeast"
  description = "Location of the resource group."
}

variable "address_space_vnet1" {
  default     = ["10.10.0.0/16"]
  description = "address space of vnet1"
}

variable "address_space_vnet2" {
  default     = ["10.20.0.0/16"]
  description = "address space of vnet2"
}

variable "subnet1_vnet1" {
  default     = ["10.10.0.0/24"]
  description = "subnet vnet1"
}

variable "subnet1_vnet2" {
  default     = ["10.20.0.0/24"]
  description = "subnet vnet2"
}

variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default = {
    org         = "jayhomelab.com",
    environment = "terraform"
  }
}

variable "vm_username" {
  description = "vm username"
  type = string
  sensitive= true
}

variable "vm_password" {
  description = "vm password"
  type = string
  sensitive = true
}