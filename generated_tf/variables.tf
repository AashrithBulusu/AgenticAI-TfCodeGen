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
    dns_servers                 = optional(list(string), [])
    internal_dns_name_label     = optional(string, null)
    tags                        = optional(map(string), {})
    ip_configuration = object({
      name                          = string
      subnet_id                     = string
      private_ip_address_allocation = string
      private_ip_address            = optional(string, null)
      public_ip_address_id          = optional(string, null)
      application_gateway_backend_address_pools_ids = optional(list(string), [])
      load_balancer_backend_address_pools_ids       = optional(list(string), [])
      load_balancer_inbound_nat_rules_ids           = optional(list(string), [])
    })
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
    os_disk_size_gb           = number
    os_disk_type              = string
    data_disks                = optional(list(object({
      size_gb = number
      type    = string
    })))
    tags                      = optional(map(string))
    availability_set_id       = optional(string)
    custom_data               = optional(string)
    enable_automatic_updates  = optional(bool)
    time_zone                 = optional(string)
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
      private_ip_address   = optional(string)  # Optional. The private IP address to assign.
      private_ip_allocation = string  # Required. The allocation method for the private IP (Static or Dynamic).
      subnet_id            = string  # Required. The ID of the subnet to associate with the frontend IP.
      public_ip_id         = optional(string)  # Optional. The ID of the public IP to associate with the frontend IP.
    })) # Required. A list of frontend IP configurations.
    backend_address_pools = optional(list(object({
      name = string  # Required. The name of the backend address pool.
    })), []) # Optional. A list of backend address pools.
    probes = optional(list(object({
      name                = string  # Required. The name of the probe.
      protocol            = string  # Required. The protocol used by the probe (Http, Tcp, etc.).
      port                = number  # Required. The port used by the probe.
      request_path        = optional(string)  # Optional. The request path for HTTP probes.
      interval_in_seconds = optional(number, 5)  # Optional. The interval between probe attempts.
      number_of_probes    = optional(number, 2)  # Optional. The number of probes to determine health.
    })), []) # Optional. A list of health probes.
    load_balancing_rules = optional(list(object({
      name                          = string  # Required. The name of the load balancing rule.
      frontend_ip_configuration_name = string  # Required. The name of the frontend IP configuration to use.
      backend_address_pool_name     = string  # Required. The name of the backend address pool to use.
      probe_name                    = optional(string)  # Optional. The name of the probe to associate with the rule.
      protocol                      = string  # Required. The protocol for the rule (Tcp, Udp, etc.).
      frontend_port                 = number  # Required. The frontend port for the rule.
      backend_port                  = number  # Required. The backend port for the rule.
      idle_timeout_in_minutes       = optional(number, 4)  # Optional. The idle timeout in minutes.
      enable_floating_ip            = optional(bool, false)  # Optional. Whether to enable floating IP.
    })), []) # Optional. A list of load balancing rules.
    tags = optional(map(string), {}) # Optional. A map of tags to assign to the Load Balancer.
  })
}
variable "storage_account_config" {
  description = "Configuration object for the storage account module."
  type = object({
    name                     = string
    resource_group_name      = string
    location                 = string
    account_tier             = string
    account_replication_type = string
    enable_https_traffic_only = optional(bool, true)
    tags                     = optional(map(string), {})
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
  description = "Configuration object for the subnet module"
  type = object({
    name                 = string                # Name of the subnet (required)
    address_prefixes     = list(string)         # Address prefixes for the subnet (required)
    resource_group_name  = string               # Name of the resource group (required)
    virtual_network_name = string               # Name of the virtual network (required)
    service_endpoints    = optional(list(string)) # List of service endpoints (optional)
    delegations          = optional(list(object({ # List of delegations (optional)
      name = string
      service_name = string
    })))
    network_security_group_id = optional(string) # ID of the network security group (optional)
    route_table_id            = optional(string) # ID of the route table (optional)
    enforce_private_link_endpoint_network_policies = optional(bool) # Enforce private link endpoint network policies (optional)
    enforce_private_link_service_network_policies  = optional(bool) # Enforce private link service network policies (optional)
    tags                     = optional(map(string)) # Tags to associate with the subnet (optional)
  })
}
variable "private_dns_zone_config" {
  description = "Configuration object for the Private DNS Zone module."
  type = object({
    name                = string  # Name of the Private DNS Zone
    resource_group_name = string  # Name of the resource group where the Private DNS Zone will be created
    tags                = optional(map(string))  # Tags to associate with the Private DNS Zone
    virtual_network_links = optional(list(object({
      name                 = string  # Name of the virtual network link
      virtual_network_id   = string  # ID of the virtual network to link
      registration_enabled = optional(bool)  # Whether auto-registration of records in the linked virtual network is enabled
    })))  # List of virtual network links for the Private DNS Zone
  })
}
