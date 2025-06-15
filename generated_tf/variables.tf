variable "network_security_group_config" {
  type = object({
    location = string # Specifies the Azure location where the resource will be created. Required.
    name = string # Specifies the name of the network security group. Required.
    resource_group_name = string # The name of the resource group in which to create the network security group. Required.
    tags = optional(map(string), null) # A mapping of tags to assign to the resource. Optional, defaults to null.
    timeouts = optional(object({ # Configures timeouts for resource operations. Optional.
      create = optional(string) # Timeout for creating the resource. Optional, defaults to 30 minutes.
      delete = optional(string) # Timeout for deleting the resource. Optional, defaults to 30 minutes.
      read = optional(string) # Timeout for reading the resource. Optional, defaults to 5 minutes.
      update = optional(string) # Timeout for updating the resource. Optional, defaults to 30 minutes.
    }), null)
    lock = optional(object({ # Configures resource lock settings. Optional.
      kind = string # Specifies the type of lock. Required. Valid values: "CanNotDelete", "ReadOnly".
      name = optional(string, null) # Specifies the name of the lock. Optional, defaults to null.
    }), null)
    role_assignments = optional(map(object({ # Configures role assignments for the resource. Optional.
      role_definition_id_or_name = string # The ID or name of the role definition to assign. Required.
      principal_id = string # The ID of the principal to assign the role to. Required.
      description = optional(string, null) # Description of the role assignment. Optional, defaults to null.
      skip_service_principal_aad_check = optional(bool, false) # Skips Azure AD check for service principal. Optional, defaults to false.
      condition = optional(string, null) # Condition for scoping the role assignment. Optional, defaults to null.
      condition_version = optional(string, null) # Version of the condition syntax. Optional, defaults to null.
      delegated_managed_identity_resource_id = optional(string, null) # Resource ID of delegated managed identity. Optional, defaults to null.
      principal_type = optional(string, null) # Type of principal (e.g., User, Group, ServicePrincipal). Optional, defaults to null.
    })), {})
    diagnostic_settings = optional(map(object({ # Configures diagnostic settings for the resource. Optional.
      name = optional(string, null) # Name of the diagnostic setting. Optional, defaults to null.
      log_categories = optional(set(string), []) # Set of log categories to send to the log analytics workspace. Optional, defaults to [].
      log_groups = optional(set(string), ["allLogs"]) # Set of log groups to send to the log analytics workspace. Optional, defaults to ["allLogs"].
      metric_categories = optional(set(string), ["AllMetrics"]) # Set of metric categories to send to the log analytics workspace. Optional, defaults to ["AllMetrics"].
      log_analytics_destination_type = optional(string, "Dedicated") # Destination type for diagnostic logs. Optional, defaults to "Dedicated".
      workspace_resource_id = optional(string, null) # Resource ID of the log analytics workspace. Optional, defaults to null.
      storage_account_resource_id = optional(string, null) # Resource ID of the storage account. Optional, defaults to null.
      event_hub_authorization_rule_resource_id = optional(string, null) # Resource ID of the event hub authorization rule. Optional, defaults to null.
      event_hub_name = optional(string, null) # Name of the event hub. Optional, defaults to null.
      marketplace_partner_resource_id = optional(string, null) # ARM resource ID of the Marketplace partner resource. Optional, defaults to null.
    })), {})
  })
  description = "Configuration object for the Azure network_security_group resource."
}
variable "network_interface_config" {
  type = object({
    location = string # Specifies the Azure region where the network interface will be deployed. Required.
    name = string # The name of the network interface. Must be unique within the resource group. Required.
    resource_group_name = string # The name of the resource group in which the network interface will be created. Required.
    accelerated_networking_enabled = optional(bool, false) # Indicates whether accelerated networking is enabled. Optional, defaults to false.
    dns_servers = optional(list(string), null) # List of DNS server IP addresses for the network interface. Optional, defaults to null.
    edge_zone = optional(string, null) # Specifies the extended location for the network interface. Optional, defaults to null.
    internal_dns_name_label = optional(string, null) # The DNS name label for internal communications within the virtual network. Optional, defaults to null.
    ip_forwarding_enabled = optional(bool, false) # Specifies whether IP forwarding is enabled. Optional, defaults to false.
    tags = optional(map(string), null) # A map of tags to assign to the network interface. Optional, defaults to null.
    ip_configurations = map(object({ # A map of IP configurations for the network interface. Required.
      name = string # The name of the IP configuration. Required.
      private_ip_address_allocation = optional(string, "Dynamic") # Specifies whether the private IP address is static or dynamic. Optional, defaults to "Dynamic".
      private_ip_address = optional(string, null) # The private IP address if allocation is set to "Static". Optional, defaults to null.
      private_ip_address_version = optional(string, "IPv4") # Specifies the IP version (IPv4 or IPv6). Optional, defaults to "IPv4".
      public_ip_address_id = optional(string, null) # The resource ID of the associated public IP address. Optional, defaults to null.
      subnet_id = string # The resource ID of the subnet to associate with the IP configuration. Required.
      gateway_load_balancer_frontend_ip_configuration_id = optional(string, null) # The resource ID of the gateway load balancer frontend IP configuration. Optional, defaults to null.
      primary = optional(bool, null) # Indicates whether this IP configuration is the primary one. Optional, defaults to null.
    }))
    load_balancer_backend_address_pool_association = optional(map(object({ # A map of load balancer backend address pool associations. Optional, defaults to null.
      load_balancer_backend_address_pool_id = string # The resource ID of the load balancer backend address pool. Required.
      ip_configuration_name = string # The name of the network interface IP configuration. Required.
    })), null)
    application_gateway_backend_address_pool_association = optional(object({ # An object describing the application gateway backend address pool association. Optional, defaults to null.
      application_gateway_backend_address_pool_id = string # The resource ID of the application gateway backend address pool. Required.
      ip_configuration_name = string # The name of the network interface IP configuration. Required.
    }), null)
    application_security_group_ids = optional(list(string), null) # List of application security group IDs to associate with the network interface. Optional, defaults to null.
    network_security_group_ids = optional(list(string), null) # List of network security group IDs to associate with the network interface. Optional, defaults to null.
    nat_rule_association = optional(map(object({ # A map describing NAT rule associations for the network interface. Optional, defaults to null.
      nat_rule_id = string # The resource ID of the NAT rule. Required.
      ip_configuration_name = string # The name of the network interface IP configuration. Required.
    })), null)
    lock = optional(object({ # An object describing the resource lock configuration. Optional, defaults to null.
      kind = string # The type of lock (e.g., "CanNotDelete" or "ReadOnly"). Required.
      name = optional(string, null) # The name of the lock. Optional, defaults to null.
    }), null)
  })
  description = "Configuration object for the Azure network_interface resource."
}
variable "azurestackhci_virtual_machine_config" {
  type = object({
    admin_password = string # Admin password for the VM. Type: string. Required.
    admin_username = string # Admin username for the VM. Type: string. Required.
    custom_location_id = string # The custom location ID for the Azure Stack HCI cluster. Type: string. Required.
    image_id = string # The name of a Marketplace Gallery Image already downloaded to the Azure Stack HCI cluster. Type: string. Required.
    location = string # Azure region where the resource should be deployed. Type: string. Required.
    logical_network_id = string # The ID of the logical network to use for the NIC. Type: string. Required.
    name = string # Name of the VM resource. Type: string. Required.
    resource_group_name = string # The resource group where the resources will be deployed. Type: string. Required.
    auto_upgrade_minor_version = optional(bool, true) # Whether to enable auto upgrade minor version. Type: bool. Optional. Default: true.
    data_disk_params = optional(map(object({ # Configuration for additional data disks. Type: map(object). Optional. Default: {}.
      name = string # Name of the data disk. Type: string. Required.
      diskSizeGB = number # Size of the data disk in GB. Type: number. Required.
      dynamic = bool # Whether the disk is dynamic. Type: bool. Required.
      tags = optional(map(string)) # Tags for the data disk. Type: map(string). Optional.
      containerId = optional(string) # Container ID for the data disk. Type: string. Optional.
    })), {})
    domain_join_extension_tags = optional(map(string), null) # Tags of the domain join extension. Type: map(string). Optional. Default: null.
    domain_join_password = optional(string, null) # Password for domain join. Required if domain_to_join is specified. Type: string. Optional. Default: null.
    domain_join_user_name = optional(string, "") # Username for domain join. Required if domain_to_join is specified. Type: string. Optional. Default: "".
    domain_target_ou = optional(string, "") # Organizational unit for domain join. Required if domain_to_join is specified. Type: string. Optional. Default: "".
    domain_to_join = optional(string, "") # Domain to join. Specify to join the VM to a domain. Type: string. Optional. Default: "".
    dynamic_memory = optional(bool, true) # Enable dynamic memory. Type: bool. Optional. Default: true.
    dynamic_memory_buffer = optional(number, 20) # Buffer memory in MB when dynamic memory is enabled. Type: number. Optional. Default: 20.
    dynamic_memory_max = optional(number, 8192) # Maximum memory in MB when dynamic memory is enabled. Type: number. Optional. Default: 8192.
    dynamic_memory_min = optional(number, 512) # Minimum memory in MB when dynamic memory is enabled. Type: number. Optional. Default: 512.
    enable_telemetry = optional(bool, true) # Whether to enable telemetry for the module. Type: bool. Optional. Default: true.
    http_proxy = optional(string, null) # HTTP proxy server URL. Type: string. Optional. Default: null.
    https_proxy = optional(string, null) # HTTPS proxy server URL. Type: string. Optional. Default: null.
    linux_ssh_config = optional(object({ # SSH configuration for Linux. Type: object. Optional. Default: null.
      publicKeys = list(object({
        keyData = string # SSH public key data. Type: string. Required.
        path = string # Path to place the SSH public key. Type: string. Required.
      }))
    }), null)
    lock = optional(object({ # Resource lock configuration. Type: object. Optional. Default: null.
      kind = string # Type of lock. Possible values: "CanNotDelete", "ReadOnly". Type: string. Required.
      name = optional(string, null) # Name of the lock. If not specified, a name will be generated. Type: string. Optional. Default: null.
    }), null)
    managed_identities = optional(object({ # Managed Identity configuration. Type: object. Optional. Default: {}.
      system_assigned = optional(bool, false) # Enable System Assigned Managed Identity. Type: bool. Optional. Default: false.
      user_assigned_resource_ids = optional(set(string), []) # List of User Assigned Managed Identity resource IDs. Type: set(string). Optional. Default: [].
    }), {})
    memory_mb = optional(number, 8192) # Memory in MB for the VM. Type: number. Optional. Default: 8192.
    nic_tags = optional(map(string), null) # Tags for the NIC. Type: map(string). Optional. Default: null
os_disk_params = optional(object({ # Configuration for the OS disk. Type: object. Optional. Default: null.
      name = string # Name of the OS disk. Type: string. Required.
      diskSizeGB = number # Size of the OS disk in GB. Type: number. Required.
      dynamic = bool # Whether the disk is dynamic. Type: bool. Required.
      tags = optional(map(string)) # Tags for the OS disk. Type: map(string). Optional.
      containerId = optional(string) # Container ID for the OS disk. Type: string. Optional.
    }), null)
    private_ip_address = optional(string, null) # Private IP address for the VM. Type: string. Optional. Default: null.
    proxy_vm_tags = optional(map(string), null) # Tags for the proxy VM. Type: map(string). Optional. Default: null.
    public_ip_address_id = optional(string, null) # ID of the public IP address to associate with the VM. Type: string. Optional. Default: null.
    size = optional(string, "Standard_D2s_v3") # Size of the VM. Type: string. Optional. Default: "Standard_D2s_v3".
    tags = optional(map(string), {}) # Tags for the VM resource. Type: map(string). Optional. Default: {}.
    time_zone = optional(string, null) # Time zone for the VM. Type: string. Optional. Default: null.
    vm_extension = optional(object({ # Configuration for VM extensions. Type: object. Optional. Default: null.
      name = string # Name of the VM extension. Type: string. Required.
      publisher = string # Publisher of the VM extension. Type: string. Required.
      type = string # Type of the VM extension. Type: string. Required.
      typeHandlerVersion = string # Version of the type handler. Type: string. Required.
      autoUpgradeMinorVersion = optional(bool, true) # Enable auto upgrade minor version for the extension. Type: bool. Optional. Default: true.
      settings = optional(map(string), {}) # Settings for the VM extension. Type: map(string). Optional. Default: {}.
      protectedSettings = optional(map(string), {}) # Protected settings for the VM extension. Type: map(string). Optional. Default: {}.
    }), null)
    vm_tags = optional(map(string), {}) # Tags for the VM resource. Type: map(string). Optional. Default: {}.
    windows_config = optional(object({ # Windows-specific configuration. Type: object. Optional. Default: null.
      enableAutomaticUpdates = optional(bool, true) # Enable automatic updates for Windows. Type: bool. Optional. Default: true.
      provisionVmAgent = optional(bool, true) # Provision the VM agent for Windows. Type: bool. Optional. Default: true.
      timeZone = optional(string, null) # Time zone for Windows VM. Type: string. Optional. Default: null.
    }), null)
  })
  description = "Configuration for Azure Stack HCI virtual machine deployment."
}
variable "load_balancer_config" {
  type = object({
    location = string # The Azure region where the resources should be deployed. Required.
    name = string # The name of the load balancer. Required.
    resource_group_name = string # The name of the resource group where the load balancer will be deployed. Required.
    sku = optional(string, "Standard") # The SKU of the Azure Load Balancer. Accepted values are `Basic`, `Standard`, and `Gateway`. Defaults to `Standard`.
    sku_tier = optional(string, "Regional") # Specifies the SKU tier of the Load Balancer. Possible values are `Global` and `Regional`. Defaults to `Regional`.
    edge_zone = optional(string, null) # Specifies the Edge Zone within the Azure Region where this Load Balancer should exist. Optional.
    tags = optional(map(string), null) # A map of tags to apply to the Load Balancer. Optional.
    frontend_ip_configurations = map(object({
      name = optional(string) # The name of the frontend IP configuration. Optional.
      frontend_private_ip_address = optional(string) # The private IP address to assign to the Load Balancer. Optional.
      frontend_private_ip_address_allocation = optional(string, "Dynamic") # The allocation method for the private IP address. Accepted values are `Dynamic` or `Static`. Defaults to `Dynamic`.
      frontend_private_ip_address_version = optional(string) # The version of IP for the private IP address. Accepted values are `IPv4` or `IPv6`. Optional.
      frontend_private_ip_subnet_resource_id = optional(string) # The ID of the subnet associated with the IP configuration. Optional.
      gateway_load_balancer_frontend_ip_configuration_id = optional(string) # The ID of the gateway load balancer frontend IP configuration. Optional.
      public_ip_address_resource_id = optional(string) # The ID of the public IP address associated with the Load Balancer. Optional.
      create_public_ip_address = optional(bool, false) # Whether to create a new public IP address for the Load Balancer. Defaults to `false`.
      zones = optional(list(string), ["1", "2", "3"]) # A list of availability zones for the frontend IP configuration. Defaults to `["1", "2", "3"]`.
    })) # A map of frontend IP configurations for the Load Balancer. Required.
    backend_address_pools = map(object({
      name = optional(string, "bepool-1") # The name of the backend address pool. Defaults to `bepool-1`.
      virtual_network_resource_id = optional(string) # The ID of the virtual network associated with the backend pool. Optional.
      tunnel_interfaces = optional(map(object({
        identifier = optional(number) # The identifier of the tunnel interface. Optional.
        type = optional(string) # The type of the tunnel interface. Optional.
        protocol = optional(string) # The protocol of the tunnel interface. Optional.
        port = optional(number) # The port of the tunnel interface. Optional.
      })), {}) # A map of tunnel interfaces for the backend pool. Optional.
    })) # A map of backend address pools for the Load Balancer. Required.
    lb_rules = map(object({
      name = optional(string) # The name of the Load Balancer rule. Optional.
      frontend_ip_configuration_name = optional(string) # The name of the frontend IP configuration associated with the rule. Optional.
      protocol = optional(string, "Tcp") # The transport protocol for the rule. Accepted values are `All`, `Tcp`, or `Udp`. Defaults to `Tcp`.
      frontend_port = optional(number, 3389) # The port for the external endpoint. Defaults to `3389`.
      backend_port = optional(number, 3389) # The port for internal connections. Defaults to `3389`.
      backend_address_pool_resource_ids = optional(list(string)) # A list of IDs referencing backend address pools. Optional.
      enable_floating_ip = optional(bool, false) # Whether to enable floating IP for the rule. Defaults to `false`.
      idle_timeout_in_minutes = optional(number, 4) # The idle timeout in minutes for TCP connections. Defaults to `4`.
      load_distribution = optional(string, "Default") # The load balancing distribution type. Defaults to `Default`.
    })) # A map of Load Balancer rules. Required.
    lb_probes = map(object({
      name = optional(string) # The name of the probe. Optional.
      protocol = optional(string, "Tcp") # The protocol of the probe. Accepted values are `Tcp`, `Http`, or `Https`. Defaults to `Tcp`.
      port = optional(number, 80) # The port on which the probe queries the backend endpoint. Defaults to `80`.
      interval_in_seconds = optional(number, 15) # The interval in seconds between probes. Defaults to `15`.
      probe_threshold = optional(number, 1) # The number
of consecutive probe failures before marking the endpoint as unhealthy. Defaults to `1`.
      request_path = optional(string) # The URI path for HTTP or HTTPS probes. Required if protocol is `Http` or `Https`. Optional.
    })) # A map of Load Balancer probes. Required.
    inbound_nat_rules = map(object({
      name = optional(string) # The name of the inbound NAT rule. Optional.
      frontend_ip_configuration_name = optional(string) # The name of the frontend IP configuration associated with the NAT rule. Optional.
      protocol = optional(string, "Tcp") # The transport protocol for the NAT rule. Accepted values are `Tcp` or `Udp`. Defaults to `Tcp`.
      frontend_port = optional(number) # The port for the external endpoint. Required.
      backend_port = optional(number) # The port for the internal endpoint. Required.
      backend_ip_configuration_id = optional(string) # The ID of the backend IP configuration associated with the NAT rule. Optional.
      enable_floating_ip = optional(bool, false) # Whether to enable floating IP for the NAT rule. Defaults to `false`.
      idle_timeout_in_minutes = optional(number, 4) # The idle timeout in minutes for TCP connections. Defaults to `4`.
    })) # A map of inbound NAT rules. Optional.
    outbound_rules = map(object({
      name = optional(string) # The name of the outbound rule. Optional.
      frontend_ip_configuration_name = optional(string) # The name of the frontend IP configuration associated with the outbound rule. Optional.
      protocol = optional(string, "All") # The transport protocol for the outbound rule. Accepted values are `All`, `Tcp`, or `Udp`. Defaults to `All`.
      idle_timeout_in_minutes = optional(number, 4) # The idle timeout in minutes for outbound connections. Defaults to `4`.
      backend_address_pool_resource_ids = optional(list(string)) # A list of IDs referencing backend address pools. Optional.
    })) # A map of outbound rules. Optional.
  })
  description = "Configuration object for an Azure Load Balancer, including frontend IP configurations, backend pools, rules, probes, and NAT settings."
}
variable "storage_account_config" {
  type = object({
    account_replication_type          = string # Specifies the replication type for the storage account. Required. Valid values: LRS, GRS, RAGRS, ZRS.
    account_tier                      = string # Specifies the performance tier for the storage account. Required. Valid values: Standard, Premium.
    location                          = string # The Azure region where the storage account will be created. Required.
    name                              = string # The name of the storage account. Required. Must be between 3 and 24 characters, lowercase letters and numbers only.
    resource_group_name               = string # The name of the resource group where the storage account will be created. Required.
    access_tier                       = optional(string, null) # Specifies the access tier for BlobStorage or General Purpose v2 accounts. Optional. Valid values: Hot, Cool.
    account_kind                      = string # Specifies the kind of storage account. Required. Valid values: Storage, StorageV2, BlobStorage, FileStorage, BlockBlobStorage.
    allow_nested_items_to_be_public   = optional(bool, false) # Whether nested items can be made public. Optional. Default is false.
    allowed_copy_scope                = optional(string, null) # Specifies the allowed copy scope. Optional. Valid values: PrivateLink, Azure.
    cross_tenant_replication_enabled  = optional(bool, false) # Whether cross-tenant replication is enabled. Optional. Default is false.
    default_to_oauth_authentication   = optional(bool, false) # Whether to default to OAuth authentication. Optional. Default is false.
    edge_zone                         = optional(string, null) # Specifies the edge zone for the storage account. Optional.
    https_traffic_only_enabled        = optional(bool, true) # Whether only HTTPS traffic is allowed. Optional. Default is true.
    infrastructure_encryption_enabled = optional(bool, false) # Whether infrastructure encryption is enabled. Optional. Default is false.
    is_hns_enabled                    = optional(bool, false) # Whether hierarchical namespace is enabled. Optional. Default is false.
    large_file_share_enabled          = optional(bool, false) # Whether large file shares are enabled. Optional. Default is false.
    min_tls_version                   = optional(string, "TLS1_2") # Specifies the minimum TLS version. Optional. Default is TLS1_2. Valid values: TLS1_0, TLS1_1, TLS1_2.
    nfsv3_enabled                     = optional(bool, false) # Whether NFSv3 is enabled. Optional. Default is false.
    public_network_access_enabled     = optional(bool, true) # Whether public network access is enabled. Optional. Default is true.
    queue_encryption_key_type         = optional(string, null) # Specifies the encryption key type for queues. Optional. Valid values: Account, Service.
    sftp_enabled                      = optional(bool, false) # Whether SFTP is enabled. Optional. Default is false.
    shared_access_key_enabled         = optional(bool, true) # Whether shared access keys are enabled. Optional. Default is true.
    table_encryption_key_type         = optional(string, null) # Specifies the encryption key type for tables. Optional. Valid values: Account, Service.
    tags                              = optional(map(string), {}) # A map of tags to assign to the storage account. Optional. Default is an empty map.
    azure_files_authentication = optional(object({ # Configuration for Azure Files authentication. Optional.
      directory_type                 = string # Specifies the directory type. Required. Valid values: AD, AADDS.
      default_share_level_permission = string # Specifies the default share-level permission. Required. Valid values: None, Read, Write, Full.
      active_directory = optional(object({ # Configuration for Active Directory integration. Optional.
        domain_guid         = string # The GUID of the domain. Required.
        domain_name         = string # The name of the domain. Required.
        domain_sid          = string # The SID of the domain. Required.
        forest_name         = string # The name of the forest. Required.
        netbios_domain_name = string # The NetBIOS name of the domain. Required.
        storage_sid         = string # The SID of the storage account. Required.
      }), null)
    }), null)
    blob_properties = optional(object({ # Configuration for blob properties. Optional.
      change_feed_enabled           = optional(bool, false) # Whether change feed is enabled. Optional. Default is false.
      change_feed_retention_in_days = optional(number, null) # Specifies the retention period for change feed in days. Optional.
      default_service_version       = optional(string, null) # Specifies the default service version. Optional.
      last_access_time_enabled      = optional(bool, false) # Whether last access time tracking is enabled. Optional. Default is false.
      versioning_enabled            = optional(bool, false) # Whether blob versioning is enabled. Optional. Default is false.
delete_retention_policy = optional(object({ # Configuration for delete retention policy. Optional.
        days = number # Specifies the number of days to retain deleted blobs. Required.
      }), null)
      container_delete_retention_policy = optional(object({ # Configuration for container delete retention policy. Optional.
        days = number # Specifies the number of days to retain deleted containers. Required.
      }), null)
    }), null)
    queue_properties = optional(object({ # Configuration for queue properties. Optional.
      logging = optional(object({ # Configuration for logging. Optional.
        delete           = optional(bool, false) # Whether delete requests should be logged. Optional. Default is false.
        read             = optional(bool, false) # Whether read requests should be logged. Optional. Default is false.
        write            = optional(bool, false) # Whether write requests should be logged. Optional. Default is false.
        retention_in_days = optional(number, null) # Specifies the retention period for logs in days. Optional.
      }), null)
      hour_metrics = optional(object({ # Configuration for hourly metrics. Optional.
        enabled          = bool # Whether hourly metrics are enabled. Required.
        include_apis     = optional(bool, false) # Whether API metrics are included. Optional. Default is false.
        retention_in_days = optional(number, null) # Specifies the retention period for hourly metrics in days. Optional.
      }), null)
      minute_metrics = optional(object({ # Configuration for minute metrics. Optional.
        enabled          = bool # Whether minute metrics are enabled. Required.
        include_apis     = optional(bool, false) # Whether API metrics are included. Optional. Default is false.
        retention_in_days = optional(number, null) # Specifies the retention period for minute metrics in days. Optional.
      }), null)
    }), null)
    routing = optional(object({ # Configuration for routing preferences. Optional.
      publish_internet_endpoints = optional(bool, true) # Whether internet endpoints are published. Optional. Default is true.
      publish_microsoft_endpoints = optional(bool, true) # Whether Microsoft endpoints are published. Optional. Default is true.
      choice = optional(string, null) # Specifies the routing choice. Optional. Valid values: InternetRouting, MicrosoftRouting.
    }), null)
  })
  description = "Configuration object for an Azure Storage Account, including replication, tier, networking, and advanced settings."
}
variable "sql_server_config" {
  type = object({
    location                                     = string # The Azure region where the SQL Server will be deployed. Required.
    name                                         = string # The name of the SQL Server. Must be unique within the Azure region. Required.
    resource_group_name                          = string # The name of the resource group where the SQL Server will be deployed. Required.
    server_version                               = string # The version of the SQL Server. Valid values: "12.0", "14.0", "15.0". Required.
    administrator_login                          = string # The administrator username for the SQL Server. Required.
    administrator_login_password                 = string # The administrator password for the SQL Server. Required.
    connection_policy                            = string # The connection policy for the SQL Server. Valid values: "Default", "Proxy", "Redirect". Optional, default is "Default".
    express_vulnerability_assessment_enabled     = bool # Whether to enable Express Vulnerability Assessment. Optional, default is false.
    outbound_network_restriction_enabled         = bool # Whether to enable outbound network restrictions. Optional, default is false.
    primary_user_assigned_identity_id            = optional(string, null) # The ID of the primary user-assigned identity. Optional.
    public_network_access_enabled                = bool # Whether public network access is enabled for the SQL Server. Optional, default is true.
    tags                                         = optional(map(string), {}) # A map of tags to assign to the SQL Server. Optional.
    transparent_data_encryption_key_vault_key_id = optional(string, null) # The Key Vault key ID for Transparent Data Encryption. Optional.
    azuread_administrator = optional(object({ # Configuration for Azure AD administrator. Optional.
      login_username              = string # The login username for the Azure AD administrator. Required.
      object_id                   = string # The object ID of the Azure AD administrator. Required.
      azuread_authentication_only = bool # Whether to enable Azure AD authentication only. Optional, default is false.
      tenant_id                   = string # The tenant ID of the Azure AD administrator. Required.
    }), null)
    identity = optional(object({ # Configuration for managed identities. Optional.
      type                        = string # The type of managed identity. Valid values: "SystemAssigned", "UserAssigned", "SystemAssigned,UserAssigned". Required.
      user_assigned_resource_ids  = optional(set(string), []) # A set of user-assigned managed identity resource IDs. Optional.
    }), null)
    lock = optional(object({ # Configuration for resource locks. Optional.
      kind = string # The type of lock. Valid values: "CanNotDelete", "ReadOnly". Required.
      name = optional(string, null) # The name of the lock. Optional, default is generated based on the lock kind.
    }), null)
    role_assignments = optional(map(object({ # A map of role assignments for the SQL Server. Optional.
      role_definition_id_or_name             = string # The role definition ID or name. Required.
      principal_id                           = string # The principal ID to assign the role to. Required.
      description                            = optional(string, null) # A description for the role assignment. Optional.
      skip_service_principal_aad_check       = optional(bool, false) # Whether to skip the Azure AD check for service principals. Optional, default is false.
      condition                              = optional(string, null) # The condition for the role assignment. Optional.
      condition_version                      = optional(string, null) # The version of the condition syntax. Optional.
      delegated_managed_identity_resource_id = optional(string, null) # The delegated managed identity resource ID. Optional.
      principal_type                         = optional(string, null) # The type of the principal. Valid values: "User", "Group", "ServicePrincipal". Optional.
    })), {})
    diagnostic_settings = optional(map(object({ # A map of diagnostic settings for the SQL Server. Optional.
      name                                     = optional(string, null) # The name of the diagnostic setting. Optional.
      log_categories                           = optional(set(string), []) # A set of log categories to enable. Optional, default is an empty set.
      log_groups                               = optional(set(string), ["allLogs"]) # A set of log groups to enable. Optional, default is ["allLogs"].
      metric_categories                        = optional(set(string), ["AllMetrics"]) # A set of metric categories to enable. Optional, default is ["AllMetrics"].
      log_analytics_destination_type           = optional(string, "Dedicated") # The destination type for logs. Valid values: "Dedicated", "AzureDiagnostics". Optional, default is "Dedicated".
      workspace_resource_id                    = optional(string, null) # The resource ID of the Log Analytics workspace. Optional.
      storage_account_resource_id              = optional(string, null) # The resource ID of the storage account. Optional.
      event_hub_authorization_rule_resource_id = optional(string, null) # The resource ID of the Event Hub
authorization rule. Optional.
      event_hub_name                           = optional(string, null) # The name of the Event Hub. Optional.
    })), {})
  })
  description = "Configuration object for an Azure SQL Server, including settings for identity, role assignments, diagnostic settings, and more."
}
