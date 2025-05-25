variable "network_security_group_config" {
  type = object({
    name                = string
    resource_group_name = string
    location            = string
    tags                = optional(map(string), {})
    security_rules = optional(list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = optional(string)
      destination_port_range     = optional(string)
      source_address_prefix      = optional(string)
      destination_address_prefix = optional(string)
    })), [])
  })
  description = "Configuration object for the Network Security Group module, including required and optional parameters."
}
variable "network_interface_config" {
  description = "Configuration object for the Network Interface module."
  type = object({
    name                        = string
    location                    = string
    resource_group_name         = string
    enable_accelerated_networking = optional(bool, false)
    enable_ip_forwarding        = optional(bool, false)
    dns_servers                 = optional(list(string), [])
    internal_dns_name_label     = optional(string)
    private_ip_address          = optional(string)
    private_ip_address_allocation = optional(string, "Dynamic")
    subnet_id                   = string
    public_ip_address_id        = optional(string)
    application_security_group_ids = optional(list(string), [])
    tags                        = optional(map(string), {})
  })
}
variable "virtual_machine_config" {
  description = "Configuration object for the Stack HCI Virtual Machine Instance."
  type = object({
    name                      = string
    resource_group_name       = string
    location                  = string
    vm_size                   = string
    admin_username            = string
    admin_password            = string
    network_interface_ids     = list(string)
    os_disk                   = object({
      caching              = string
      storage_account_type = string
      disk_size_gb         = number
    })
    data_disks = optional(list(object({
      caching              = string
      storage_account_type = string
      disk_size_gb         = number
      lun                  = number
    })))
    tags = optional(map(string))
  })
}
variable "load_balancer_config" {
  description = "Configuration object for the Load Balancer module."
  type = object({
    resource_group_name = string
    location            = string
    load_balancer_name  = string
    frontend_ip_configurations = list(object({
      name                 = string
      subnet_id            = string
      private_ip_address   = optional(string)
      private_ip_allocation = optional(string, "Dynamic")
    }))
    backend_address_pools = optional(list(object({
      name = string
    })), [])
    probes = optional(list(object({
      name                = string
      protocol            = string
      port                = number
      request_path        = optional(string)
      interval_in_seconds = optional(number, 5)
      number_of_probes    = optional(number, 2)
    })), [])
    load_balancing_rules = optional(list(object({
      name                          = string
      frontend_ip_configuration_name = string
      backend_address_pool_name     = string
      probe_name                    = optional(string)
      protocol                      = string
      frontend_port                 = number
      backend_port                  = number
      idle_timeout_in_minutes       = optional(number, 4)
      enable_floating_ip            = optional(bool, false)
    })), [])
    tags = optional(map(string), {})
  })
}
variable "storage_account_config" {
  description = "Configuration object for the Storage Account module."
  type = object({
    name                        = string
    resource_group_name         = string
    location                    = string
    account_tier                = optional(string, "Standard")
    account_replication_type    = optional(string, "LRS")
    enable_https_traffic_only   = optional(bool, true)
    is_hns_enabled              = optional(bool, false)
    tags                        = optional(map(string), {})
  })
}
variable "sql_server_config" {
  description = "Configuration object for the Azure SQL Server module."
  type = object({
    name                = string
    resource_group_name = string
    location            = string
    administrator_login = string
    administrator_password = string
    version             = optional(string, "12.0")
    tags                = optional(map(string))
  })
}
variable "subnet_config" {
  description = "Configuration object for the subnet module."
  type = object({
    name                      = string
    resource_group_name       = string
    virtual_network_name      = string
    address_prefixes          = list(string)
    network_security_group_id = optional(string)
    route_table_id            = optional(string)
    service_endpoints         = optional(list(string))
    delegations               = optional(list(object({
      name = string
      service_delegation = object({
        name = string
        actions = list(string)
      })
    })))
    private_endpoint_network_policies_enabled = optional(bool)
    private_link_service_network_policies_enabled = optional(bool)
    tags                       = optional(map(string))
  })
}
