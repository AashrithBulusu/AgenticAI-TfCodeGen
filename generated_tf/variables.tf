variable "network_security_group_config" {
  type = object({
    location = string # Specifies the Azure region where the Network Security Group will be created. Required.
    name = string # The name of the Network Security Group. Must be unique within the resource group. Required.
    resource_group_name = string # The name of the resource group where the Network Security Group will be created. Required.
    tags = optional(map(string), null) # A map of tags to assign to the Network Security Group. Optional, defaults to null.
    timeouts = optional(object({ # Custom timeouts for create, read, update, and delete operations. Optional, defaults to null.
      create = optional(string) # Timeout for the create operation. Optional, defaults to 30 minutes.
      delete = optional(string) # Timeout for the delete operation. Optional, defaults to 30 minutes.
      read   = optional(string) # Timeout for the read operation. Optional, defaults to 5 minutes.
      update = optional(string) # Timeout for the update operation. Optional, defaults to 30 minutes.
    }), null)
    lock = optional(object({ # Resource lock configuration to prevent accidental deletion or modification. Optional, defaults to null.
      kind = string # The type of lock. Valid values are "CanNotDelete" and "ReadOnly". Required if lock is specified.
      name = optional(string, null) # The name of the lock. If not specified, a default name will be generated. Optional.
    }), null)
    role_assignments = optional(map(object({ # A map of role assignments for the Network Security Group. Optional, defaults to an empty map.
      role_definition_id_or_name = string # The ID or name of the role definition to assign. Required.
      principal_id = string # The ID of the principal (user, group, or service principal) to assign the role to. Required.
      description = optional(string, null) # A description for the role assignment. Optional.
      skip_service_principal_aad_check = optional(bool, false) # Whether to skip the AAD check for service principals. Optional, defaults to false.
      condition = optional(string, null) # A condition to scope the role assignment. Optional.
      condition_version = optional(string, null) # The version of the condition syntax. Optional.
      delegated_managed_identity_resource_id = optional(string, null) # The resource ID of a delegated managed identity. Optional.
      principal_type = optional(string, null) # The type of the principal (e.g., "User", "Group", "ServicePrincipal"). Optional.
    })), {})
    diagnostic_settings = optional(map(object({ # Diagnostic settings for monitoring and logging. Optional, defaults to an empty map.
      name = optional(string, null) # The name of the diagnostic setting. Optional, defaults to a generated name.
      log_categories = optional(set(string), []) # A set of log categories to send to the log analytics workspace. Optional, defaults to an empty set.
      log_groups = optional(set(string), ["allLogs"]) # A set of log groups to send to the log analytics workspace. Optional, defaults to ["allLogs"].
      metric_categories = optional(set(string), ["AllMetrics"]) # A set of metric categories to send to the log analytics workspace. Optional, defaults to ["AllMetrics"].
      log_analytics_destination_type = optional(string, "Dedicated") # The destination type for logs. Valid values are "Dedicated" and "AzureDiagnostics". Optional, defaults to "Dedicated".
      workspace_resource_id = optional(string, null) # The resource ID of the log analytics workspace. Optional.
      storage_account_resource_id = optional(string, null) # The resource ID of the storage account for logs. Optional.
      event_hub_authorization_rule_resource_id = optional(string, null) # The resource ID of the event hub authorization rule. Optional.
      event_hub_name = optional(string, null) # The name of the event hub. Optional.
      marketplace_partner_resource_id = optional(string, null) # The resource ID of the marketplace partner for logs. Optional.
    })), {})
    enable_telemetry = optional(bool, true) # Whether to enable telemetry for the module. Optional, defaults to true.
  })
  description = "Configuration object for the Azure Network Security Group resource."
}
variable "network_interface_config" {
  type = object({
    location                       = string # The Azure location where the network interface should exist. Required.
    name                           = string # The name of the network interface. Required.
    resource_group_name            = string # The name of the resource group in which to create the network interface. Required.
    accelerated_networking_enabled = optional(bool, false) # Specifies whether accelerated networking should be enabled. Optional, default is false.
    dns_servers                    = optional(list(string), null) # List of IP addresses representing DNS servers. Optional, default is null.
    edge_zone                      = optional(string, null) # Specifies the extended location of the network interface. Optional, default is null.
    internal_dns_name_label        = optional(string, null) # The DNS name used for internal communications within the virtual network. Optional, default is null.
    ip_forwarding_enabled          = optional(bool, false) # Specifies whether IP forwarding should be enabled. Optional, default is false.
    tags                           = optional(map(string), null) # Map of tags to assign to the network interface. Optional, default is null.
    ip_configurations = map(object({
      name                                               = string # Name of the IP configuration. Required.
      private_ip_address_allocation                      = optional(string, "Dynamic") # Allocation method for the private IP address. Valid values: "Static", "Dynamic". Optional, default is "Dynamic".
      gateway_load_balancer_frontend_ip_configuration_id = optional(string, null) # ID of the gateway load balancer frontend IP configuration. Optional, default is null.
      primary                                            = optional(bool, null) # Specifies whether this IP configuration is primary. Optional, default is null.
      private_ip_address                                 = optional(string, null) # The private IP address if allocation is "Static". Optional, default is null.
      private_ip_address_version                         = optional(string, "IPv4") # IP address version. Valid values: "IPv4", "IPv6". Optional, default is "IPv4".
      public_ip_address_id                               = optional(string, null) # ID of the associated public IP address. Optional, default is null.
      subnet_id                                          = string # ID of the subnet to associate with the IP configuration. Required.
    })) # Map of IP configurations for the network interface. Required.
    load_balancer_backend_address_pool_association = optional(map(object({
      load_balancer_backend_address_pool_id = string # ID of the load balancer backend address pool. Required.
      ip_configuration_name                 = string # Name of the network interface IP configuration. Required.
    })), null) # Map describing the load balancer association. Optional, default is null.
    application_gateway_backend_address_pool_association = optional(object({
      application_gateway_backend_address_pool_id = string # ID of the application gateway backend address pool. Required.
      ip_configuration_name                       = string # Name of the network interface IP configuration. Required.
    }), null) # Object describing the application gateway association. Optional, default is null.
    application_security_group_ids = optional(list(string), null) # List of application security group IDs. Optional, default is null.
    nat_rule_association = optional(map(object({
      nat_rule_id           = string # ID of the NAT rule. Required.
      ip_configuration_name = string # Name of the network interface IP configuration. Required.
    })), {}) # Map describing the NAT rule association. Optional, default is an empty map.
    network_security_group_ids = optional(list(string), null) # List of network security group IDs. Optional, default is null.
    lock = optional(object({
      kind = string # Type of lock. Valid values: "CanNotDelete", "ReadOnly". Required.
      name = optional(string, null) # Name of the lock. Optional, default is null.
    }), null) # Object describing the resource lock configuration. Optional, default is null.
  })
  description = "Configuration object for the Azure network_interface resource."
}
variable "virtual_machine_config" {
  type = object({
    name = string # The name of the virtual machine. Required. Must be unique within the resource group.
    location = string # The Azure region where the virtual machine will be deployed. Required.
    resource_group_name = string # The name of the resource group where the virtual machine will be created. Required.
    custom_location_id = string # The ID of the custom location for the Azure Stack HCI cluster. Required.
    os_type = string # The operating system type of the virtual machine. Optional. Default: "Windows". Valid values: "Windows", "Linux".
    admin_username = string # The administrator username for the virtual machine. Required.
    admin_password = string # The administrator password for the virtual machine. Required. Sensitive.
    v_cpu_count = number # The number of virtual CPUs assigned to the virtual machine. Optional. Default: 2.
    memory_mb = number # The amount of memory (in MB) assigned to the virtual machine. Optional. Default: 8192.
    dynamic_memory = bool # Whether dynamic memory is enabled for the virtual machine. Optional. Default: true.
    dynamic_memory_min = number # The minimum memory (in MB) when dynamic memory is enabled. Optional. Default: 512.
    dynamic_memory_max = number # The maximum memory (in MB) when dynamic memory is enabled. Optional. Default: 8192.
    dynamic_memory_buffer = number # The buffer memory (in percentage) when dynamic memory is enabled. Optional. Default: 20.
    secure_boot_enabled = bool # Whether secure boot is enabled for the virtual machine. Optional. Default: true.
    image_id = string # The ID of the image to use for the virtual machine. Required.
    logical_network_id = string # The ID of the logical network to use for the NIC. Required.
    private_ip_address = string # The private IP address of the NIC. Optional. Default: "".
    tags = map(string) # A map of tags to assign to the virtual machine. Optional. Default: null.
    lock = object({
      kind = string # The type of lock to apply to the virtual machine. Required. Valid values: "CanNotDelete", "ReadOnly".
      name = optional(string, null) # The name of the lock. Optional. Default: null.
    }) # Lock configuration for the virtual machine. Optional. Default: null.
    role_assignments = map(object({
      role_definition_id_or_name = string # The ID or name of the role definition to assign. Required.
      principal_id = string # The ID of the principal to assign the role to. Required.
      description = optional(string, null) # A description for the role assignment. Optional. Default: null.
      skip_service_principal_aad_check = optional(bool, false) # Whether to skip AAD checks for service principals. Optional. Default: false.
      condition = optional(string, null) # A condition to scope the role assignment. Optional. Default: null.
      condition_version = optional(string, null) # The version of the condition syntax. Optional. Default: null.
      delegated_managed_identity_resource_id = optional(string, null) # The ID of the delegated managed identity resource. Optional. Default: null.
      principal_type = optional(string, null) # The type of principal. Optional. Default: null.
    })) # A map of role assignments for the virtual machine. Optional. Default: {}.
    managed_identities = object({
      system_assigned = optional(bool, false) # Whether to enable a system-assigned managed identity. Optional. Default: false.
      user_assigned_resource_ids = optional(set(string), []) # A set of user-assigned managed identity resource IDs. Optional. Default: [].
    }) # Managed identity configuration for the virtual machine. Optional. Default: {}.
    linux_ssh_config = object({
      publicKeys = list(object({
        keyData = string # The SSH public key data. Required.
        path = string # The path where the SSH key will be stored. Required.
      }))
    }) # SSH configuration for Linux virtual machines. Optional. Default: null.
    windows_ssh_config = object({
      publicKeys = list(object({
        keyData = string # The SSH public key data. Required.
        path = string # The path where the SSH key will be stored. Required.
      }))
    }) # SSH configuration for Windows virtual machines. Optional. Default: null.
    domain_to_join = string # The domain name to join the virtual machine to. Optional. Default: "".
    domain_join_user_name = string # The username with permissions to join the domain. Optional. Default: "".
    domain_join_password = string # The password for the domain join user. Optional. Default: null. Sensitive.
    domain_target_ou = string # The organizational unit in the domain to join. Optional. Default: "".
    domain_join_extension_tags
= map(string) # A map of tags for the domain join extension. Optional. Default: {}.
    boot_diagnostics = object({
      enabled = bool # Whether boot diagnostics are enabled for the virtual machine. Optional. Default: false.
      storage_uri = optional(string, null) # The URI of the storage account for boot diagnostics. Optional. Default: null.
    }) # Boot diagnostics configuration for the virtual machine. Optional. Default: {}.
    availability_set_id = optional(string, null) # The ID of the availability set to use for the virtual machine. Optional. Default: null.
    proximity_placement_group_id = optional(string, null) # The ID of the proximity placement group to use for the virtual machine. Optional. Default: null.
    extensions = list(object({
      name = string # The name of the extension. Required.
      publisher = string # The publisher of the extension. Required.
      type = string # The type of the extension. Required.
      type_handler_version = string # The version of the type handler for the extension. Required.
      auto_upgrade_minor_version = optional(bool, true) # Whether to auto-upgrade minor versions of the extension. Optional. Default: true.
      settings = optional(map(any), {}) # A map of settings for the extension. Optional. Default: {}.
      protected_settings = optional(map(any), {}) # A map of protected settings for the extension. Optional. Default: {}. Sensitive.
    })) # A list of extensions to install on the virtual machine. Optional. Default: [].
    diagnostics_profile = object({
      boot_diagnostics = object({
        enabled = bool # Whether boot diagnostics are enabled. Required.
        storage_uri = optional(string, null) # The URI of the storage account for diagnostics. Optional. Default: null.
      })
    }) # Diagnostics profile for the virtual machine. Optional. Default: {}.
    network_interfaces = list(object({
      name = string # The name of the network interface. Required.
      primary = optional(bool, false) # Whether this is the primary network interface. Optional. Default: false.
      ip_configurations = list(object({
        name = string # The name of the IP configuration. Required.
        private_ip_address = optional(string, null) # The private IP address to assign. Optional. Default: null.
        private_ip_address_version = optional(string, "IPv4") # The IP address version. Optional. Default: "IPv4".
        public_ip_address_id = optional(string, null) # The ID of the public IP address. Optional. Default: null.
        subnet_id = string # The ID of the subnet. Required.
        application_security_groups = optional(list(string), []) # A list of application security group IDs. Optional. Default: [].
      })) # IP configurations for the network interface. Required.
    })) # A list of network interfaces for the virtual machine. Required.
    plan = object({
      name = string # The name of the plan. Required.
      publisher = string # The publisher of the plan. Required.
      product = string # The product of the plan. Required.
    }) # Plan configuration for the virtual machine. Optional. Default: null.
    license_type = optional(string, null) # The license type for the virtual machine. Optional. Default: null. Valid values: "Windows_Server", "None".
    priority = optional(string, "Regular") # The priority of the virtual machine. Optional. Default: "Regular". Valid values: "Regular", "Low", "Spot".
    eviction_policy = optional(string, null) # The eviction policy for the virtual machine. Optional. Default: null. Valid values: "Deallocate", "Delete".
    ultra_ssd_enabled = optional(bool, false) # Whether ultra SSD is enabled for the virtual machine. Optional. Default: false.
    zones = optional(list(string), []) # A list of availability zones for the virtual machine. Optional. Default: [].
  })
  description = "Configuration object for defining the properties of an Azure virtual machine."
}
variable "load_balancer_config" {
  type = object({
    name = string # The name of the load balancer. Required.
    location = string # The Azure region where the load balancer will be deployed. Required.
    resource_group_name = string # The name of the resource group where the load balancer will be deployed. Required.
    sku = optional(string, "Standard") # The SKU of the load balancer. Accepted values are "Basic", "Standard", or "Gateway". Defaults to "Standard".
    sku_tier = optional(string, "Regional") # The SKU tier of the load balancer. Accepted values are "Global" or "Regional". Defaults to "Regional".
    edge_zone = optional(string, null) # Specifies the Edge Zone within the Azure Region where the load balancer should exist. Optional.
    tags = optional(map(string), {}) # A map of tags to assign to the load balancer. Optional.
    frontend_ip_configurations = map(object({
      name = optional(string) # The name of the frontend IP configuration. Optional.
      frontend_private_ip_address = optional(string) # The private IP address to assign to the load balancer. Optional.
      frontend_private_ip_address_allocation = optional(string, "Dynamic") # The allocation method for the private IP address. Accepted values are "Dynamic" or "Static". Defaults to "Dynamic".
      frontend_private_ip_address_version = optional(string) # The version of the private IP address. Accepted values are "IPv4" or "IPv6". Optional.
      frontend_private_ip_subnet_resource_id = optional(string) # The ID of the subnet associated with the private IP configuration. Optional.
      public_ip_address_resource_id = optional(string) # The ID of the public IP address associated with the frontend configuration. Optional.
      create_public_ip_address = optional(bool, false) # Whether to create a new public IP address for the frontend configuration. Defaults to false.
      zones = optional(list(string), ["1", "2", "3"]) # A list of availability zones for the frontend configuration. Defaults to ["1", "2", "3"].
      tags = optional(map(string), {}) # A map of tags to assign to the frontend IP configuration. Optional.
    })) # A map of frontend IP configurations for the load balancer. Required.
    backend_address_pools = map(object({
      name = optional(string, "bepool-1") # The name of the backend address pool. Defaults to "bepool-1".
      virtual_network_resource_id = optional(string) # The ID of the virtual network associated with the backend pool. Optional.
      tunnel_interfaces = optional(map(object({
        identifier = optional(number) # The identifier of the tunnel interface. Optional.
        type = optional(string) # The type of the tunnel interface. Optional.
        protocol = optional(string) # The protocol of the tunnel interface. Optional.
        port = optional(number) # The port of the tunnel interface. Optional.
      })), {}) # A map of tunnel interfaces for the backend pool. Optional.
    })) # A map of backend address pools for the load balancer. Required.
    lb_rules = map(object({
      name = optional(string) # The name of the load balancer rule. Optional.
      frontend_ip_configuration_name = optional(string) # The name of the frontend IP configuration associated with the rule. Optional.
      protocol = optional(string, "Tcp") # The protocol for the rule. Accepted values are "Tcp", "Udp", or "All". Defaults to "Tcp".
      frontend_port = optional(number, 3389) # The frontend port for the rule. Defaults to 3389.
      backend_port = optional(number, 3389) # The backend port for the rule. Defaults to 3389.
      backend_address_pool_resource_ids = optional(list(string)) # A list of backend address pool resource IDs associated with the rule. Optional.
      probe_resource_id = optional(string) # The ID of the probe associated with the rule. Optional.
      enable_floating_ip = optional(bool, false) # Whether to enable floating IP for the rule. Defaults to false.
      idle_timeout_in_minutes = optional(number, 4) # The idle timeout in minutes for the rule. Defaults to 4.
      load_distribution = optional(string, "Default") # The load distribution type for the rule. Accepted values are "Default", "SourceIP", or "SourceIPProtocol". Defaults to "Default".
      disable_outbound_snat = optional(bool, false) # Whether to disable outbound SNAT for the rule. Defaults to false.
      enable_tcp_reset = optional(bool, false) # Whether to enable TCP reset for the rule. Defaults to false.
    })) # A map of load balancer rules for the load balancer. Required.
    probes = map(object({
      name = optional(string) # The name of the probe. Optional.
      protocol = optional(string, "Tcp") # The protocol for the
probe. Accepted values are "Tcp", "Http", or "Https". Defaults to "Tcp".
      port = optional(number, 80) # The port for the probe. Defaults to 80.
      request_path = optional(string) # The request path for the probe when using "Http" or "Https". Optional.
      interval_in_seconds = optional(number, 5) # The interval in seconds between probe attempts. Defaults to 5.
      number_of_probes = optional(number, 2) # The number of consecutive probe failures before marking the endpoint as unhealthy. Defaults to 2.
    })) # A map of probes for the load balancer. Required.
    outbound_rules = map(object({
      name = optional(string) # The name of the outbound rule. Optional.
      frontend_ip_configuration_name = optional(string) # The name of the frontend IP configuration associated with the outbound rule. Optional.
      protocol = optional(string, "All") # The protocol for the outbound rule. Accepted values are "Tcp", "Udp", or "All". Defaults to "All".
      idle_timeout_in_minutes = optional(number, 4) # The idle timeout in minutes for the outbound rule. Defaults to 4.
      allocated_outbound_ports = optional(number) # The number of outbound ports to allocate for the rule. Optional.
      backend_address_pool_resource_id = optional(string) # The ID of the backend address pool associated with the outbound rule. Optional.
    })) # A map of outbound rules for the load balancer. Optional.
  })
  description = "Configuration object for defining an Azure Load Balancer."
}
variable "storage_account_config" {
  type = object({
    account_replication_type          = string # Specifies the replication type of the storage account. Required. Valid values: LRS, GRS, RAGRS, ZRS.
    account_tier                      = string # Specifies the performance tier of the storage account. Required. Valid values: Standard, Premium.
    location                          = string # The Azure region where the storage account will be created. Required.
    name                              = string # The name of the storage account. Required. Must be unique within Azure and follow naming conventions.
    resource_group_name               = string # The name of the resource group where the storage account will be created. Required.
    access_tier                       = optional(string, null) # Specifies the access tier for Blob storage. Optional. Valid values: Hot, Cool. Default is null.
    account_kind                      = string # Specifies the kind of storage account. Required. Valid values: StorageV2, BlobStorage, FileStorage, BlockBlobStorage.
    allow_nested_items_to_be_public   = optional(bool, false) # Allows nested items to be public. Optional. Default is false.
    allowed_copy_scope                = optional(string, null) # Specifies the allowed copy scope. Optional. Valid values: PrivateLink, Azure, null.
    cross_tenant_replication_enabled  = optional(bool, false) # Enables cross-tenant replication. Optional. Default is false.
    default_to_oauth_authentication   = optional(bool, false) # Defaults to OAuth authentication for Azure Files. Optional. Default is false.
    edge_zone                         = optional(string, null) # Specifies the edge zone for the storage account. Optional. Default is null.
    https_traffic_only_enabled        = optional(bool, true) # Enforces HTTPS traffic only. Optional. Default is true.
    infrastructure_encryption_enabled = optional(bool, false) # Enables infrastructure encryption. Optional. Default is false.
    is_hns_enabled                    = optional(bool, false) # Enables hierarchical namespace (HNS) for Data Lake Storage Gen2. Optional. Default is false.
    large_file_share_enabled          = optional(bool, false) # Enables large file shares. Optional. Default is false.
    min_tls_version                   = optional(string, "TLS1_2") # Specifies the minimum TLS version. Optional. Default is TLS1_2. Valid values: TLS1_0, TLS1_1, TLS1_2.
    nfsv3_enabled                     = optional(bool, false) # Enables NFSv3 protocol support. Optional. Default is false.
    public_network_access_enabled     = optional(bool, true) # Enables public network access. Optional. Default is true.
    queue_encryption_key_type         = optional(string, null) # Specifies the encryption key type for queues. Optional. Valid values: Account, Service, null.
    sftp_enabled                      = optional(bool, false) # Enables SFTP protocol support. Optional. Default is false.
    shared_access_key_enabled         = optional(bool, true) # Enables shared access keys. Optional. Default is true.
    table_encryption_key_type         = optional(string, null) # Specifies the encryption key type for tables. Optional. Valid values: Account, Service, null.
    tags                              = optional(map(string), {}) # A map of tags to assign to the storage account. Optional. Default is an empty map.
    azure_files_authentication = optional(object({ # Configuration for Azure Files authentication. Optional. Default is null.
      directory_type                 = string # Specifies the directory type. Required. Valid values: AD, AADDS.
      default_share_level_permission = string # Specifies the default share-level permission. Required. Valid values: None, Read, Write, Full.
      active_directory = optional(object({ # Configuration for Active Directory integration. Optional. Default is null.
        domain_guid         = string # The GUID of the domain. Required.
        domain_name         = string # The name of the domain. Required.
        domain_sid          = string # The SID of the domain. Required.
        forest_name         = string # The name of the forest. Required.
        netbios_domain_name = string # The NetBIOS name of the domain. Required.
        storage_sid         = string # The SID of the storage account. Required.
      }), null)
    }), null)
    blob_properties = optional(object({ # Configuration for Blob storage properties. Optional. Default is null.
      change_feed_enabled           = optional(bool, false) # Enables change feed. Optional. Default is false.
      change_feed_retention_in_days = optional(number, null) # Specifies the retention period for change feed. Optional. Default is null.
      default_service_version       = optional(string, null) # Specifies the default service version. Optional. Default is null.
      last_access_time_enabled      = optional(bool, false) # Enables last access time tracking. Optional. Default is false.
      versioning_enabled            = optional(bool, false) # Enables
versioning. Optional. Default is false.
      delete_retention_policy = optional(object({ # Configuration for delete retention policy. Optional. Default is null.
        days = number # Specifies the number of days to retain deleted blobs. Required.
      }), null)
      container_delete_retention_policy = optional(object({ # Configuration for container delete retention policy. Optional. Default is null.
        days = number # Specifies the number of days to retain deleted containers. Required.
      }), null)
    }), null)
    queue_properties = optional(object({ # Configuration for Queue storage properties. Optional. Default is null.
      logging = optional(object({ # Configuration for logging. Optional. Default is null.
        delete                = bool # Indicates if delete requests should be logged. Required.
        read                  = bool # Indicates if read requests should be logged. Required.
        write                 = bool # Indicates if write requests should be logged. Required.
        retention_in_days     = number # Specifies the number of days to retain logs. Required.
        version               = string # Specifies the version of logging to use. Required.
      }), null)
      hour_metrics = optional(object({ # Configuration for hourly metrics. Optional. Default is null.
        enabled              = bool # Indicates if hourly metrics are enabled. Required.
        include_apis         = bool # Indicates if API metrics are included. Required.
        retention_in_days    = number # Specifies the number of days to retain metrics. Required.
        version              = string # Specifies the version of metrics to use. Required.
      }), null)
      minute_metrics = optional(object({ # Configuration for minute metrics. Optional. Default is null.
        enabled              = bool # Indicates if minute metrics are enabled. Required.
        include_apis         = bool # Indicates if API metrics are included. Required.
        retention_in_days    = number # Specifies the number of days to retain metrics. Required.
        version              = string # Specifies the version of metrics to use. Required.
      }), null)
    }), null)
    routing = optional(object({ # Configuration for routing preferences. Optional. Default is null.
      publish_internet_endpoints = bool # Indicates if internet endpoints are published. Required.
      publish_microsoft_endpoints = bool # Indicates if Microsoft endpoints are published. Required.
      routing_choice = string # Specifies the routing choice. Required. Valid values: InternetRouting, MicrosoftRouting.
    }), null)
  })
  description = "Configuration object for an Azure Storage Account with detailed attributes."
}
variable "sql_server_config" {
  type = object({
    location                                     = string # The Azure region where the SQL Server will be deployed. Required.
    name                                         = string # The name of the SQL Server. Must be unique within the Azure region. Required.
    resource_group_name                          = string # The name of the resource group where the SQL Server will be deployed. Required.
    server_version                               = string # The version of the SQL Server. Valid values are "12.0" or "14.0". Required.
    administrator_login                          = string # The administrator username for the SQL Server. Required.
    administrator_login_password                 = string # The administrator password for the SQL Server. Required.
    connection_policy                            = optional(string, "Default") # The connection policy for the SQL Server. Valid values are "Default", "Proxy", or "Redirect". Optional, defaults to "Default".
    express_vulnerability_assessment_enabled     = optional(bool, false) # Whether to enable Express Vulnerability Assessment. Optional, defaults to false.
    outbound_network_restriction_enabled         = optional(bool, false) # Whether outbound network restrictions are enabled. Optional, defaults to false.
    primary_user_assigned_identity_id            = optional(string, null) # The ID of the primary user-assigned managed identity. Optional.
    public_network_access_enabled                = optional(bool, true) # Whether public network access is enabled for the SQL Server. Optional, defaults to true.
    tags                                         = optional(map(string), {}) # A map of tags to assign to the SQL Server. Optional, defaults to an empty map.
    transparent_data_encryption_key_vault_key_id = optional(string, null) # The Key Vault key ID for Transparent Data Encryption. Optional.
    azuread_administrator = optional(object({ # Configuration for the Azure AD administrator. Optional.
      login_username              = string # The username of the Azure AD administrator. Required if azuread_administrator is set.
      object_id                   = string # The object ID of the Azure AD administrator. Required if azuread_administrator is set.
      azuread_authentication_only = optional(bool, false) # Whether to enable Azure AD authentication only. Optional, defaults to false.
      tenant_id                   = optional(string, null) # The tenant ID of the Azure AD administrator. Optional.
    }), null)
    identity = optional(object({ # Configuration for the managed identity. Optional.
      type                      = string # The type of managed identity. Valid values are "SystemAssigned", "UserAssigned", or "SystemAssigned,UserAssigned". Required if identity is set.
      user_assigned_resource_ids = optional(set(string), []) # A set of user-assigned managed identity resource IDs. Optional, defaults to an empty set.
    }), null)
    lock = optional(object({ # Configuration for the resource lock. Optional.
      kind = string # The type of lock. Valid values are "CanNotDelete" or "ReadOnly". Required if lock is set.
      name = optional(string, null) # The name of the lock. Optional, defaults to a generated name.
    }), null)
    role_assignments = optional(map(object({ # A map of role assignments to create on the SQL Server. Optional.
      role_definition_id_or_name             = string # The ID or name of the role definition to assign. Required.
      principal_id                           = string # The ID of the principal to assign the role to. Required.
      description                            = optional(string, null) # A description of the role assignment. Optional.
      skip_service_principal_aad_check       = optional(bool, false) # Whether to skip the Azure AD check for the service principal. Optional, defaults to false.
      condition                              = optional(string, null) # The condition for the role assignment. Optional.
      condition_version                      = optional(string, null) # The version of the condition syntax. Optional.
      delegated_managed_identity_resource_id = optional(string, null) # The delegated managed identity resource ID. Optional.
      principal_type                         = optional(string, null) # The type of the principal. Optional.
    })), {}) # Defaults to an empty map.
    diagnostic_settings = optional(map(object({ # A map of diagnostic settings to create on the SQL Server. Optional.
      name                                     = optional(string, null) # The name of the diagnostic setting. Optional.
      log_categories                           = optional(set(string), []) # A set of log categories to send to the log analytics workspace. Optional, defaults to an empty set.
      log_groups                               = optional(set(string), ["allLogs"]) # A set of log groups to send to the log analytics workspace. Optional, defaults to ["allLogs"].
      metric_categories                        = optional(set(string), ["AllMetrics"]) # A set of metric categories to send to the log analytics workspace. Optional, defaults to ["AllMetrics"].
      log_analytics_destination_type           = optional(string, "Dedicated") # The destination type for the diagnostic setting. Valid values are "Dedicated" or
"AzureMonitor". Optional, defaults to "Dedicated".
      log_analytics_workspace_id               = string # The ID of the Log Analytics workspace to send diagnostics to. Required.
      storage_account_id                       = optional(string, null) # The ID of the storage account to send diagnostics to. Optional.
      eventhub_authorization_rule_id           = optional(string, null) # The authorization rule ID for the Event Hub. Optional.
      eventhub_name                            = optional(string, null) # The name of the Event Hub. Optional.
    })), {}) # Defaults to an empty map.
  })
  description = "Configuration object for an Azure SQL Server, including properties like location, identity, role assignments, and diagnostic settings."
}

