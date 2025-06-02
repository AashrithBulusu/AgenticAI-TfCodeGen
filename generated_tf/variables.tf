variable "network_security_group_config" {
  description = "Configuration object for the network security group module."
  type = object({
    name                = string
    resource_group_name = string
    location            = string
    tags                = optional(map(string))
    security_rules = optional(list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = optional(string)
      destination_port_range     = optional(string)
      source_port_ranges         = optional(list(string))
      destination_port_ranges    = optional(list(string))
      source_address_prefix      = optional(string)
      source_address_prefixes    = optional(list(string))
      destination_address_prefix = optional(string)
      destination_address_prefixes = optional(list(string))
    })))
  })
}
variable "network_interface_config" {
  description = "Configuration object for the network interface module."
  type = object({
    name                       = string
    location                   = string
    resource_group_name        = string
    subnet_id                  = string
    private_ip_address         = optional(string)
    private_ip_address_version = optional(string)
    enable_ip_forwarding       = optional(bool)
    enable_accelerated_networking = optional(bool)
    dns_servers                = optional(list(string))
    tags                       = optional(map(string))
  })
}
variable "virtual_machine_config" {
  type = object({
    name                       = string
    location                   = string
    resource_group_name        = string
    vm_size                    = string
    admin_username             = string
    admin_password             = string
    network_interface_ids      = list(string)
    os_disk                    = object({
      name              = string
      caching           = string
      create_option     = string
      managed_disk_type = string
      disk_size_gb      = number
    })
    data_disks                 = optional(list(object({
      name              = string
      caching           = string
      create_option     = string
      managed_disk_type = string
      disk_size_gb      = number
      lun               = number
    })))
    tags                       = optional(map(string))
  })
  description = "Configuration object for the virtual machine, including all required and optional parameters."
}
variable "load_balancer_config" {
  type = object({
    name                = string
    resource_group_name = string
    location            = string
    sku                 = optional(string, "Standard")
    frontend_ip_configurations = optional(list(object({
      name                 = string
      public_ip_address_id = optional(string)
      private_ip_address   = optional(string)
      private_ip_allocation_method = optional(string, "Dynamic")
      subnet_id            = optional(string)
    })), [])
    backend_address_pool = optional(list(object({
      name = string
    })), [])
    probes = optional(list(object({
      name                = string
      protocol            = string
      port                = number
      interval_in_seconds = optional(number, 5)
      number_of_probes    = optional(number, 2)
    })), [])
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
    })), [])
    tags = optional(map(string), {})
  })
  description = "Configuration object for the Azure Load Balancer resource."
}
variable "storage_account_config" {
  description = "Configuration object for the Azure storage account module."
  type = object({
    name                     = string
    resource_group_name      = string
    location                 = string
    account_tier             = string
    account_replication_type = string
    enable_https_traffic_only = optional(bool)
    tags                     = optional(map(string))
  })
}
variable "sql_server_config" {
  type = object({
    name                = string
    resource_group_name = string
    location            = string
    administrator_login = string
    administrator_password = string
    version             = optional(string, "12.0")
    tags                = optional(map(string), {})
  })
  description = "Configuration object for the SQL Server resource, including all required and optional parameters."
}

variable "private_dns_zone_config" {
  description = "Configuration object for the private DNS zone module."
  type = object({
    name                = string
    resource_group_name = string
    tags                = optional(map(string))
    virtual_network_links = optional(list(object({
      name                 = string
      virtual_network_id   = string
      registration_enabled = optional(bool)
    })))
  })
}
