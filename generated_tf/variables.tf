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
      destination_port_range     = optional(string)
      source_port_ranges         = optional(list(string))
      destination_port_ranges    = optional(list(string))
      source_address_prefix      = optional(string)
      destination_address_prefix = optional(string)
      source_address_prefixes    = optional(list(string))
      destination_address_prefixes = optional(list(string))
    })), [])
  })
}
variable "network_interface_config" {
  type = object({
    name                        = string
    location                    = string
    resource_group_name         = string
    subnet_id                   = string
    private_ip_address          = optional(string, null)
    private_ip_address_allocation = optional(string, "Dynamic")
    enable_ip_forwarding        = optional(bool, false)
    enable_accelerated_networking = optional(bool, false)
    dns_servers                 = optional(list(string), [])
    tags                        = optional(map(string), {})
  })
  description = "Configuration object for the Network Interface resource."
}
variable "virtual_machine_config" {
  description = "Configuration object for the Stack HCI Virtual Machine Instance."
  type = object({
    name                       = string
    resource_group_name        = string
    location                   = string
    size                       = string
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
    tags                       = optional(map(string))
    availability_set_id        = optional(string)
    custom_data                = optional(string)
    enable_automatic_updates   = optional(bool)
    license_type               = optional(string)
    priority                   = optional(string)
    zone                       = optional(string)
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
      private_ip_address   = optional(string)  # Optional. The private IP address to assign to the frontend configuration.
      private_ip_allocation = string  # Required. The allocation method for the private IP (Dynamic or Static).
      subnet_id            = string  # Required. The ID of the subnet for the frontend IP configuration.
      public_ip_id         = optional(string)  # Optional. The ID of the public IP to associate with the frontend configuration.
    })) # Required. A list of frontend IP configurations.
    backend_address_pools = optional(list(object({
      name = string  # Required. The name of the backend address pool.
    })), []) # Optional. A list of backend address pools.
    probes = optional(list(object({
      name                = string  # Required. The name of the probe.
      protocol            = string  # Required. The protocol used by the probe (Http, Tcp).
      port                = number  # Required. The port used by the probe.
      request_path        = optional(string)  # Optional. The request path for HTTP probes.
      interval_in_seconds = number  # Required. The interval between probe attempts.
      number_of_probes    = number  # Required. The number of failed probes before marking unhealthy.
    })), []) # Optional. A list of health probes.
    load_balancing_rules = optional(list(object({
      name                          = string  # Required. The name of the load balancing rule.
      frontend_ip_configuration_name = string  # Required. The name of the frontend IP configuration to use.
      backend_address_pool_name     = string  # Required. The name of the backend address pool to use.
      probe_name                    = optional(string)  # Optional. The name of the probe to associate with the rule.
      protocol                      = string  # Required. The protocol for the rule (Tcp, Udp).
      frontend_port                 = number  # Required. The frontend port for the rule.
      backend_port                  = number  # Required. The backend port for the rule.
      idle_timeout_in_minutes       = optional(number)  # Optional. The idle timeout for the rule in minutes.
      enable_floating_ip            = optional(bool)  # Optional. Whether to enable floating IP for the rule.
    })), []) # Optional. A list of load balancing rules.
    tags = optional(map(string)) # Optional. A map of tags to assign to the load balancer.
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
    allow_blob_public_access    = optional(bool, false)
    min_tls_version             = optional(string, "TLS1_2")
    tags                        = optional(map(string), {})
  })
}
variable "sql_server_config" {
  description = "Configuration object for Azure SQL Server."
  type = object({
    name                      = string
    resource_group_name       = string
    location                  = string
    administrator_login       = string
    administrator_password    = string
    version                   = optional(string, "12.0")
    tags                      = optional(map(string))
    identity_type             = optional(string, "SystemAssigned")
    minimum_tls_version       = optional(string, "1.2")
    public_network_access     = optional(string, "Enabled")
    extended_auditing_policy  = optional(object({
      storage_account_access_key = string
      storage_account_name       = string
      storage_endpoint           = string
      retention_in_days          = number
    }))
  })
}
variable "subnet_config" {
  description = "Configuration object for the subnet module."
  type = object({
    name                = string                    # Required: Name of the subnet
    address_prefixes    = list(string)             # Required: List of address prefixes for the subnet
    resource_group_name = string                    # Required: Name of the resource group
    virtual_network_name = string                   # Required: Name of the virtual network
    network_security_group_id = optional(string)    # Optional: ID of the network security group to associate
    route_table_id           = optional(string)     # Optional: ID of the route table to associate
    service_endpoints        = optional(list(string)) # Optional: List of service endpoints to associate
    delegations              = optional(list(object({
      name = string
      service_name = string
    })))                                            # Optional: List of delegations for the subnet
    private_endpoint_network_policies = optional(string) # Optional: Enable or disable private endpoint network policies
    private_link_service_network_policies = optional(string) # Optional: Enable or disable private link service network policies
    tags                     = optional(map(string)) # Optional: Tags to associate with the subnet
  })
}
variable "private_dns_zone_config" {
  description = "Configuration object for the Private DNS Zone module."
  type = object({
    name                = string
    resource_group_name = string
    location            = optional(string)
    tags                = optional(map(string))
    zone_name           = string
    records             = optional(list(object({
      name        = string
      type        = string
      ttl         = number
      value       = list(string)
      metadata    = optional(map(string))
    })))
    virtual_network_links = optional(list(object({
      name                  = string
      virtual_network_id    = string
      registration_enabled  = optional(bool)
      tags                  = optional(map(string))
    })))
  })
}
