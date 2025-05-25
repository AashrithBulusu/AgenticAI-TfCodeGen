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
      source_address_prefixes    = optional(list(string))
      destination_address_prefixes = optional(list(string))
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
    enable_ip_forwarding        = optional(bool, false)
    enable_accelerated_networking = optional(bool, false)
    private_ip_address          = optional(string)
    private_ip_address_allocation = optional(string, "Dynamic")
    subnet_id                   = string
    public_ip_address_id        = optional(string)
    dns_servers                 = optional(list(string), [])
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
    os_disk_size_gb           = optional(number)
    os_disk_type              = optional(string)
    data_disks                = optional(list(object({
      size_gb = number
      type    = string
    })))
    tags                      = optional(map(string))
  })
}
variable "load_balancer_config" {
  description = "Configuration object for the Azure Load Balancer module."
  type = object({
    name                = string
    resource_group_name = string
    location            = string
    sku                 = optional(string, "Standard")
    frontend_ip_configurations = optional(list(object({
      name                 = string
      public_ip_address_id = optional(string)
      private_ip_address   = optional(string)
      private_ip_address_allocation = optional(string, "Dynamic")
      subnet_id            = optional(string)
    })))
    backend_address_pool = optional(list(object({
      name = string
    })))
    load_balancing_rules = optional(list(object({
      name                            = string
      frontend_ip_configuration_name  = string
      backend_address_pool_name       = string
      protocol                        = string
      frontend_port                   = number
      backend_port                    = number
      enable_floating_ip              = optional(bool, false)
      idle_timeout_in_minutes         = optional(number, 4)
      load_distribution               = optional(string, "Default")
    })))
    probes = optional(list(object({
      name                = string
      protocol            = string
      port                = number
      request_path        = optional(string)
      interval_in_seconds = optional(number, 15)
      number_of_probes    = optional(number, 2)
    })))
    tags = optional(map(string))
  })
}
variable "storage_account_config" {
  description = "Configuration object for the Storage Account module."
  type = object({
    name                        = string
    resource_group_name         = string
    location                    = string
    account_tier                = string
    account_replication_type    = string
    enable_https_traffic_only   = optional(bool)
    access_tier                 = optional(string)
    tags                        = optional(map(string))
    custom_domain               = optional(object({
      name          = string
      use_subdomain = optional(bool)
    }))
    network_rules               = optional(object({
      bypass                     = optional(list(string))
      default_action             = optional(string)
      ip_rules                   = optional(list(string))
      virtual_network_subnet_ids = optional(list(string))
    }))
    blob_properties             = optional(object({
      delete_retention_policy = optional(object({
        days = number
      }))
    }))
    queue_properties            = optional(object({
      logging = optional(object({
        delete                = optional(bool)
        read                  = optional(bool)
        write                 = optional(bool)
        retention_policy_days = optional(number)
      }))
    }))
    share_properties            = optional(object({
      quota = optional(number)
    }))
    min_tls_version             = optional(string)
    allow_blob_public_access    = optional(bool)
    enable_hierarchical_namespace = optional(bool)
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
    tags                = optional(map(string), {})
  })
}
variable "subnet_config" {
  type = object({
    name                = string
    resource_group_name = string
    virtual_network_name = string
    address_prefixes    = list(string)
    service_endpoints   = optional(list(string), [])
    delegations         = optional(list(object({
      name = string
      service_name = string
    })), [])
    private_endpoint_network_policies = optional(string, null)
    private_link_service_network_policies = optional(string, null)
    tags                = optional(map(string), {})
  })
  description = "Configuration object for the subnet resource, including required and optional parameters."
}