variable "private_dns_zone_config" {
  type = object({
    domain_name = string # The name of the private DNS zone. Required.
    resource_group_name = string # The name of the resource group where the private DNS zone will be created. Required.
    tags = optional(map(string), null) # A map of tags to assign to the private DNS zone. Optional. Default is null.
    soa_record = optional(object({ # Configuration for the SOA record. Optional.
      email = string # The email address for the SOA record. Required.
      expire_time = optional(number, 2419200) # The expire time for the SOA record in seconds. Optional. Default is 2419200.
      minimum_ttl = optional(number, 10) # The minimum TTL for the SOA record in seconds. Optional. Default is 10.
      refresh_time = optional(number, 3600) # The refresh time for the SOA record in seconds. Optional. Default is 3600.
      retry_time = optional(number, 300) # The retry time for the SOA record in seconds. Optional. Default is 300.
      ttl = optional(number, 3600) # The TTL for the SOA record in seconds. Optional. Default is 3600.
      tags = optional(map(string), null) # A map of tags for the SOA record. Optional. Default is null.
    }), null)
    virtual_network_links = optional(map(object({ # A map of virtual network links to associate with the private DNS zone. Optional.
      vnetlinkname = string # The name of the virtual network link. Required.
      vnetid = string # The ID of the virtual network to link. Required.
      autoregistration = optional(bool, false) # Whether auto-registration is enabled for the virtual network link. Optional. Default is false.
      tags = optional(map(string), null) # A map of tags for the virtual network link. Optional. Default is null.
    })), {})
    a_records = optional(map(object({ # A map of A records to create in the private DNS zone. Optional.
      name = string # The name of the A record. Required.
      resource_group_name = string # The resource group name for the A record. Required.
      zone_name = string # The DNS zone name for the A record. Required.
      ttl = number # The TTL for the A record in seconds. Required.
      records = list(string) # A list of IP addresses for the A record. Required.
      tags = optional(map(string), null) # A map of tags for the A record. Optional. Default is null.
    })), {})
    aaaa_records = optional(map(object({ # A map of AAAA records to create in the private DNS zone. Optional.
      name = string # The name of the AAAA record. Required.
      resource_group_name = string # The resource group name for the AAAA record. Required.
      zone_name = string # The DNS zone name for the AAAA record. Required.
      ttl = number # The TTL for the AAAA record in seconds. Required.
      records = list(string) # A list of IPv6 addresses for the AAAA record. Required.
      tags = optional(map(string), null) # A map of tags for the AAAA record. Optional. Default is null.
    })), {})
    cname_records = optional(map(object({ # A map of CNAME records to create in the private DNS zone. Optional.
      name = string # The name of the CNAME record. Required.
      resource_group_name = string # The resource group name for the CNAME record. Required.
      zone_name = string # The DNS zone name for the CNAME record. Required.
      ttl = number # The TTL for the CNAME record in seconds. Required.
      record = string # The canonical name for the CNAME record. Required.
      tags = optional(map(string), null) # A map of tags for the CNAME record. Optional. Default is null.
    })), {})
    mx_records = optional(map(object({ # A map of MX records to create in the private DNS zone. Optional.
      name = optional(string, "@") # The name of the MX record. Optional. Default is "@".
      resource_group_name = string # The resource group name for the MX record. Required.
      zone_name = string # The DNS zone name for the MX record. Required.
      ttl = number # The TTL for the MX record in seconds. Required.
      records = map(object({ # A map of MX record entries. Required.
        preference = number # The preference value for the MX record. Required.
        exchange = string # The mail exchange server for the MX record. Required.
      }))
      tags = optional(map(string), null) # A map of tags for the MX record. Optional. Default is null.
    })), {})
    ptr_records = optional(map(object({ #
name = string # The name of the PTR record. Required.
      resource_group_name = string # The resource group name for the PTR record. Required.
      zone_name = string # The DNS zone name for the PTR record. Required.
      ttl = number # The TTL for the PTR record in seconds. Required.
      records = list(string) # A list of PTR record values. Required.
      tags = optional(map(string), null) # A map of tags for the PTR record. Optional. Default is null.
    })), {})
    srv_records = optional(map(object({ # A map of SRV records to create in the private DNS zone. Optional.
      name = string # The name of the SRV record. Required.
      resource_group_name = string # The resource group name for the SRV record. Required.
      zone_name = string # The DNS zone name for the SRV record. Required.
      ttl = number # The TTL for the SRV record in seconds. Required.
      records = list(object({ # A list of SRV record entries. Required.
        priority = number # The priority of the SRV record. Required.
        weight = number # The weight of the SRV record. Required.
        port = number # The port of the SRV record. Required.
        target = string # The target of the SRV record. Required.
      }))
      tags = optional(map(string), null) # A map of tags for the SRV record. Optional. Default is null.
    })), {})
    txt_records = optional(map(object({ # A map of TXT records to create in the private DNS zone. Optional.
      name = string # The name of the TXT record. Required.
      resource_group_name = string # The resource group name for the TXT record. Required.
      zone_name = string # The DNS zone name for the TXT record. Required.
      ttl = number # The TTL for the TXT record in seconds. Required.
      records = list(string) # A list of text strings for the TXT record. Required.
      tags = optional(map(string), null) # A map of tags for the TXT record. Optional. Default is null.
    })), {})
  })
  description = "Configuration for the private DNS zone, including records and virtual network links."
}
