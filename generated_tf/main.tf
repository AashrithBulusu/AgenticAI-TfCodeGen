module "network_security_group" {
  source  = "Azure/network-security-group/azurerm"
  version = "0.4.0"

  name                = var.network_security_group_config.name
  resource_group_name = var.network_security_group_config.resource_group_name
  location            = var.network_security_group_config.location
  security_rules      = var.network_security_group_config.security_rules
  tags                = var.network_security_group_config.tags
}
module "network_interface" {
  source  = "Azure/network-interface/azurerm"
  version = "1.0.0"

  name                = var.network_interface_config.name
  location            = var.network_interface_config.location
  resource_group_name = var.network_interface_config.resource_group_name
  ip_configuration    = [
    {
      name                          = "ipconfig1"
      subnet_id                     = var.network_interface_config.subnet_id
      private_ip_address            = var.network_interface_config.private_ip_address
      private_ip_address_allocation = var.network_interface_config.private_ip_address_allocation
    }
  ]
  enable_ip_forwarding = var.network_interface_config.enable_ip_forwarding
  dns_servers          = var.network_interface_config.dns_servers
  tags                 = var.network_interface_config.tags
}
module "virtual_machine" {
  source  = "Azure/avm-res-azurestackhci-virtualmachineinstance/azurerm"
  version = "~> 2.0"

  name                       = var.virtual_machine_config.name
  location                   = var.virtual_machine_config.location
  resource_group_name        = var.virtual_machine_config.resource_group_name
  vm_size                    = var.virtual_machine_config.vm_size
  admin_username             = var.virtual_machine_config.admin_username
  admin_password             = var.virtual_machine_config.admin_password
  network_interface_ids      = var.virtual_machine_config.network_interface_ids
  os_disk                    = var.virtual_machine_config.os_disk
  data_disks                 = var.virtual_machine_config.data_disks
  tags                       = var.virtual_machine_config.tags
  availability_set_id        = var.virtual_machine_config.availability_set_id
  custom_data                = var.virtual_machine_config.custom_data
  identity                   = var.virtual_machine_config.identity
  license_type               = var.virtual_machine_config.license_type
  plan                       = var.virtual_machine_config.plan
  priority                   = var.virtual_machine_config.priority
  proximity_placement_group  = var.virtual_machine_config.proximity_placement_group
  zones                      = var.virtual_machine_config.zones
}
module "load_balancer" {
  source  = "Azure/network-loadbalancer/azurerm"
  version = "0.4.0"

  name                = var.load_balancer_config.name
  resource_group_name = var.load_balancer_config.resource_group_name
  location            = var.load_balancer_config.location
  frontend_ip_config  = var.load_balancer_config.frontend_ip_configurations
  backend_address_pool = var.load_balancer_config.backend_address_pools
  probes              = var.load_balancer_config.probes
  rules               = var.load_balancer_config.load_balancing_rules
  tags                = var.load_balancer_config.tags
}
module "storage_account" {
  source  = "Azure/storage-account/azurerm"
  version = "2.0.0"

  name                     = var.storage_account_config.name
  resource_group_name      = var.storage_account_config.resource_group_name
  location                 = var.storage_account_config.location
  account_tier             = var.storage_account_config.account_tier
  account_replication_type = var.storage_account_config.account_replication_type
  tags                     = var.storage_account_config.tags
}
module "sql_server" {
  source  = "Azure/avm-res-sql-server/azurerm"
  version = "~> 0.1.4"

  name                = var.sql_server_config.name
  resource_group_name = var.sql_server_config.resource_group_name
  location            = var.sql_server_config.location
  administrator_login = var.sql_server_config.administrator_login
  administrator_password = var.sql_server_config.administrator_login_password
  tags                = var.sql_server_config.tags
}
module "subnet" {
  source              = "Azure/subnet/azurerm"
  version             = "2.0.0"
  name                = var.subnet_config.name
  address_prefixes    = var.subnet_config.address_prefixes
  resource_group_name = var.subnet_config.resource_group_name
  virtual_network_name = var.subnet_config.virtual_network_name
  network_security_group_id = var.subnet_config.nsg_id
  route_table_id      = var.subnet_config.route_table_id
  service_endpoints   = var.subnet_config.service_endpoints
  delegations         = var.subnet_config.delegations
  enforce_private_link_endpoint_network_policies = var.subnet_config.private_endpoint_network_policies
  enforce_private_link_service_network_policies  = var.subnet_config.private_link_service_network_policies
  tags                = var.subnet_config.tags
}
module "private_dns_zone" {
  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "~> 0.3.3"

  name                = var.private_dns_zone_config.name
  resource_group_name = var.private_dns_zone_config.resource_group_name
  tags                = var.private_dns_zone_config.tags
}
