module "network_security_group" {
  source  = "Azure/network-security-group/azurerm"
  version = "2.0.0"

  name                = var.network_security_group_config.name
  resource_group_name = var.network_security_group_config.resource_group_name
  location            = var.network_security_group_config.location
  security_rules      = var.network_security_group_config.security_rules
}
module "network_interface" {
  source  = "Azure/network-interface/azurerm"
  version = "2.0.0"

  name                = var.network_interface_config.name
  location            = var.network_interface_config.location
  resource_group_name = var.network_interface_config.resource_group_name
  subnet_id           = var.network_interface_config.subnet_id
  private_ip_address  = var.network_interface_config.private_ip_address
  enable_ip_forwarding = var.network_interface_config.enable_ip_forwarding
  dns_servers         = var.network_interface_config.dns_servers
  tags                = var.network_interface_config.tags
}
module "virtual_machine" {
  source              = "module_source_path"
  version             = "module_version"
  name                = var.virtual_machine_config.name
  location            = var.virtual_machine_config.location
  resource_group_name = var.virtual_machine_config.resource_group_name
  vm_size             = var.virtual_machine_config.vm_size
  admin_username      = var.virtual_machine_config.admin_username
  admin_password      = var.virtual_machine_config.admin_password
  os_disk_size_gb     = var.virtual_machine_config.os_disk_size_gb
  tags                = var.virtual_machine_config.tags
}
module "load_balancer" {
  source              = "module_source_here"
  version             = "module_version_here"
  name                = var.load_balancer_config.name
  location            = var.load_balancer_config.location
  resource_group_name = var.load_balancer_config.resource_group_name
  frontend_ip_config  = var.load_balancer_config.frontend_ip_config
  backend_address_pool = var.load_balancer_config.backend_address_pool
  probes              = var.load_balancer_config.probes
  rules               = var.load_balancer_config.rules
  tags                = var.load_balancer_config.tags
}
module "storage_account" {
  source  = "module_source_here"
  version = "module_version_here"

  name                = var.storage_account_config.name
  resource_group_name = var.storage_account_config.resource_group_name
  location            = var.storage_account_config.location
  account_tier        = var.storage_account_config.account_tier
  account_replication_type = var.storage_account_config.account_replication_type
  tags                = var.storage_account_config.tags
}
module "sql_server" {
  source              = "Azure/sql-server/azurerm"
  version             = "x.x.x"
  name                = var.sql_server_config.name
  resource_group_name = var.sql_server_config.resource_group_name
  location            = var.sql_server_config.location
  admin_username      = var.sql_server_config.admin_username
  admin_password      = var.sql_server_config.admin_password
  tags                = var.sql_server_config.tags
}

module "private_dns_zone" {
  source              = "Azure/private-dns-zone/azurerm"
  version             = "2.0.0"
  name                = var.private_dns_zone_config.name
  resource_group_name = var.private_dns_zone_config.resource_group_name
  tags                = var.private_dns_zone_config.tags
}
