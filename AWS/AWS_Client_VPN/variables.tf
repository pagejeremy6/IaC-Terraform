variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ca-central-1"
}

variable "cidr_block_vpc" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cidr_block_subnet" {
  description = "CIDR block for subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default = {
    org         = "jayhomelab.com",
    environment = "terraform"
  }
}

variable "cidr_vpn" {
  description = "CIDR for VPN users"
  type        = string
  default     = "172.16.0.0/22"
}