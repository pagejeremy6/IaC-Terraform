variable "project" {
  default     = "palomin"
  description = "project name"
}

variable "location" {
  default     = "canadaeast"
  description = "Location of the resource group."
}

variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default = {
    org         = "jayhomelab.com",
    environment = "terraform"
  }
}

variable "suffix_0" {
  default = "-mgmt"
}

variable "suffix_1" {
  default = "-untrust"
}

variable "suffix_2" {
  default = "-trust"
}

variable "suffix_10" {
  default = "-servers"
}

variable "subnet_vnet" {
  default = "10.10.0.0/16"
}

variable "subnet_0" {
  default = "10.10.0.0/24"
}
variable "subnet_1" {
  default = "10.10.1.0/24"
}
variable "subnet_2" {
  default = "10.10.2.0/24"
}
variable "subnet_10" {
  default = "10.10.10.0/24"
}

variable "subnet_0_first_ip" {
  default = "10.10.0.4"
}

variable "subnet_1_first_ip" {
  default = "10.10.1.4"
}

variable "subnet_2_first_ip" {
  default = "10.10.2.4"
}

variable "vm_publisher" {
  default = "paloaltonetworks"
}

variable "vm_sku" {
  default = "byol"
}

variable "vm_offer" {
  default = "vmseries-flex"
}

variable "vm_username" {
  description = "vm username"
  type        = string
  sensitive   = true
}

variable "vm_password" {
  description = "vm password"
  type        = string
  sensitive   = true
}