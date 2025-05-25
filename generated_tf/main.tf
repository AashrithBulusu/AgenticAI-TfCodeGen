# Module for network_security_group
module "network_security_group" {
  source = "https://registry.terraform.io/modules/Azure/avm-res-network-networksecuritygroup/azurerm/latest"
}

# Module for network_interface
module "network_interface" {
  source = "https://registry.terraform.io/modules/Azure/avm-res-network-networkinterface/azurerm/latest"
}

# Module for virtual_machine
module "virtual_machine" {
  source = "https://registry.terraform.io/modules/Azure/avm-res-azurestackhci-virtualmachineinstance/azurerm/latest"
}

# Module for load_balancer
module "load_balancer" {
  source = "https://registry.terraform.io/modules/Azure/avm-res-network-loadbalancer/azurerm/latest"
}

# Module for storage_account
module "storage_account" {
  source = "https://registry.terraform.io/modules/Azure/avm-res-storage-storageaccount/azurerm/latest"
}

# Module for azure_sql_server
module "azure_sql_server" {
  source = "https://registry.terraform.io/modules/Azure/avm-res-sql-server/azurerm/latest"
}

