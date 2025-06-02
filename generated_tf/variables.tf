variable "network_security_group_config" {
  description = "Configuration object for the Network Security Group module."
  type = object({
    name                = string
    location            = string
    resource_group_name = string
    tags                = optional(map(string), {})
    security_rules = optional(list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = optional(string)
      source_port_ranges         = optional(list(string))
      destination_port_range     = optional(string)
      destination_port_ranges    = optional(list(string))
      source_address_prefix      = optional(string)
      source_address_prefixes    = optional(list(string))
      destination_address_prefix = optional(string)
      destination_address_prefixes = optional(list(string))
    })), [])
  })
}
variable "network_interface_config" {
  description = "Configuration object for the Network Interface module."
  type = object({
    name                        = string
    location                    = string
    resource_group_name         = string
    enable_accelerated_networking = optional(bool, false)
    enable_ip_forwarding        = optional(bool, false)
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
    name                       = string
    resource_group_name        = string
    location                   = string
    vm_size                    = string
    admin_username             = string
    admin_password             = string
    network_interface_ids      = list(string)
    os_disk                    = object({
      caching              = string
      storage_account_type = string
      disk_size_gb         = number
    })
    data_disks                 = optional(list(object({
      caching              = string
      storage_account_type = string
      disk_size_gb         = number
      lun                  = number
    })))
    custom_data                = optional(string)
    tags                       = optional(map(string))
  })
}
variable "load_balancer_config" {
  description = "Configuration object for the Load Balancer module."
  type = object({
    name                = string  # Required. The name of the load balancer.
    resource_group_name = string  # Required. The name of the resource group where the load balancer will be created.
    location            = string  # Required. The Azure region where the load balancer will be deployed.
    frontend_ip_configurations = list(object({
      name                 = string  # Required. The name of the frontend IP configuration.
      private_ip_address   = optional(string)  # Optional. The private IP address to assign to the frontend IP configuration.
      private_ip_allocation = string  # Required. The allocation method for the private IP address (Static or Dynamic).
      subnet_id            = string  # Required. The ID of the subnet to associate with the frontend IP configuration.
      public_ip_address_id = optional(string)  # Optional. The ID of the public IP address to associate with the frontend IP configuration.
    }))
    backend_address_pools = optional(list(object({
      name = string  # Required. The name of the backend address pool.
    })), [])  # Optional. A list of backend address pools. Defaults to an empty list.
    load_balancer_rules = optional(list(object({
      name                            = string  # Required. The name of the load balancing rule.
      frontend_ip_configuration_name  = string  # Required. The name of the frontend IP configuration to use.
      backend_address_pool_name       = string  # Required. The name of the backend address pool to use.
      protocol                        = string  # Required. The transport protocol for the rule (TCP, UDP, or All).
      frontend_port                   = number  # Required. The port on the load balancer to listen on.
      backend_port                    = number  # Required. The port to send traffic to on the backend.
      enable_floating_ip              = optional(bool, false)  # Optional. Whether to enable floating IP. Defaults to false.
      idle_timeout_in_minutes         = optional(number, 4)  # Optional. The timeout for idle connections in minutes. Defaults to 4.
      load_distribution               = optional(string, "Default")  # Optional. The load distribution policy. Defaults to "Default".
    })), [])  # Optional. A list of load balancing rules. Defaults to an empty list.
    probes = optional(list(object({
      name                = string  # Required. The name of the probe.
      protocol            = string  # Required. The protocol used by the probe (HTTP, TCP).
      port                = number  # Required. The port used by the probe.
      request_path        = optional(string)  # Optional. The HTTP request path for the probe (required for HTTP probes).
      interval_in_seconds = optional(number, 15)  # Optional. The interval between probe attempts in seconds. Defaults to 15.
      number_of_probes    = optional(number, 2)  # Optional. The number of failed probes before marking the endpoint as unhealthy. Defaults to 2.
    })), [])  # Optional. A list of probes. Defaults to an empty list.
    tags = optional(map(string), {})  # Optional. A map of tags to assign to the load balancer. Defaults to an empty map.
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
    name                      = string
    resource_group_name       = string
    location                  = string
    administrator_login       = string
    administrator_password    = string
    version                   = optional(string, "12.0")
    identity_type             = optional(string, "SystemAssigned")
    tags                      = optional(map(string))
    minimum_tls_version       = optional(string, "1.2")
    public_network_access     = optional(string, "Enabled")
    extended_auditing_policy  = optional(object({
      storage_account_access_key = optional(string)
      storage_account_id         = optional(string)
      retention_in_days          = optional(number)
      state                      = optional(string, "Disabled")
    }))
  })
}

variable "private_dns_zone_config" {
  description = "Configuration object for the Private DNS Zone module."
  type = object({
    name                = string
    resource_group_name = string
    tags                = optional(map(string), {})
    zone_name           = string
    registration_enabled = optional(bool, false)
    resolution_enabled   = optional(bool, false)
    virtual_network_links = optional(list(object({
      name                 = string
      virtual_network_id   = string
      registration_enabled = optional(bool, false)
    })), [])
  })
}
