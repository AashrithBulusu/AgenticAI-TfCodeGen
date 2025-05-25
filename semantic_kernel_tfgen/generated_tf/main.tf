module "network_security_group" {
  source = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.4.0"
  name = var.network_security_group_vars.name
  location = var.network_security_group_vars.location
}
module "network_interface" {
  source = "Azure/avm-res-network-networkinterface/azurerm"
  version = "0.1.0"
  name = var.network_interface_vars.name
  location = var.network_interface_vars.location
}
module "virtual_machine" {
  source = "Azure/avm-res-azurestackhci-virtualmachineinstance/azurerm"
  version = "2.0.0"
  name = var.virtual_machine_vars.name
  location = var.virtual_machine_vars.location
}
module "load_balancer" {
  source = "Azure/avm-res-network-loadbalancer/azurerm"
  version = "0.4.0"
  name = var.load_balancer_vars.name
  location = var.load_balancer_vars.location
}
module "storage_account" {
  source = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.6.2"
  name = var.storage_account_vars.name
  location = var.storage_account_vars.location
}
module "sql_server" {
  source = "Azure/avm-res-sql-server/azurerm"
  version = "0.1.4"
  name = var.sql_server_vars.name
  location = var.sql_server_vars.location
}
