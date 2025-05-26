module "network_security_group" {
  source  = "Azure/network-security-group/azurerm"
  version = "2.0.0"

  name                = var.network_security_group_config.name
  location            = var.network_security_group_config.location
  resource_group_name = var.network_security_group_config.resource_group_name
  tags                = var.network_security_group_config.tags
  security_rules      = var.network_security_group_config.security_rules
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }

  required_version = ">= 1.3.0"
}
module "network_interface" {
  source  = "Azure/network-interface/azurerm"
  version = "2.0.0"

  name                = var.network_interface_config.name
  location            = var.network_interface_config.location
  resource_group_name = var.network_interface_config.resource_group_name
  ip_configuration = [
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
  version = "2.0.0"

  name                       = var.virtual_machine_config.name
  location                   = var.virtual_machine_config.location
  resource_group_name        = var.virtual_machine_config.resource_group_name
  vm_size                    = var.virtual_machine_config.vm_size
  admin_username             = var.virtual_machine_config.admin_username
  admin_password             = var.virtual_machine_config.admin_password
  network_interface_ids      = var.virtual_machine_config.network_interface_ids
  os_disk_size_gb            = var.virtual_machine_config.os_disk_size_gb
  os_disk_type               = var.virtual_machine_config.os_disk_type
  image_reference_publisher  = var.virtual_machine_config.image_reference_publisher
  image_reference_offer      = var.virtual_machine_config.image_reference_offer
  image_reference_sku        = var.virtual_machine_config.image_reference_sku
  image_reference_version    = var.virtual_machine_config.image_reference_version
  tags                       = var.virtual_machine_config.tags
}
module "load_balancer" {
  source  = "Azure/network/azurerm"
  version = "3.0.0"

  name                = var.load_balancer_config.name
  resource_group_name = var.load_balancer_config.resource_group_name
  location            = var.load_balancer_config.location
  frontend_ip_configuration = [
    for config in var.load_balancer_config.frontend_ip_configurations : {
      name                 = config.name
      private_ip_address   = lookup(config, "private_ip_address", null)
      private_ip_allocation = config.private_ip_allocation
      subnet_id            = config.subnet_id
      public_ip_address_id = lookup(config, "public_ip_address_id", null)
    }
  ]
  backend_address_pool = [
    for pool in lookup(var.load_balancer_config, "backend_address_pools", []) : {
      name = pool.name
    }
  ]
  probe = [
    for p in lookup(var.load_balancer_config, "probes", []) : {
      name                = p.name
      protocol            = p.protocol
      port                = p.port
      request_path        = lookup(p, "request_path", null)
      interval_in_seconds = p.interval_in_seconds
      number_of_probes    = p.number_of_probes
    }
  ]
  load_balancing_rule = [
    for rule in lookup(var.load_balancer_config, "load_balancing_rules", []) : {
      name                          = rule.name
      frontend_ip_configuration_name = rule.frontend_ip_configuration_name
      backend_address_pool_name     = rule.backend_address_pool_name
      probe_name                    = lookup(rule, "probe_name", null)
      protocol                      = rule.protocol
      frontend_port                 = rule.frontend_port
      backend_port                  = rule.backend_port
      idle_timeout_in_minutes       = lookup(rule, "idle_timeout_in_minutes", null)
      enable_floating_ip            = lookup(rule, "enable_floating_ip", null)
    }
  ]
  tags = lookup(var.load_balancer_config, "tags", null)
}
module "storage_account" {
  source  = "Azure/storage-account/azurerm"
  version = "2.0.0"

  name                     = var.storage_account_config.name
  resource_group_name      = var.storage_account_config.resource_group_name
  location                 = var.storage_account_config.location
  account_tier             = var.storage_account_config.account_tier
  account_replication_type = var.storage_account_config.account_replication_type
  enable_https_traffic_only = var.storage_account_config.enable_https_traffic_only
  is_hns_enabled           = var.storage_account_config.is_hns_enabled
  access_tier              = var.storage_account_config.access_tier
  tags                     = var.storage_account_config.tags
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }

  required_version = ">= 1.0.0"
}
module "sql_server" {
  source  = "Azure/sql/azurerm"
  version = "1.0.0"

  name                = var.sql_server_config.name
  resource_group_name = var.sql_server_config.resource_group_name
  location            = var.sql_server_config.location
  administrator_login = var.sql_server_config.administrator_login
  administrator_password = var.sql_server_config.administrator_password
  tags                = var.sql_server_config.tags
  version             = var.sql_server_config.version
}
module "subnet" {
  source              = "Azure/subnet/azurerm"
  version             = "2.0.0"
  name                = var.subnet_config.name
  address_prefixes    = var.subnet_config.address_prefixes
  resource_group_name = var.subnet_config.resource_group_name
  virtual_network_name = var.subnet_config.virtual_network_name
  tags                = var.subnet_config.tags
  network_security_group_id = var.subnet_config.network_security_group_id
  route_table_id            = var.subnet_config.route_table_id
  service_endpoints         = var.subnet_config.service_endpoints
  delegations               = var.subnet_config.delegations
  private_endpoint_network_policies = var.subnet_config.private_endpoint_network_policies
  private_link_service_network_policies = var.subnet_config.private_link_service_network_policies
}
module "private_dns_zone" {
  source  = "Azure/privatedns/azurerm"
  version = "0.3.3"

  name                = var.private_dns_zone_config.name
  resource_group_name = var.private_dns_zone_config.resource_group_name
  tags                = var.private_dns_zone_config.tags
  zone_name           = var.private_dns_zone_config.zone_name
  registration_enabled = var.private_dns_zone_config.registration_enabled
  resolution_enabled  = var.private_dns_zone_config.resolution_enabled
  virtual_network_links = [
    for link in var.private_dns_zone_config.virtual_network_links : {
      name                = link.name
      virtual_network_id  = link.virtual_network_id
      registration_enabled = lookup(link, "registration_enabled", true)
    }
  ]
}
