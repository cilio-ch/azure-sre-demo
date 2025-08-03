resource_group_name   = "azure-sre-lab-rg"
vnet_name             = "azure-sre-lab-vnet"
vnet_address_space    = "10.0.0.0/16"
subnet_name           = "azure-sre-lab-subnet"
subnet_address_prefix = "10.0.1.0/24"
nsg_name              = "azure-sre-lab-nsg"
vm_name               = "azure-sre-vm"
admin_username        = "cilio-ch"
ssh_public_key        = ""

tags = {
  environment = "lab"
  owner       = "cilio"
}
