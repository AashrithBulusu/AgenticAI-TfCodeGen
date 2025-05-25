variable "network_security_group_config" {
  description = "Configuration object for the Network Security Group module."
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
      source_port_ranges         = optional(list(string))
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
    name                      = string
    location                  = string
    resource_group_name       = string
    subnet_id                 = string
    private_ip_address        = optional(string)
    private_ip_address_allocation = optional(string)
    enable_ip_forwarding      = optional(bool)
    dns_servers               = optional(list(string))
    tags                      = optional(map(string))
  })
}
variable "virtual_machine_config" {
  description = "Configuration object for the Stack HCI Virtual Machine Instance module."
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
    name                = string  # Required. The name of the Load Balancer.
    resource_group_name = string  # Required. The name of the resource group where the Load Balancer will be created.
    location            = string  # Required. The Azure region where the Load Balancer will be deployed.
    frontend_ip_configurations = list(object({
      name                 = string  # Required. The name of the frontend IP configuration.
      private_ip_address   = optional(string)  # Optional. The private IP address to assign to the frontend configuration.
      private_ip_allocation = string  # Required. The allocation method for the private IP (Static or Dynamic).
      subnet_id            = string  # Required. The ID of the subnet for the frontend IP configuration.
      public_ip_id         = optional(string)  # Optional. The ID of the public IP to associate with the frontend configuration.
    })) # Required. List of frontend IP configurations.
    backend_address_pools = optional(list(object({
      name = string  # Required. The name of the backend address pool.
    })), []) # Optional. List of backend address pools. Defaults to an empty list.
    probes = optional(list(object({
      name                = string  # Required. The name of the probe.
      protocol            = string  # Required. The protocol for the probe (Http, Tcp, etc.).
      port                = number  # Required. The port for the probe.
      request_path        = optional(string)  # Optional. The HTTP request path for the probe (only for Http protocol).
      interval_in_seconds = number  # Required. The interval in seconds between probe attempts.
      number_of_probes    = number  # Required. The number of failed probes before marking the instance unhealthy.
    })), []) # Optional. List of health probes. Defaults to an empty list.
    load_balancing_rules = optional(list(object({
      name                          = string  # Required. The name of the load balancing rule.
      frontend_ip_configuration_name = string  # Required. The name of the frontend IP configuration to use.
      backend_address_pool_name     = string  # Required. The name of the backend address pool to use.
      probe_name                    = optional(string)  # Optional. The name of the probe to associate with the rule.
      protocol                      = string  # Required. The protocol for the rule (Tcp, Udp, etc.).
      frontend_port                 = number  # Required. The frontend port for the rule.
      backend_port                  = number  # Required. The backend port for the rule.
      idle_timeout_in_minutes       = optional(number)  # Optional. The idle timeout in minutes for the rule.
      enable_floating_ip            = optional(bool)  # Optional. Whether to enable floating IP for the rule.
    })), []) # Optional. List of load balancing rules. Defaults to an empty list.
    tags = optional(map(string)) # Optional. A map of tags to assign to the Load Balancer.
  })
}
variable "storage_account_config" {
  description = "Configuration object for the storage account module."
  type = object({
    name                        = string
    resource_group_name         = string
    location                    = string
    account_tier                = string
    account_replication_type    = string
    enable_https_traffic_only   = optional(bool, true)
    is_hns_enabled              = optional(bool, false)
    account_kind                = optional(string, "StorageV2")
    access_tier                 = optional(string, null)
    tags                        = optional(map(string), {})
    custom_domain               = optional(object({
      name          = string
      use_subdomain = optional(bool, false)
    }), null)
    network_rules               = optional(object({
      bypass                     = optional(list(string), ["AzureServices"])
      default_action             = optional(string, "Deny")
      ip_rules                   = optional(list(string), [])
      virtual_network_subnet_ids = optional(list(string), [])
    }), null)
    blob_properties             = optional(object({
      delete_retention_policy = optional(object({
        days = number
      }), null)
    }), null)
    queue_properties            = optional(object({
      logging = optional(object({
        delete                = optional(bool, false)
        read                  = optional(bool, false)
        write                 = optional(bool, false)
        retention_policy_days = optional(number, 7)
      }), null)
    }), null)
    share_properties            = optional(object({
      quota = optional(number, null)
    }), null)
  })
}
variable "sql_server_config" {
  description = "Configuration object for the Azure SQL Server module."
  type = object({
    name                        = string
    resource_group_name         = string
    location                    = string
    administrator_login         = string
    administrator_login_password = string
    version                     = optional(string, "12.0")
    tags                        = optional(map(string), {})
  })
}
variable "subnet_config" {
  description = "Configuration object for the subnet module."
  type = object({
    name                = string                        # Required: Name of the subnet
    address_prefixes    = list(string)                 # Required: List of address prefixes for the subnet
    resource_group_name = string                        # Required: Name of the resource group
    virtual_network_name = string                       # Required: Name of the virtual network
    service_endpoints   = optional(list(string), [])    # Optional: List of service endpoints to associate with the subnet
    delegations         = optional(list(object({        # Optional: List of delegations for the subnet
      name = string
      service_name = string
    })), [])
    private_endpoint_network_policies = optional(string, null) # Optional: Network policies for private endpoints
    private_link_service_network_policies = optional(string, null) # Optional: Network policies for private link services
    nsg_id              = optional(string, null)        # Optional: Network Security Group ID to associate with the subnet
    route_table_id      = optional(string, null)        # Optional: Route Table ID to associate with the subnet
    tags                = optional(map(string), {})     # Optional: Tags to associate with the subnet
  })
}
variable "private_dns_zone_config" {
  type = object({
    name                = string
    resource_group_name = string
    tags                = optional(map(string), {})
    virtual_network_links = optional(list(object({
      name                 = string
      virtual_network_id   = string
      registration_enabled = optional(bool, false)
    })), [])
  })
  description = "Configuration object for the Private DNS Zone module, including required and optional inputs."
}
