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
    location                   = string
    resource_group_name        = string
    vm_size                    = string
    admin_username             = string
    admin_password             = string
    network_interface_ids      = list(string)
    os_disk_size_gb            = number
    os_disk_type               = string
    image_reference_publisher  = string
    image_reference_offer      = string
    image_reference_sku        = string
    image_reference_version    = string
    tags                       = map(string)
  })
}
variable "load_balancer_config" {
  description = "Configuration object for the Load Balancer module."
  type = object({
    name                = string  # Name of the Load Balancer
    resource_group_name = string  # Name of the resource group
    location            = string  # Azure region for the Load Balancer
    frontend_ip_configurations = list(object({
      name                 = string  # Name of the frontend IP configuration
      private_ip_address   = optional(string)  # Private IP address (optional)
      private_ip_allocation = string  # Allocation method for the private IP (Static or Dynamic)
      subnet_id            = string  # ID of the subnet
      public_ip_address_id = optional(string)  # ID of the public IP address (optional)
    }))
    backend_address_pools = optional(list(object({
      name = string  # Name of the backend address pool
    })))  # List of backend address pools (optional)
    probes = optional(list(object({
      name                = string  # Name of the probe
      protocol            = string  # Protocol for the probe (e.g., HTTP, TCP)
      port                = number  # Port for the probe
      request_path        = optional(string)  # Request path for HTTP probes (optional)
      interval_in_seconds = number  # Interval between probes in seconds
      number_of_probes    = number  # Number of probes for determining health
    })))  # List of health probes (optional)
    load_balancing_rules = optional(list(object({
      name                          = string  # Name of the load balancing rule
      frontend_ip_configuration_name = string  # Name of the frontend IP configuration
      backend_address_pool_name     = string  # Name of the backend address pool
      probe_name                    = optional(string)  # Name of the probe (optional)
      protocol                      = string  # Protocol for the rule (e.g., TCP, UDP)
      frontend_port                 = number  # Frontend port
      backend_port                  = number  # Backend port
      idle_timeout_in_minutes       = optional(number)  # Idle timeout in minutes (optional)
      enable_floating_ip            = optional(bool)  # Enable floating IP (optional)
    })))  # List of load balancing rules (optional)
    tags = optional(map(string))  # Tags for the Load Balancer (optional)
  })
}
variable "storage_account_config" {
  description = "Configuration object for the storage account module."
  type = object({
    name                        = string
    resource_group_name         = string
    location                    = string
    account_tier                = optional(string, "Standard")
    account_replication_type    = optional(string, "LRS")
    enable_https_traffic_only   = optional(bool, true)
    is_hns_enabled              = optional(bool, false)
    access_tier                 = optional(string, null)
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
    name                      = string # Required: Name of the subnet
    address_prefixes          = list(string) # Required: List of address prefixes for the subnet
    resource_group_name       = string # Required: Name of the resource group
    virtual_network_name      = string # Required: Name of the virtual network
    network_security_group_id = optional(string) # Optional: ID of the network security group
    route_table_id            = optional(string) # Optional: ID of the route table
    service_endpoints         = optional(list(string)) # Optional: List of service endpoints
    delegations               = optional(list(object({ # Optional: List of delegations
      name = string
      service_name = string
      actions = list(string)
    })))
    private_endpoint_network_policies = optional(string) # Optional: Private endpoint network policies
    private_link_service_network_policies = optional(string) # Optional: Private link service network policies
    tags                      = optional(map(string)) # Optional: Tags to associate with the subnet
  })
}
variable "private_dns_zone_config" {
  description = "Configuration object for the Private DNS Zone module."
  type = object({
    name                = string
    resource_group_name = string
    tags                = optional(map(string), {})
    zone_name           = string
    registration_enabled = optional(bool, true)
    resolution_enabled  = optional(bool, true)
    virtual_network_links = optional(list(object({
      name                = string
      virtual_network_id  = string
      registration_enabled = optional(bool, true)
    })), [])
  })
}
