module "network_security_group" {
  source = "https://registry.terraform.io/modules/Azure/avm-res-network-networksecuritygroup/azurerm/latest"
  version = "0.4.0"
  name = var.name
  location = var.location
}

module "network_interface" {
  source = "https://registry.terraform.io/modules/Azure/avm-res-network-networkinterface/azurerm/latest"
  version = "0.1.0"
  name = var.name
  location = var.location
}

module "virtual_machine" {
  source = "https://registry.terraform.io/modules/Azure/avm-res-azurestackhci-virtualmachineinstance/azurerm/latest"
  version = "2.0.0"
  name = var.name
  location = var.location
}

module "load_balancer" {
  source = "https://registry.terraform.io/modules/Azure/avm-res-network-loadbalancer/azurerm/latest"
  version = "0.4.0"
  name = var.name
  location = var.location
}

module "storage_account" {
  source = "https://registry.terraform.io/modules/Azure/avm-res-storage-storageaccount/azurerm/latest"
  version = "0.6.2"
  name = var.name
  location = var.location
}

module "sql_server" {
  source = "https://registry.terraform.io/modules/Azure/avm-res-sql-server/azurerm/latest"
  version = "0.1.4"
  name = var.name
  location = var.location
}

