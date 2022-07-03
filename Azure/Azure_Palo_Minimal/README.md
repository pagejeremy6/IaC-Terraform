# Project Title

Palo-Minimal

## Description

- Minimal Palo Alto installation in Azure with Terraform
- By default will deploy a Standard D3 v2 which is enough for a VM100.
- By default deploy a BYOL, could be change for bundle1 or bundle2
- By default will restrict the management access to the Public IP of the machine deploying the code

### Components
- 1 resource group
- 2 NSG (MGMT, Untrust)
- 4 route tables
- 1 vnet
- 4 subnet (MGMT, Untrust, Trust, Server)
- 2 public IP
- 3 nic
- 1 VM

## Getting Started

### Dependencies

Azure subscription

### Installing

git clone repository

### Executing program

Deploy using VScode, Azure Account extension, Terraform extension

## Help


## Authors

Jeremy Page

## Version History

## License

## Acknowledgments
