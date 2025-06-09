variable "network_security_group_config" {
  type = object({
    location = string # Specifies the Azure location where the resource exists. Required.
    name = string # Specifies the name of the network security group. Required.
    resource_group_name = string # The name of the resource group in which to create the network security group. Required.
    tags = optional(map(string), null) # A mapping of tags to assign to the resource. Optional, defaults to null.
    timeouts = optional(object({ # Configuration for resource operation timeouts. Optional.
      create = optional(string) # Timeout for creating the resource. Optional, defaults to 30 minutes.
      delete = optional(string) # Timeout for deleting the resource. Optional, defaults to 30 minutes.
      read = optional(string) # Timeout for reading the resource. Optional, defaults to 5 minutes.
      update = optional(string) # Timeout for updating the resource. Optional, defaults to 30 minutes.
    }), null)
    lock = optional(object({ # Configuration for resource lock. Optional, defaults to null.
      kind = string # The type of lock. Required. Valid values: "CanNotDelete", "ReadOnly".
      name = optional(string, null) # The name of the lock. Optional, defaults to a generated name.
    }), null)
    role_assignments = optional(map(object({ # Map of role assignments for the resource. Optional, defaults to an empty map.
      role_definition_id_or_name = string # The ID or name of the role definition to assign. Required.
      principal_id = string # The ID of the principal to assign the role to. Required.
      description = optional(string, null) # Description of the role assignment. Optional, defaults to null.
      skip_service_principal_aad_check = optional(bool, false) # Skips Azure AD check for service principal. Optional, defaults to false.
      condition = optional(string, null) # Condition for scoping the role assignment. Optional, defaults to null.
      condition_version = optional(string, null) # Version of the condition syntax. Optional, defaults to null.
      delegated_managed_identity_resource_id = optional(string, null) # Resource ID of delegated managed identity. Optional, defaults to null.
      principal_type = optional(string, null) # Type of the principal. Optional, defaults to null. Valid values: "User", "Group", "ServicePrincipal".
    })), {})
    diagnostic_settings = optional(map(object({ # Map of diagnostic settings for the resource. Optional, defaults to an empty map.
      name = optional(string, null) # Name of the diagnostic setting. Optional, defaults to a generated name.
      log_categories = optional(set(string), []) # Set of log categories to send to log analytics workspace. Optional, defaults to an empty set.
      log_groups = optional(set(string), ["allLogs"]) # Set of log groups to send to log analytics workspace. Optional, defaults to ["allLogs"].
      metric_categories = optional(set(string), ["AllMetrics"]) # Set of metric categories to send to log analytics workspace. Optional, defaults to ["AllMetrics"].
      log_analytics_destination_type = optional(string, "Dedicated") # Destination type for diagnostic setting. Optional, defaults to "Dedicated". Valid values: "Dedicated", "AzureDiagnostics".
      workspace_resource_id = optional(string, null) # Resource ID of the log analytics workspace. Optional, defaults to null.
      storage_account_resource_id = optional(string, null) # Resource ID of the storage account. Optional, defaults to null.
      event_hub_authorization_rule_resource_id = optional(string, null) # Resource ID of the event hub authorization rule. Optional, defaults to null.
      event_hub_name = optional(string, null) # Name of the event hub. Optional, defaults to null.
      marketplace_partner_resource_id = optional(string, null) # ARM resource ID of the marketplace partner resource. Optional, defaults to null.
    })), {})
  })
  description = "Configuration object for the Azure network_security_group resource."
}
variable "network_interface_config" {
  type = object({
    location = string # The Azure region where the network interface will be deployed. Required.
    name = string # The name of the network interface. Required.
    resource_group_name = string # The name of the resource group in which the network interface will be created. Required.
    accelerated_networking_enabled = optional(bool, false) # Specifies whether accelerated networking is enabled. Optional, default is false.
    dns_servers = optional(list(string), null) # A list of DNS server IP addresses. Optional, default is null.
    edge_zone = optional(string, null) # Specifies the extended location of the network interface. Optional, default is null.
    internal_dns_name_label = optional(string, null) # The DNS label for internal communications within the virtual network. Optional, default is null.
    ip_forwarding_enabled = optional(bool, false) # Specifies whether IP forwarding is enabled. Optional, default is false.
    tags = optional(map(string), null) # A map of tags to assign to the network interface. Optional, default is null.
    ip_configurations = map(object({ # A map of IP configurations for the network interface. Required.
      name = string # The name of the IP configuration. Required.
      private_ip_address_allocation = optional(string, "Dynamic") # Specifies whether the private IP address is static or dynamic. Optional, default is "Dynamic".
      private_ip_address_version = optional(string, "IPv4") # Specifies the IP version (IPv4 or IPv6). Optional, default is "IPv4".
      private_ip_address = optional(string, null) # The private IP address, required if allocation is "Static". Optional, default is null.
      public_ip_address_id = optional(string, null) # The ID of the associated public IP address. Optional, default is null.
      gateway_load_balancer_frontend_ip_configuration_id = optional(string, null) # The ID of the gateway load balancer frontend IP configuration. Optional, default is null.
      subnet_id = string # The ID of the subnet to which the IP configuration belongs. Required.
      primary = optional(bool, null) # Specifies whether this is the primary IP configuration. Optional, default is null.
    }))
    load_balancer_backend_address_pool_association = optional(map(object({ # A map of load balancer backend address pool associations. Optional, default is null.
      load_balancer_backend_address_pool_id = string # The ID of the load balancer backend address pool. Required.
      ip_configuration_name = string # The name of the IP configuration associated with the backend pool. Required.
    })), null)
    application_gateway_backend_address_pool_association = optional(object({ # An object describing the application gateway backend address pool association. Optional, default is null.
      application_gateway_backend_address_pool_id = string # The ID of the application gateway backend address pool. Required.
      ip_configuration_name = string # The name of the IP configuration associated with the backend pool. Required.
    }), null)
    application_security_group_ids = optional(list(string), null) # A list of application security group IDs. Optional, default is null.
    nat_rule_association = optional(map(object({ # A map of NAT rule associations. Optional, default is null.
      nat_rule_id = string # The ID of the NAT rule. Required.
      ip_configuration_name = string # The name of the IP configuration associated with the NAT rule. Required.
    })), {})
    network_security_group_ids = optional(list(string), null) # A list of network security group IDs. Optional, default is null.
    lock = optional(object({ # An object describing the resource lock configuration. Optional, default is null.
      kind = string # Specifies the type of lock ("CanNotDelete" or "ReadOnly"). Required.
      name = optional(string, null) # The name of the lock. Optional, default is null.
    }), null)
  })
  description = "Configuration object for the Azure network_interface resource."
}
variable "virtual_machine_config" {
  type = object({
    name = string # The name of the virtual machine. Required. Must be unique within the resource group.
    location = string # The Azure region where the virtual machine will be deployed. Required.
    resource_group_name = string # The name of the resource group where the virtual machine will be deployed. Required.
    admin_username = string # The administrator username for the virtual machine. Required.
    admin_password = string # The administrator password for the virtual machine. Required. Sensitive.
    custom_location_id = string # The custom location ID for the Azure Stack HCI cluster. Required.
    image_id = string # The ID of the image to use for the virtual machine. Required.
    memory_mb = number # The amount of memory (in MB) allocated to the virtual machine. Optional. Default: 8192.
    v_cpu_count = number # The number of virtual CPUs allocated to the virtual machine. Optional. Default: 2.
    os_type = string # The operating system type of the virtual machine. Optional. Default: "Windows". Valid values: "Windows", "Linux".
    dynamic_memory = bool # Whether dynamic memory is enabled for the virtual machine. Optional. Default: true.
    dynamic_memory_min = number # The minimum amount of memory (in MB) when dynamic memory is enabled. Optional. Default: 512.
    dynamic_memory_max = number # The maximum amount of memory (in MB) when dynamic memory is enabled. Optional. Default: 8192.
    dynamic_memory_buffer = number # The buffer memory (in percentage) when dynamic memory is enabled. Optional. Default: 20.
    secure_boot_enabled = bool # Whether secure boot is enabled for the virtual machine. Optional. Default: true.
    logical_network_id = string # The ID of the logical network to use for the NIC. Required.
    private_ip_address = string # The private IP address of the NIC. Optional. Default: "".
    tags = optional(map(string)) # A map of tags to assign to the virtual machine. Optional. Default: null.
    nic_tags = optional(map(string)) # A map of tags to assign to the NIC. Optional. Default: null.
    data_disk_params = map(object({ # A map of data disk configurations to attach to the virtual machine. Optional. Default: {}.
      name = string # The name of the data disk. Required.
      diskSizeGB = number # The size of the data disk in GB. Required.
      dynamic = bool # Whether the data disk is dynamically allocated. Required.
      tags = optional(map(string)) # A map of tags to assign to the data disk. Optional.
      containerId = optional(string) # The container ID for the data disk. Optional.
    }))
    domain_to_join = string # The domain name to join the virtual machine to. Optional. Default: "".
    domain_join_user_name = string # The username with permissions to join the domain. Optional. Default: "".
    domain_join_password = string # The password for the domain join user. Optional. Default: null. Sensitive.
    domain_target_ou = string # The organizational unit (OU) to join the virtual machine to. Optional. Default: "".
    domain_join_extension_tags = optional(map(string)) # A map of tags for the domain join extension. Optional. Default: null.
    auto_upgrade_minor_version = bool # Whether to enable auto-upgrade of minor versions. Optional. Default: true.
    enable_telemetry = bool # Whether telemetry is enabled for the module. Optional. Default: true.
    http_proxy = optional(string) # The HTTP proxy server URL. Optional. Default: null. Sensitive.
    https_proxy = optional(string) # The HTTPS proxy server URL. Optional. Default: null. Sensitive.
    no_proxy = list(string) # A list of URLs that bypass the proxy. Optional. Default: [].
    trusted_ca = optional(string) # An alternative CA certificate for proxy connections. Optional. Default: null.
    type_handler_version = string # The version of the type handler to use. Optional. Default: "1.3".
    user_storage_id = string # The user storage ID for storing images. Optional. Default: "".
    linux_ssh_config = optional(object({ # SSH configuration for Linux virtual machines. Optional. Default: null.
      publicKeys = list(object({
        keyData = string # The SSH public key data. Required.
        path = string # The path to place the SSH public key. Required.
      }))
    }))
    windows_ssh_config = optional(object({ # SSH configuration for Windows virtual machines. Optional. Default: null.
      publicKeys = list(object({
        keyData = string # The SSH public key data. Required.
        path = string # The path to place the SSH public key. Required.
      }))
    }))
    lock = optional(object({ # Resource lock configuration for the virtual machine. Optional
level = string # The lock level to apply. Required. Valid values: "CanNotDelete", "ReadOnly".
      notes = optional(string) # Notes about the lock. Optional. Default: null.
    }))
    backup_policy_id = optional(string) # The ID of the backup policy to associate with the virtual machine. Optional. Default: null.
    diagnostics_profile = optional(object({ # Diagnostics profile configuration for the virtual machine. Optional. Default: null.
      boot_diagnostics = optional(object({
        enabled = bool # Whether boot diagnostics is enabled. Required.
        storage_uri = optional(string) # The URI of the storage account for boot diagnostics. Optional.
      }))
    }))
    availability_set_id = optional(string) # The ID of the availability set to associate with the virtual machine. Optional. Default: null.
    proximity_placement_group_id = optional(string) # The ID of the proximity placement group to associate with the virtual machine. Optional. Default: null.
    ultra_ssd_enabled = optional(bool) # Whether Ultra SSD is enabled for the virtual machine. Optional. Default: false.
    eviction_policy = optional(string) # The eviction policy for the virtual machine. Optional. Default: null. Valid values: "Deallocate", "Delete".
    priority = optional(string) # The priority of the virtual machine. Optional. Default: null. Valid values: "Regular", "Low", "Spot".
    max_price = optional(number) # The maximum price you're willing to pay for a Spot virtual machine. Optional. Default: null.
    scheduled_events_profile = optional(object({ # Scheduled events profile configuration for the virtual machine. Optional. Default: null.
      terminate_notification = optional(object({
        enabled = bool # Whether terminate notification is enabled. Required.
        not_before_timeout = string # The timeout duration before termination. Required.
      }))
    }))
  })
  description = "Configuration object for defining the properties of a virtual machine."
}
variable "load_balancer_config" {
  type = object({
    location = string # The Azure region where the resources should be deployed. Required.
    name = string # The name of the load balancer. Required.
    resource_group_name = string # The name of the resource group where the load balancer will be deployed. Required.
    edge_zone = optional(string, null) # Specifies the Edge Zone within the Azure Region where this Public IP and Load Balancer should exist. Optional.
    sku = optional(string, "Standard") # The SKU of the Azure Load Balancer. Accepted values are `Basic`, `Standard`, and `Gateway`. Defaults to `Standard`. Optional.
    sku_tier = optional(string, "Regional") # Specifies the SKU tier of the Load Balancer. Possible values are `Global` and `Regional`. Defaults to `Regional`. Optional.
    tags = optional(map(string), null) # A map of tags to apply to the Load Balancer. Optional.
    frontend_ip_configurations = map(object({
      name = optional(string) # The name of the frontend IP configuration. Optional.
      frontend_private_ip_address = optional(string) # The private IP address to assign to the Load Balancer. Optional.
      frontend_private_ip_address_version = optional(string) # The version of IP for the private IP address. Possible values: `IPv4`, `IPv6`. Optional.
      frontend_private_ip_address_allocation = optional(string, "Dynamic") # The allocation method for the private IP address. Possible values: `Dynamic`, `Static`. Defaults to `Dynamic`. Optional.
      frontend_private_ip_subnet_resource_id = optional(string) # The ID of the subnet associated with the IP configuration. Optional.
      gateway_load_balancer_frontend_ip_configuration_id = optional(string) # The ID of the gateway load balancer frontend IP configuration. Optional.
      public_ip_address_resource_id = optional(string) # The ID of a public IP address to associate with the Load Balancer. Optional.
      create_public_ip_address = optional(bool, false) # Whether to create a new public IP address resource for the Load Balancer. Defaults to `false`. Optional.
      zones = optional(list(string), ["1", "2", "3"]) # A list of availability zones for the frontend IP configuration. Defaults to `["1", "2", "3"]`. Optional.
    })) # A map of objects defining frontend IP configurations. At least one configuration is required.
    backend_address_pools = map(object({
      name = optional(string, "bepool-1") # The name of the backend address pool. Defaults to `bepool-1`. Optional.
      virtual_network_resource_id = optional(string) # The ID of the virtual network associated with the backend pool. Optional.
      tunnel_interfaces = optional(map(object({
        identifier = optional(number) # The identifier of the tunnel interface. Optional.
        type = optional(string) # The type of the tunnel interface. Optional.
        protocol = optional(string) # The protocol of the tunnel interface. Optional.
        port = optional(number) # The port of the tunnel interface. Optional.
      })), {}) # A map of tunnel interfaces for the backend pool. Optional.
    })) # A map of objects defining backend address pools. Optional.
    lb_rules = map(object({
      name = optional(string) # The name of the Load Balancer rule. Optional.
      frontend_ip_configuration_name = optional(string) # The name of the frontend IP configuration associated with the rule. Optional.
      protocol = optional(string, "Tcp") # The transport protocol for the rule. Possible values: `All`, `Tcp`, `Udp`. Defaults to `Tcp`. Optional.
      frontend_port = optional(number, 3389) # The port for the external endpoint. Defaults to `3389`. Optional.
      backend_port = optional(number, 3389) # The port for the internal endpoint. Defaults to `3389`. Optional.
      backend_address_pool_resource_ids = optional(list(string)) # A list of IDs referencing backend address pools. Optional.
      probe_resource_id = optional(string) # The ID of the probe used by the Load Balancer rule. Optional.
      enable_floating_ip = optional(bool, false) # Whether floating IPs are enabled for the rule. Defaults to `false`. Optional.
      idle_timeout_in_minutes = optional(number, 4) # The idle timeout in minutes for TCP connections. Defaults to `4`. Optional.
      load_distribution = optional(string, "Default") # The load balancing distribution type. Defaults to `Default`. Optional.
    })) # A map of objects defining Load Balancer rules. Optional.
    lb_probes = map(object({
      name = optional(string) # The name of the probe. Optional.
      protocol = optional(string, "Tcp") # The protocol of the probe. Possible values: `Http`, `Https`, `Tcp`. Defaults to `Tcp`. Optional.
      port = optional(number, 80)
# The port the probe monitors. Defaults to `80`. Optional.
      request_path = optional(string) # The path used for HTTP or HTTPS probes to determine health status. Optional.
      interval_in_seconds = optional(number, 5) # The interval in seconds between probe attempts. Defaults to `5`. Optional.
      number_of_probes = optional(number, 2) # The number of failed probe attempts before marking the endpoint as unhealthy. Defaults to `2`. Optional.
    })) # A map of objects defining Load Balancer probes. Optional.
    inbound_nat_rules = map(object({
      name = optional(string) # The name of the inbound NAT rule. Optional.
      frontend_ip_configuration_name = optional(string) # The name of the frontend IP configuration associated with the rule. Optional.
      protocol = optional(string, "Tcp") # The transport protocol for the rule. Possible values: `Tcp`, `Udp`. Defaults to `Tcp`. Optional.
      frontend_port = optional(number) # The port for the external endpoint. Required.
      backend_port = optional(number) # The port for the internal endpoint. Required.
      backend_ip_configuration_id = optional(string) # The ID of the backend IP configuration associated with the rule. Optional.
      enable_floating_ip = optional(bool, false) # Whether floating IPs are enabled for the rule. Defaults to `false`. Optional.
      idle_timeout_in_minutes = optional(number, 4) # The idle timeout in minutes for TCP connections. Defaults to `4`. Optional.
    })) # A map of objects defining inbound NAT rules. Optional.
    outbound_rules = map(object({
      name = optional(string) # The name of the outbound rule. Optional.
      frontend_ip_configuration_name = optional(string) # The name of the frontend IP configuration associated with the rule. Optional.
      backend_address_pool_resource_ids = optional(list(string)) # A list of IDs referencing backend address pools. Optional.
      protocol = optional(string, "All") # The transport protocol for the rule. Possible values: `All`, `Tcp`, `Udp`. Defaults to `All`. Optional.
      idle_timeout_in_minutes = optional(number, 4) # The idle timeout in minutes for TCP connections. Defaults to `4`. Optional.
      enable_tcp_reset = optional(bool, false) # Whether to enable TCP reset on idle timeout. Defaults to `false`. Optional.
    })) # A map of objects defining outbound rules. Optional.
  })
  description = "Configuration object for an Azure Load Balancer, including frontend IP configurations, backend pools, rules, and probes."
}
variable "storage_account_config" {
  type = object({
    account_replication_type          = string # Specifies the replication type of the storage account. Valid values are 'LRS', 'GRS', 'RAGRS', 'ZRS'. Required.
    account_tier                      = string # Specifies the performance tier of the storage account. Valid values are 'Standard', 'Premium'. Required.
    location                          = string # The Azure region where the storage account will be created. Required.
    name                              = string # The name of the storage account. Must be unique within Azure. Required.
    resource_group_name               = string # The name of the resource group in which to create the storage account. Required.
    access_tier                       = optional(string, null) # Specifies the access tier for BlobStorage or General Purpose v2 account. Valid values are 'Hot', 'Cool'. Optional.
    account_kind                      = string # Specifies the kind of the storage account. Valid values are 'Storage', 'StorageV2', 'BlobStorage', 'FileStorage', 'BlockBlobStorage'. Required.
    allow_nested_items_to_be_public   = optional(bool, false) # Whether nested items in a container can be made public. Defaults to false. Optional.
    allowed_copy_scope                = optional(string, null) # Specifies the scope allowed for copy operations. Valid values are 'Private', 'AAD'. Optional.
    cross_tenant_replication_enabled  = optional(bool, false) # Whether cross-tenant replication is enabled. Defaults to false. Optional.
    default_to_oauth_authentication   = optional(bool, false) # Whether to default to OAuth authentication for Azure Files. Defaults to false. Optional.
    edge_zone                         = optional(string, null) # Specifies the edge zone where the storage account should be created. Optional.
    https_traffic_only_enabled        = optional(bool, true) # Whether only HTTPS traffic is allowed to the storage account. Defaults to true. Optional.
    infrastructure_encryption_enabled = optional(bool, false) # Whether infrastructure encryption is enabled. Defaults to false. Optional.
    is_hns_enabled                    = optional(bool, false) # Whether the storage account is enabled for hierarchical namespace. Defaults to false. Optional.
    large_file_share_enabled          = optional(bool, false) # Whether large file shares are enabled. Defaults to false. Optional.
    min_tls_version                   = optional(string, "TLS1_2") # Specifies the minimum TLS version to be permitted on requests to the storage account. Valid values are 'TLS1_0', 'TLS1_1', 'TLS1_2'. Defaults to 'TLS1_2'. Optional.
    nfsv3_enabled                     = optional(bool, false) # Whether NFSv3 protocol support is enabled. Defaults to false. Optional.
    public_network_access_enabled     = optional(bool, true) # Whether public network access is enabled. Defaults to true. Optional.
    queue_encryption_key_type         = optional(string, null) # Specifies the key type used for queue encryption. Valid values are 'Account', 'Service'. Optional.
    sftp_enabled                      = optional(bool, false) # Whether SFTP protocol support is enabled. Defaults to false. Optional.
    shared_access_key_enabled         = optional(bool, true) # Whether shared access keys are enabled. Defaults to true. Optional.
    table_encryption_key_type         = optional(string, null) # Specifies the key type used for table encryption. Valid values are 'Account', 'Service'. Optional.
    tags                              = optional(map(string), {}) # A map of tags to assign to the storage account. Defaults to an empty map. Optional.
    azure_files_authentication = optional(object({ # Configuration for Azure Files authentication. Optional.
      directory_type                 = string # Specifies the directory type. Valid values are 'AADDS', 'AD'. Required.
      default_share_level_permission = optional(string, null) # Specifies the default share-level permission. Optional.
      active_directory = optional(object({ # Configuration for Active Directory integration. Optional.
        domain_guid         = string # The GUID of the domain. Required.
        domain_name         = string # The name of the domain. Required.
        domain_sid          = string # The SID of the domain. Required.
        forest_name         = string # The name of the forest. Required.
        netbios_domain_name = string # The NetBIOS name of the domain. Required.
        storage_sid         = string # The SID of the storage account. Required.
      }), null)
    }), null)
    blob_properties = optional(object({ # Configuration for blob service properties. Optional.
      change_feed_enabled           = optional(bool, false) # Whether change feed is enabled. Defaults to false. Optional.
      change_feed_retention_in_days = optional(number, null) # The number of days to retain change feed data. Optional.
      default_service_version       = optional(string, null) # The default service version for requests. Optional.
      last_access_time_enabled      = optional(bool
, false) # Whether last access time tracking is enabled. Defaults to false. Optional.
      container_delete_retention_policy = optional(object({ # Configuration for container delete retention policy. Optional.
        days = number # The number of days to retain deleted containers. Required.
      }), null)
      versioning_enabled = optional(bool, false) # Whether blob versioning is enabled. Defaults to false. Optional.
    }), null)
    queue_properties = optional(object({ # Configuration for queue service properties. Optional.
      logging = optional(object({ # Configuration for logging settings. Optional.
        delete                = optional(bool, false) # Whether delete requests should be logged. Defaults to false. Optional.
        read                  = optional(bool, false) # Whether read requests should be logged. Defaults to false. Optional.
        write                 = optional(bool, false) # Whether write requests should be logged. Defaults to false. Optional.
        retention_policy_days = optional(number, null) # The number of days to retain logs. Optional.
      }), null)
      hour_metrics = optional(object({ # Configuration for hourly metrics. Optional.
        enabled               = bool # Whether hourly metrics are enabled. Required.
        include_apis          = optional(bool, false) # Whether API metrics are included. Defaults to false. Optional.
        retention_policy_days = optional(number, null) # The number of days to retain metrics. Optional.
      }), null)
      minute_metrics = optional(object({ # Configuration for minute metrics. Optional.
        enabled               = bool # Whether minute metrics are enabled. Required.
        include_apis          = optional(bool, false) # Whether API metrics are included. Defaults to false. Optional.
        retention_policy_days = optional(number, null) # The number of days to retain metrics. Optional.
      }), null)
    }), null)
    share_properties = optional(object({ # Configuration for file share service properties. Optional.
      delete_retention_policy = optional(object({ # Configuration for file share delete retention policy. Optional.
        days = number # The number of days to retain deleted file shares. Required.
      }), null)
    }), null)
  })
  description = "Configuration object for an Azure Storage Account with various optional and required attributes."
}
variable "sql_server_config" {
  type = object({
    location                                     = string # The Azure region where the SQL Server will be deployed. Required.
    name                                         = string # The name of the SQL Server. Must be unique within the Azure region. Required.
    resource_group_name                          = string # The name of the resource group where the SQL Server will be deployed. Required.
    server_version                               = string # The version of the SQL Server. Valid values are "12.0", "2.0". Required.
    administrator_login                          = string # The administrator username for the SQL Server. Required.
    administrator_login_password                 = string # The administrator password for the SQL Server. Required.
    connection_policy                            = optional(string, "Default") # The connection policy for the SQL Server. Valid values are "Default", "Proxy", "Redirect". Optional, defaults to "Default".
    express_vulnerability_assessment_enabled     = optional(bool, false) # Whether to enable Express Vulnerability Assessment. Optional, defaults to false.
    outbound_network_restriction_enabled         = optional(bool, false) # Whether to enable outbound network restrictions. Optional, defaults to false.
    primary_user_assigned_identity_id            = optional(string, null) # The resource ID of the primary user-assigned identity. Optional.
    public_network_access_enabled                = optional(bool, true) # Whether public network access is enabled. Optional, defaults to true.
    tags                                         = optional(map(string), {}) # A map of tags to assign to the SQL Server. Optional, defaults to an empty map.
    transparent_data_encryption_key_vault_key_id = optional(string, null) # The Key Vault key ID for Transparent Data Encryption. Optional.
    azuread_administrator = optional(object({ # Configuration for the Azure AD administrator. Optional.
      login_username              = string # The login username for the Azure AD administrator. Required if azuread_administrator is set.
      object_id                   = string # The object ID of the Azure AD administrator. Required if azuread_administrator is set.
      azuread_authentication_only = optional(bool, false) # Whether to enable Azure AD authentication only. Optional, defaults to false.
      tenant_id                   = optional(string, null) # The tenant ID of the Azure AD administrator. Optional.
    }), null)
    identity = optional(object({ # Configuration for the managed identity. Optional.
      type                     = string # The type of managed identity. Valid values are "SystemAssigned", "UserAssigned", or "SystemAssigned,UserAssigned". Required if identity is set.
      user_assigned_resource_ids = optional(set(string), []) # A set of user-assigned managed identity resource IDs. Optional, defaults to an empty set.
    }), null)
    lock = optional(object({ # Configuration for the resource lock. Optional.
      kind = string # The type of lock. Valid values are "CanNotDelete" and "ReadOnly". Required if lock is set.
      name = optional(string, null) # The name of the lock. Optional, defaults to a generated name.
    }), null)
    role_assignments = optional(map(object({ # A map of role assignments to create on the SQL Server. Optional.
      role_definition_id_or_name             = string # The ID or name of the role definition to assign. Required.
      principal_id                           = string # The ID of the principal to assign the role to. Required.
      description                            = optional(string, null) # A description of the role assignment. Optional.
      skip_service_principal_aad_check       = optional(bool, false) # Whether to skip the Azure AD check for the service principal. Optional, defaults to false.
      condition                              = optional(string, null) # The condition for the role assignment. Optional.
      condition_version                      = optional(string, null) # The version of the condition syntax. Optional.
      delegated_managed_identity_resource_id = optional(string, null) # The resource ID of the delegated managed identity. Optional.
      principal_type                         = optional(string, null) # The type of the principal. Valid values are "User", "Group", "ServicePrincipal". Optional.
    })), {})
    diagnostic_settings = optional(map(object({ # A map of diagnostic settings to create on the SQL Server. Optional.
      name                                     = optional(string, null) # The name of the diagnostic setting. Optional, defaults to a generated name.
      log_categories                           = optional(set(string), []) # A set of log categories to send to the log analytics workspace. Optional, defaults to an empty set.
      log_groups                               = optional(set(string), ["allLogs"]) # A set of log groups to send to the log analytics workspace. Optional, defaults to ["allLogs"].
      metric_categories                        = optional(set(string), ["AllMetrics"]) # A set of metric categories to send to the log analytics workspace. Optional, defaults to ["AllMetrics"].
      log_analytics_destination_type           = optional(string, "Dedicated") # The destination type for the
log analytics workspace. Valid values are "Dedicated" and "AzureMonitor". Optional, defaults to "Dedicated".
      log_analytics_workspace_id              = string # The resource ID of the log analytics workspace. Required.
      event_hub_authorization_rule_id         = optional(string, null) # The authorization rule ID for the Event Hub. Optional.
      event_hub_name                          = optional(string, null) # The name of the Event Hub. Optional.
      storage_account_id                      = optional(string, null) # The resource ID of the storage account. Optional.
      storage_account_key                     = optional(string, null) # The access key for the storage account. Optional.
      storage_account_sas_token               = optional(string, null) # The SAS token for the storage account. Optional.
    })), {})
    timeouts = optional(object({ # Configuration for timeouts. Optional.
      create = optional(string, null) # The timeout duration for creating the SQL Server. Optional.
      update = optional(string, null) # The timeout duration for updating the SQL Server. Optional.
      delete = optional(string, null) # The timeout duration for deleting the SQL Server. Optional.
    }), null)
  })
  description = "Configuration object for an Azure SQL Server, including identity, role assignments, diagnostic settings, and more."
}

variable "private_dns_zone_config" {
  type = object({
    domain_name = string # The name of the private DNS zone. Required.
    resource_group_name = string # The name of the resource group where the private DNS zone will be created. Required.
    tags = optional(map(string), null) # A map of tags to assign to the private DNS zone. Optional, defaults to null.
    soa_record = optional(object({
      email        = string # The email address for the SOA record. Required.
      expire_time  = optional(number, 2419200) # The expire time for the SOA record in seconds. Optional, defaults to 2419200.
      minimum_ttl  = optional(number, 10) # The minimum TTL for the SOA record in seconds. Optional, defaults to 10.
      refresh_time = optional(number, 3600) # The refresh time for the SOA record in seconds. Optional, defaults to 3600.
      retry_time   = optional(number, 300) # The retry time for the SOA record in seconds. Optional, defaults to 300.
      ttl          = optional(number, 3600) # The TTL for the SOA record in seconds. Optional, defaults to 3600.
      tags         = optional(map(string), null) # A map of tags to assign to the SOA record. Optional, defaults to null.
    }), null) # Configuration for the SOA record. Optional, defaults to null.
    virtual_network_links = optional(map(object({
      vnetlinkname     = string # The name of the virtual network link. Required.
      vnetid           = string # The ID of the virtual network to link. Required.
      autoregistration = optional(bool, false) # Whether auto-registration is enabled for the virtual network link. Optional, defaults to false.
      tags             = optional(map(string), null) # A map of tags to assign to the virtual network link. Optional, defaults to null.
    })), {}) # A map of virtual network link configurations. Optional, defaults to an empty map.
    a_records = optional(map(object({
      name                = string # The name of the A record. Required.
      resource_group_name = string # The name of the resource group for the A record. Required.
      zone_name           = string # The name of the private DNS zone for the A record. Required.
      ttl                 = number # The TTL for the A record in seconds. Required.
      records             = list(string) # A list of IPv4 addresses for the A record. Required.
      tags                = optional(map(string), null) # A map of tags to assign to the A record. Optional, defaults to null.
    })), {}) # A map of A record configurations. Optional, defaults to an empty map.
    aaaa_records = optional(map(object({
      name                = string # The name of the AAAA record. Required.
      resource_group_name = string # The name of the resource group for the AAAA record. Required.
      zone_name           = string # The name of the private DNS zone for the AAAA record. Required.
      ttl                 = number # The TTL for the AAAA record in seconds. Required.
      records             = list(string) # A list of IPv6 addresses for the AAAA record. Required.
      tags                = optional(map(string), null) # A map of tags to assign to the AAAA record. Optional, defaults to null.
    })), {}) # A map of AAAA record configurations. Optional, defaults to an empty map.
    cname_records = optional(map(object({
      name                = string # The name of the CNAME record. Required.
      resource_group_name = string # The name of the resource group for the CNAME record. Required.
      zone_name           = string # The name of the private DNS zone for the CNAME record. Required.
      ttl                 = number # The TTL for the CNAME record in seconds. Required.
      record              = string # The canonical name for the CNAME record. Required.
      tags                = optional(map(string), null) # A map of tags to assign to the CNAME record. Optional, defaults to null.
    })), {}) # A map of CNAME record configurations. Optional, defaults to an empty map.
    mx_records = optional(map(object({
      name                = optional(string, "@") # The name of the MX record. Optional, defaults to "@".
      resource_group_name = string # The name of the resource group for the MX record. Required.
      zone_name           = string # The name of the private DNS zone for the MX record. Required.
      ttl                 = number # The TTL for the MX record in seconds. Required.
      records = map(object({
        preference = number # The preference value for the MX record. Required.
        exchange   = string # The mail exchange server for the MX record. Required.
      })) #
# A map of MX record configurations. Required.
      tags = optional(map(string), null) # A map of tags to assign to the MX record. Optional, defaults to null.
    })), {}) # A map of MX record configurations. Optional, defaults to an empty map.
    txt_records = optional(map(object({
      name                = string # The name of the TXT record. Required.
      resource_group_name = string # The name of the resource group for the TXT record. Required.
      zone_name           = string # The name of the private DNS zone for the TXT record. Required.
      ttl                 = number # The TTL for the TXT record in seconds. Required.
      records             = list(string) # A list of text strings for the TXT record. Required.
      tags                = optional(map(string), null) # A map of tags to assign to the TXT record. Optional, defaults to null.
    })), {}) # A map of TXT record configurations. Optional, defaults to an empty map.
    srv_records = optional(map(object({
      name                = string # The name of the SRV record. Required.
      resource_group_name = string # The name of the resource group for the SRV record. Required.
      zone_name           = string # The name of the private DNS zone for the SRV record. Required.
      ttl                 = number # The TTL for the SRV record in seconds. Required.
      records = list(object({
        priority = number # The priority value for the SRV record. Required.
        weight   = number # The weight value for the SRV record. Required.
        port     = number # The port number for the SRV record. Required.
        target   = string # The target server for the SRV record. Required.
      })) # A list of SRV record configurations. Required.
      tags = optional(map(string), null) # A map of tags to assign to the SRV record. Optional, defaults to null.
    })), {}) # A map of SRV record configurations. Optional, defaults to an empty map.
    ptr_records = optional(map(object({
      name                = string # The name of the PTR record. Required.
      resource_group_name = string # The name of the resource group for the PTR record. Required.
      zone_name           = string # The name of the private DNS zone for the PTR record. Required.
      ttl                 = number # The TTL for the PTR record in seconds. Required.
      records             = list(string) # A list of PTR record values. Required.
      tags                = optional(map(string), null) # A map of tags to assign to the PTR record. Optional, defaults to null.
    })), {}) # A map of PTR record configurations. Optional, defaults to an empty map.
  }) # Configuration for the private DNS zone.
  description = "Configuration object for the private DNS zone, including records, virtual network links, and SOA record settings."
}
