variable "network_security_group_config" {
  type = object({
    location = string # (Required) The Azure region where the Network Security Group will be created. Example: "East US".
    name = string # (Required) The name of the Network Security Group. Must be unique within the resource group.
    resource_group_name = string # (Required) The name of the resource group where the Network Security Group will be created.
    tags = optional(map(string), {}) # (Optional) A map of tags to assign to the Network Security Group. Default is an empty map.
    timeouts = optional(object({ # (Optional) Custom timeouts for resource operations.
      create = optional(string) # (Optional) Timeout for creating the resource. Default is 30 minutes.
      delete = optional(string) # (Optional) Timeout for deleting the resource. Default is 30 minutes.
      read = optional(string) # (Optional) Timeout for reading the resource. Default is 5 minutes.
      update = optional(string) # (Optional) Timeout for updating the resource. Default is 30 minutes.
    }), null) # Default is null.
    lock = optional(object({ # (Optional) Resource lock configuration.
      kind = string # (Required) The type of lock. Valid values: "CanNotDelete", "ReadOnly".
      name = optional(string, null) # (Optional) The name of the lock. Default is null, and a name will be generated.
    }), null) # Default is null.
    role_assignments = optional(map(object({ # (Optional) Role assignments to associate with the Network Security Group.
      role_definition_id_or_name = string # (Required) The ID or name of the role definition.
      principal_id = string # (Required) The ID of the principal to assign the role to.
      description = optional(string, null) # (Optional) Description of the role assignment. Default is null.
      skip_service_principal_aad_check = optional(bool, false) # (Optional) Skip AAD check for service principal. Default is false.
      condition = optional(string, null) # (Optional) Condition for scoping the role assignment. Default is null.
      condition_version = optional(string, null) # (Optional) Version of the condition syntax. Default is null.
      delegated_managed_identity_resource_id = optional(string, null) # (Optional) Resource ID of the delegated managed identity. Default is null.
      principal_type = optional(string, null) # (Optional) Type of the principal. Valid values: "User", "Group", "ServicePrincipal". Default is null.
    })), {}) # Default is an empty map.
    diagnostic_settings = optional(map(object({ # (Optional) Diagnostic settings for the Network Security Group.
      name = optional(string, null) # (Optional) Name of the diagnostic setting. Default is null.
      log_categories = optional(set(string), []) # (Optional) Log categories to send to the log analytics workspace. Default is an empty set.
      log_groups = optional(set(string), ["allLogs"]) # (Optional) Log groups to send to the log analytics workspace. Default is ["allLogs"].
      metric_categories = optional(set(string), ["AllMetrics"]) # (Optional) Metric categories to send to the log analytics workspace. Default is ["AllMetrics"].
      log_analytics_destination_type = optional(string, "Dedicated") # (Optional) Destination type for logs. Valid values: "Dedicated", "AzureDiagnostics". Default is "Dedicated".
      workspace_resource_id = optional(string, null) # (Optional) Resource ID of the log analytics workspace. Default is null.
      storage_account_resource_id = optional(string, null) # (Optional) Resource ID of the storage account. Default is null.
      event_hub_authorization_rule_resource_id = optional(string, null) # (Optional) Resource ID of the event hub authorization rule. Default is null.
      event_hub_name = optional(string, null) # (Optional) Name of the event hub. Default is null.
      marketplace_partner_resource_id = optional(string, null) # (Optional) Resource ID of the marketplace partner resource. Default is null.
    })), {}) # Default is an empty map.
  })
  description = "Configuration object for the Azure Network Security Group resource."
}
variable "network_interface_config" {
  type = object({
    location                       = string # The Azure region where the network interface will be created. Required.
    name                           = string # The name of the network interface. Required.
    resource_group_name            = string # The name of the resource group where the network interface will be created. Required.
    accelerated_networking_enabled = optional(bool, false) # Specifies whether accelerated networking is enabled. Optional, default is false.
    dns_servers                    = optional(list(string), null) # List of DNS server IP addresses. Optional, default is null.
    edge_zone                      = optional(string, null) # Specifies the extended location of the network interface. Optional, default is null.
    internal_dns_name_label        = optional(string, null) # DNS name used for internal communications within the virtual network. Optional, default is null.
    ip_forwarding_enabled          = optional(bool, false) # Specifies whether IP forwarding is enabled. Optional, default is false.
    tags                           = optional(map(string), null) # Map of tags to assign to the network interface. Optional, default is null.
    ip_configurations = map(object({
      name                                               = string # Name of the IP configuration. Required.
      private_ip_address_allocation                      = optional(string, "Dynamic") # Allocation method for private IP address. Optional, default is "Dynamic". Valid values: "Static", "Dynamic".
      gateway_load_balancer_frontend_ip_configuration_id = optional(string, null) # ID of the gateway load balancer frontend IP configuration. Optional, default is null.
      primary                                            = optional(bool, null) # Specifies whether this is the primary IP configuration. Optional, default is null.
      private_ip_address                                 = optional(string, null) # Static private IP address (if allocation is "Static"). Optional, default is null.
      private_ip_address_version                         = optional(string, "IPv4") # IP version for the private IP address. Optional, default is "IPv4". Valid values: "IPv4", "IPv6".
      public_ip_address_id                               = optional(string, null) # ID of the associated public IP address. Optional, default is null.
      subnet_id                                          = string # ID of the subnet to associate with the IP configuration. Required.
    })) # Map of IP configurations for the network interface. Required.
    load_balancer_backend_address_pool_association = optional(map(object({
      load_balancer_backend_address_pool_id = string # ID of the load balancer backend address pool. Required.
      ip_configuration_name                 = string # Name of the network interface IP configuration. Required.
    })), null) # Map of load balancer backend address pool associations. Optional, default is null.
    application_gateway_backend_address_pool_association = optional(object({
      application_gateway_backend_address_pool_id = string # ID of the application gateway backend address pool. Required.
      ip_configuration_name                       = string # Name of the network interface IP configuration. Required.
    }), null) # Object describing application gateway backend address pool association. Optional, default is null.
    application_security_group_ids = optional(list(string), null) # List of application security group IDs. Optional, default is null.
    nat_rule_association = optional(map(object({
      nat_rule_id           = string # ID of the NAT rule. Required.
      ip_configuration_name = string # Name of the network interface IP configuration. Required.
    })), {}) # Map of NAT rule associations for the network interface. Optional, default is an empty map.
    network_security_group_ids = optional(list(string), null) # List of network security group IDs. Optional, default is null.
    lock = optional(object({
      kind = string # Type of lock. Required. Valid values: "CanNotDelete", "ReadOnly".
      name = optional(string, null) # Name of the lock. Optional, default is null.
    }), null) # Object describing resource lock configuration. Optional, default is null.
  })
  description = "Configuration object for the Azure network_interface resource."
}
variable "virtual_machine_config" {
  type = object({
    admin_password = string # Admin password for the VM. Type: string. Required. Sensitive.
    admin_username = string # Admin username for the VM. Type: string. Required.
    custom_location_id = string # The custom location ID for the Azure Stack HCI cluster. Type: string. Required.
    image_id = string # The name of a Marketplace Gallery Image already downloaded to the Azure Stack HCI cluster. Type: string. Required.
    location = string # Azure region where the resource should be deployed. Type: string. Required.
    logical_network_id = string # The ID of the logical network to use for the NIC. Type: string. Required.
    name = string # Name of the VM resource. Type: string. Required. Must be <= 15 characters and alphanumeric with hyphens.
    resource_group_name = string # The resource group where the resources will be deployed. Type: string. Required.
    auto_upgrade_minor_version = bool # Whether to enable auto upgrade minor version. Type: bool. Optional. Default: true.
    data_disk_params = map(object({ # Configuration for data disks to attach to the VM. Type: map(object). Optional. Default: {}.
      name = string # Name of the data disk. Type: string. Required.
      diskSizeGB = number # Size of the data disk in GB. Type: number. Required.
      dynamic = bool # Whether the disk is dynamic. Type: bool. Required.
      tags = optional(map(string)) # Tags for the data disk. Type: map(string). Optional.
      containerId = optional(string) # Container ID for the data disk. Type: string. Optional.
    }))
    domain_join_extension_tags = map(string) # Tags of the domain join extension. Type: map(string). Optional. Default: null.
    domain_join_password = string # Password for domain join user. Type: string. Optional. Default: null. Sensitive.
    domain_join_user_name = string # Username for domain join. Type: string. Optional. Default: "".
    domain_target_ou = string # Organizational unit for domain join. Type: string. Optional. Default: "".
    domain_to_join = string # Domain name to join. Type: string. Optional. Default: "".
    dynamic_memory = bool # Enable dynamic memory. Type: bool. Optional. Default: true.
    dynamic_memory_buffer = number # Buffer memory in MB when dynamic memory is enabled. Type: number. Optional. Default: 20.
    dynamic_memory_max = number # Maximum memory in MB when dynamic memory is enabled. Type: number. Optional. Default: 8192.
    dynamic_memory_min = number # Minimum memory in MB when dynamic memory is enabled. Type: number. Optional. Default: 512.
    enable_telemetry = bool # Enable telemetry for the module. Type: bool. Required. Default: true.
    http_proxy = string # HTTP proxy server URL. Type: string. Optional. Default: null. Sensitive.
    https_proxy = string # HTTPS proxy server URL. Type: string. Optional. Default: null. Sensitive.
    linux_ssh_config = object({ # SSH configuration for Linux. Type: object. Optional. Default: null.
      publicKeys = list(object({ # List of public keys for SSH. Type: list(object). Required.
        keyData = string # Key data for the SSH public key. Type: string. Required.
        path = string # Path for the SSH public key. Type: string. Required.
      }))
    })
    lock = object({ # Resource lock configuration. Type: object. Optional. Default: null.
      kind = string # Type of lock. Valid values: "CanNotDelete", "ReadOnly". Type: string. Required.
      name = optional(string, null) # Name of the lock. Type: string. Optional. Default: null.
    })
    managed_identities = object({ # Managed identity configuration. Type: object. Optional. Default: {}.
      system_assigned = optional(bool, false) # Enable system-assigned managed identity. Type: bool. Optional. Default: false.
      user_assigned_resource_ids = optional(set(string), []) # User-assigned managed identity resource IDs. Type: set(string). Optional. Default: [].
    })
    memory_mb = number # Memory in MB for the VM. Type: number. Optional. Default: 8192.
    nic_tags = map(string) # Tags for the NIC. Type: map(string). Optional. Default: null.
    no_proxy = list(string) # URLs that bypass proxy. Type: list(string). Optional. Default: [].
    os_type = string # OS type of the VM. Valid values: "Windows", "Linux". Type: string. Optional. Default: "Windows".
    private_ip_address = string # Private IP address of the NIC. Type: string. Optional
. Default: null.
    private_ip_address_version = string # IP address version for the NIC. Valid values: "IPv4", "IPv6". Type: string. Optional. Default: "IPv4".
    processor_count = number # Number of processors for the VM. Type: number. Optional. Default: 2.
    public_ip_address_id = string # ID of the public IP address to associate with the NIC. Type: string. Optional. Default: null.
    public_ip_address_tags = map(string) # Tags for the public IP address. Type: map(string). Optional. Default: null.
    require_guest_provision_signal = bool # Require guest provision signal for the VM. Type: bool. Optional. Default: true.
    secure_boot_enabled = bool # Enable secure boot for the VM. Type: bool. Optional. Default: true.
    storage_account_tags = map(string) # Tags for the storage account. Type: map(string). Optional. Default: null.
    tags = map(string) # Tags for the VM resource. Type: map(string). Optional. Default: {}.
    time_zone = string # Time zone for the VM. Type: string. Optional. Default: null.
    use_custom_location = bool # Use custom location for the VM. Type: bool. Optional. Default: false.
    vm_size = string # Size of the VM. Type: string. Required.
    vnet_id = string # ID of the virtual network to associate with the NIC. Type: string. Required.
    vnet_subnet_id = string # ID of the subnet within the virtual network. Type: string. Required.
    windows_boot_diagnostics_enabled = bool # Enable boot diagnostics for Windows VMs. Type: bool. Optional. Default: true.
    windows_configuration = object({ # Windows-specific configuration for the VM. Type: object. Optional. Default: null.
      enableAutomaticUpdates = optional(bool, true) # Enable automatic updates for Windows. Type: bool. Optional. Default: true.
      provisionVmAgent = optional(bool, true) # Provision VM agent for Windows. Type: bool. Optional. Default: true.
      timeZone = optional(string, null) # Time zone for Windows VM. Type: string. Optional. Default: null.
    })
  })
  description = "Configuration object for defining the virtual machine settings."
}
variable "load_balancer_config" {
  type = object({
    location = string # The Azure region where the resources should be deployed. Required.
    name = string # The name of the load balancer. Required.
    resource_group_name = string # The name of the resource group where the load balancer will be deployed. Required.
    edge_zone = optional(string, null) # Specifies the Edge Zone within the Azure Region where this Load Balancer should exist. Optional.
    sku = optional(string, "Standard") # The SKU of the Azure Load Balancer. Accepted values are `Basic`, `Standard`, and `Gateway`. Optional.
    sku_tier = optional(string, "Regional") # Specifies the SKU tier of this Load Balancer. Possible values are `Global` and `Regional`. Optional.
    tags = optional(map(string), null) # A map of tags to apply to the Load Balancer. Optional.
    frontend_ip_configurations = map(object({
      name = optional(string) # The name of the frontend IP configuration. Optional.
      frontend_private_ip_address = optional(string) # The private IP address to assign to the Load Balancer. Optional.
      frontend_private_ip_address_version = optional(string) # The version of IP for the private IP address. Valid values: `IPv4`, `IPv6`. Optional.
      frontend_private_ip_address_allocation = optional(string, "Dynamic") # The allocation method for the private IP address. Valid values: `Dynamic`, `Static`. Optional.
      frontend_private_ip_subnet_resource_id = optional(string) # The ID of the subnet associated with the IP configuration. Optional.
      gateway_load_balancer_frontend_ip_configuration_id = optional(string) # The ID of the gateway load balancer frontend IP configuration. Optional.
      public_ip_address_resource_id = optional(string) # The ID of the public IP address associated with the Load Balancer. Optional.
      create_public_ip_address = optional(bool, false) # Whether to create a new public IP address resource. Optional.
      zones = optional(list(string), ["1", "2", "3"]) # The availability zones for the frontend IP configuration. Optional.
    })) # A map of frontend IP configurations for the Load Balancer. Required.
    backend_address_pools = map(object({
      name = optional(string, "bepool-1") # The name of the backend address pool. Optional.
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
      frontend_ip_configuration_name = optional(string) # The name of the frontend IP configuration for the rule. Optional.
      protocol = optional(string, "Tcp") # The transport protocol for the rule. Valid values: `All`, `Tcp`, `Udp`. Optional.
      frontend_port = optional(number, 3389) # The port for the external endpoint. Optional.
      backend_port = optional(number, 3389) # The port for internal connections. Optional.
      backend_address_pool_object_names = optional(list(string)) # A list of backend address pool object names. Optional.
      probe_object_name = optional(string) # The name of the probe object used by the rule. Optional.
      enable_floating_ip = optional(bool, false) # Whether floating IP is enabled for the rule. Optional.
      idle_timeout_in_minutes = optional(number, 4) # The idle timeout in minutes for the rule. Optional.
      load_distribution = optional(string, "Default") # The load balancing distribution type. Valid values: `Default`, `SourceIP`, `SourceIPProtocol`. Optional.
    })) # A map of Load Balancer rules. Required.
    lb_probes = map(object({
      name = optional(string) # The name of the probe. Optional.
      protocol = optional(string, "Tcp") # The protocol of the probe. Valid values: `Tcp`, `Http`, `Https`. Optional.
      port = optional(number, 80) # The port on which the probe queries the backend endpoint. Optional.
      interval_in_seconds = optional(number, 15) # The interval in seconds between probes. Optional.
      probe_threshold = optional(number, 1) # The number of consecutive successful or failed probes. Optional.
      request_path = optional(string) # The URI used for requesting health status. Required if protocol is `Http` or
      `Https`. Optional.
    })) # A map of Load Balancer probes. Required.
    inbound_nat_rules = map(object({
      name = optional(string) # The name of the inbound NAT rule. Optional.
      frontend_ip_configuration_name = optional(string) # The name of the frontend IP configuration for the rule. Optional.
      protocol = optional(string, "Tcp") # The transport protocol for the rule. Valid values: `Tcp`, `Udp`. Optional.
      frontend_port = optional(number) # The port for the external endpoint. Required.
      backend_port = optional(number) # The port for internal connections. Required.
      enable_floating_ip = optional(bool, false) # Whether floating IP is enabled for the rule. Optional.
      idle_timeout_in_minutes = optional(number, 4) # The idle timeout in minutes for the rule. Optional.
    })) # A map of inbound NAT rules. Required.
    outbound_rules = map(object({
      name = optional(string) # The name of the outbound rule. Optional.
      frontend_ip_configuration_name = optional(string) # The name of the frontend IP configuration for the rule. Optional.
      backend_address_pool_object_names = optional(list(string)) # A list of backend address pool object names. Optional.
      protocol = optional(string, "All") # The transport protocol for the rule. Valid values: `All`, `Tcp`, `Udp`. Optional.
      idle_timeout_in_minutes = optional(number, 4) # The idle timeout in minutes for the rule. Optional.
      allocated_outbound_ports = optional(number) # The number of outbound ports to allocate. Optional.
    })) # A map of outbound rules. Required.
  })
  description = "Configuration object for an Azure Load Balancer, including frontend IP configurations, backend address pools, rules, probes, and NAT rules."
}
variable "storage_account_config" {
  type = object({
    account_replication_type          = string # Specifies the replication type for the storage account. Valid values: "LRS", "GRS", "RAGRS", "ZRS". Required.
    account_tier                      = string # Specifies the performance tier for the storage account. Valid values: "Standard", "Premium". Required.
    location                          = string # The Azure region where the storage account will be created. Required.
    name                              = string # The name of the storage account. Must be unique within Azure. Required.
    resource_group_name               = string # The name of the resource group where the storage account will be created. Required.
    access_tier                       = optional(string, null) # Specifies the access tier for the storage account. Valid values: "Hot", "Cool". Optional.
    account_kind                      = string # Specifies the kind of storage account. Valid values: "StorageV2", "BlobStorage", "FileStorage", etc. Required.
    allow_nested_items_to_be_public   = optional(bool, false) # Whether nested items in the storage account can be public. Default: false. Optional.
    allowed_copy_scope                = optional(string, null) # Specifies the allowed copy scope for the storage account. Valid values: "Private", "Azure". Optional.
    cross_tenant_replication_enabled  = optional(bool, false) # Whether cross-tenant replication is enabled. Default: false. Optional.
    default_to_oauth_authentication   = optional(bool, false) # Whether OAuth authentication is the default for the storage account. Default: false. Optional.
    edge_zone                         = optional(string, null) # Specifies the edge zone for the storage account. Optional.
    https_traffic_only_enabled        = optional(bool, true) # Whether only HTTPS traffic is allowed. Default: true. Optional.
    infrastructure_encryption_enabled = optional(bool, false) # Whether infrastructure encryption is enabled. Default: false. Optional.
    is_hns_enabled                    = optional(bool, false) # Whether hierarchical namespace (HNS) is enabled. Default: false. Optional.
    large_file_share_enabled          = optional(bool, false) # Whether large file shares are enabled. Default: false. Optional.
    min_tls_version                   = optional(string, "TLS1_2") # Specifies the minimum TLS version. Valid values: "TLS1_0", "TLS1_1", "TLS1_2". Default: "TLS1_2". Optional.
    nfsv3_enabled                     = optional(bool, false) # Whether NFSv3 protocol is enabled. Default: false. Optional.
    public_network_access_enabled     = optional(bool, true) # Whether public network access is enabled. Default: true. Optional.
    queue_encryption_key_type         = optional(string, null) # Specifies the encryption key type for queues. Valid values: "Account", "Service". Optional.
    sftp_enabled                      = optional(bool, false) # Whether SFTP is enabled. Default: false. Optional.
    shared_access_key_enabled         = optional(bool, true) # Whether shared access keys are enabled. Default: true. Optional.
    table_encryption_key_type         = optional(string, null) # Specifies the encryption key type for tables. Valid values: "Account", "Service". Optional.
    tags                              = optional(map(string), {}) # A map of tags to assign to the storage account. Default: {}. Optional.
    azure_files_authentication = optional(object({ # Configuration for Azure Files authentication. Optional.
      directory_type                 = string # Specifies the directory type. Valid values: "AADDS", "AD". Required.
      default_share_level_permission = string # Specifies the default share-level permission. Required.
      active_directory = optional(object({ # Active Directory configuration. Optional.
        domain_guid         = string # The GUID of the domain. Required.
        domain_name         = string # The name of the domain. Required.
        domain_sid          = string # The SID of the domain. Required.
        forest_name         = string # The name of the forest. Required.
        netbios_domain_name = string # The NetBIOS name of the domain. Required.
        storage_sid         = string # The SID of the storage account. Required.
      }), null)
    }), null)
    blob_properties = optional(object({ # Configuration for blob properties. Optional.
      change_feed_enabled           = optional(bool, false) # Whether change feed is enabled. Default: false. Optional.
      change_feed_retention_in_days = optional(number, null) # The retention period for change feed in days. Optional.
      default_service_version       = optional(string, null) # The default service version for the blob service. Optional.
      last_access_time_enabled      = optional(bool, false) # Whether last access time tracking is enabled. Default: false. Optional.
      versioning_enabled            = optional(bool, false) # Whether versioning is enabled. Default:
false) # Whether versioning is enabled. Default: false. Optional.
      delete_retention_policy = optional(object({ # Configuration for delete retention policy. Optional.
        days = optional(number, null) # The number of days to retain deleted blobs. Optional.
      }), null)
    }), null)
    container_delete_retention_policy = optional(object({ # Configuration for container delete retention policy. Optional.
      days = optional(number, null) # The number of days to retain deleted containers. Optional.
    }), null)
    cors_rules = optional(list(object({ # Configuration for CORS rules. Optional.
      allowed_headers    = list(string) # List of allowed headers for CORS. Required.
      allowed_methods    = list(string) # List of allowed methods for CORS. Valid values: "GET", "POST", "PUT", "DELETE", etc. Required.
      allowed_origins    = list(string) # List of allowed origins for CORS. Required.
      exposed_headers    = list(string) # List of exposed headers for CORS. Required.
      max_age_in_seconds = number # Maximum age in seconds for CORS preflight requests. Required.
    })), null)
    delete_retention_policy = optional(object({ # Configuration for account-level delete retention policy. Optional.
      days = optional(number, null) # The number of days to retain deleted items. Optional.
    }), null)
    immutability_policy = optional(object({ # Configuration for immutability policy. Optional.
      state = string # The state of the immutability policy. Valid values: "Locked", "Unlocked". Required.
      period = number # The retention period for the immutability policy in days. Required.
    }), null)
  })
  description = "Configuration object for an Azure Storage Account with various optional and required attributes."
}
variable "sql_server_config" {
  type = object({
    location                                     = string # The Azure region where the SQL Server will be deployed. Required.
    name                                         = string # The name of the SQL Server. Must be unique within the Azure region. Required.
    resource_group_name                          = string # The name of the resource group where the SQL Server will be deployed. Required.
    server_version                               = string # The version of the SQL Server. Valid values are "12.0" or "14.0". Required.
    administrator_login                          = string # The administrator username for the SQL Server. Required.
    administrator_login_password                 = string # The administrator password for the SQL Server. Required.
    connection_policy                            = optional(string, "Default") # The connection policy for the SQL Server. Valid values are "Default", "Proxy", or "Redirect". Defaults to "Default". Optional.
    express_vulnerability_assessment_enabled     = optional(bool, false) # Whether to enable Express Vulnerability Assessment. Defaults to false. Optional.
    outbound_network_restriction_enabled         = optional(bool, false) # Whether to enable outbound network restrictions. Defaults to false. Optional.
    primary_user_assigned_identity_id            = optional(string, null) # The resource ID of the primary user-assigned managed identity. Optional.
    public_network_access_enabled                = optional(bool, true) # Whether public network access is enabled for the SQL Server. Defaults to true. Optional.
    tags                                         = optional(map(string), {}) # A map of tags to assign to the SQL Server. Defaults to an empty map. Optional.
    transparent_data_encryption_key_vault_key_id = optional(string, null) # The Key Vault key ID for Transparent Data Encryption. Optional.
    azuread_administrator = optional(object({
      login_username              = string # The login username for the Azure AD administrator. Required if specified.
      object_id                   = string # The object ID of the Azure AD administrator. Required if specified.
      azuread_authentication_only = optional(bool, false) # Whether to enable Azure AD authentication only. Defaults to false. Optional.
      tenant_id                   = string # The tenant ID of the Azure AD administrator. Required if specified.
    }), null) # Configuration for the Azure AD administrator. Optional.
    identity = optional(object({
      type                        = string # The type of identity to assign. Valid values are "SystemAssigned", "UserAssigned", or "SystemAssigned,UserAssigned". Required if specified.
      user_assigned_resource_ids  = optional(set(string), []) # A set of user-assigned managed identity resource IDs. Defaults to an empty set. Optional.
    }), null) # Configuration for the managed identity. Optional.
    lock = optional(object({
      kind = string # The type of lock to apply. Valid values are "CanNotDelete" or "ReadOnly". Required if specified.
      name = optional(string, null) # The name of the lock. Defaults to a generated name based on the lock kind. Optional.
    }), null) # Configuration for the resource lock. Optional.
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string # The ID or name of the role definition to assign. Required.
      principal_id                           = string # The ID of the principal to assign the role to. Required.
      description                            = optional(string, null) # A description of the role assignment. Optional.
      skip_service_principal_aad_check       = optional(bool, false) # Whether to skip the Azure AD check for the service principal. Defaults to false. Optional.
      condition                              = optional(string, null) # The condition to scope the role assignment. Optional.
      condition_version                      = optional(string, null) # The version of the condition syntax. Optional.
      delegated_managed_identity_resource_id = optional(string, null) # The resource ID of the delegated managed identity. Optional.
    })), {}) # A map of role assignments to create. Defaults to an empty map. Optional.
    diagnostic_settings = optional(map(object({
      name                                     = optional(string, null) # The name of the diagnostic setting. Defaults to a generated name. Optional.
      log_categories                           = optional(set(string), []) # A set of log categories to send to the log analytics workspace. Defaults to an empty set. Optional.
      log_groups                               = optional(set(string), ["allLogs"]) # A set of log groups to send to the log analytics workspace. Defaults to ["allLogs"]. Optional.
      metric_categories                        = optional(set(string), ["AllMetrics"]) # A set of metric categories to send to the log analytics workspace. Defaults to ["AllMetrics"]. Optional.
      log_analytics_destination_type           = optional(string, "Dedicated") # The destination type for the diagnostic setting. Valid values are "Dedicated" or "AzureDiagnostics". Defaults to "Dedicated". Optional.
      workspace_resource_id                    = optional(string, null) # The resource ID of the log analytics workspace. Optional.
      storage_account
      storage_account_id                       = optional(string, null) # The resource ID of the storage account to send diagnostic logs to. Optional.
      event_hub_authorization_rule_id          = optional(string, null) # The authorization rule ID for the Event Hub namespace. Optional.
      event_hub_name                           = optional(string, null) # The name of the Event Hub to send diagnostic logs to. Optional.
    })), {}) # A map of diagnostic settings to configure. Defaults to an empty map. Optional.
  }) # Configuration object for the SQL Server.
  description = "Configuration for an Azure SQL Server, including identity, role assignments, diagnostic settings, and other properties."
}

variable "private_dns_zone_config" {
  type = object({
    domain_name = string # The name of the private DNS zone. Required.
    resource_group_name = string # The name of the resource group where the private DNS zone will be created. Required.
    tags = optional(map(string), null) # A map of tags to assign to the private DNS zone. Optional, defaults to null.
    soa_record = optional(object({
      email        = string # The email address for the SOA record. Required.
      expire_time  = optional(number, 2419200) # The expiration time in seconds for the SOA record. Optional, defaults to 2419200.
      minimum_ttl  = optional(number, 10) # The minimum TTL in seconds for the SOA record. Optional, defaults to 10.
      refresh_time = optional(number, 3600) # The refresh time in seconds for the SOA record. Optional, defaults to 3600.
      retry_time   = optional(number, 300) # The retry time in seconds for the SOA record. Optional, defaults to 300.
      ttl          = optional(number, 3600) # The TTL in seconds for the SOA record. Optional, defaults to 3600.
      tags         = optional(map(string), null) # A map of tags to assign to the SOA record. Optional, defaults to null.
    }), null) # The SOA record configuration. Optional, defaults to null.
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
      ttl                 = number # The TTL in seconds for the A record. Required.
      records             = list(string) # A list of IPv4 addresses for the A record. Required.
      tags                = optional(map(string), null) # A map of tags to assign to the A record. Optional, defaults to null.
    })), {}) # A map of A record configurations. Optional, defaults to an empty map.
    aaaa_records = optional(map(object({
      name                = string # The name of the AAAA record. Required.
      resource_group_name = string # The name of the resource group for the AAAA record. Required.
      zone_name           = string # The name of the private DNS zone for the AAAA record. Required.
      ttl                 = number # The TTL in seconds for the AAAA record. Required.
      records             = list(string) # A list of IPv6 addresses for the AAAA record. Required.
      tags                = optional(map(string), null) # A map of tags to assign to the AAAA record. Optional, defaults to null.
    })), {}) # A map of AAAA record configurations. Optional, defaults to an empty map.
    cname_records = optional(map(object({
      name                = string # The name of the CNAME record. Required.
      resource_group_name = string # The name of the resource group for the CNAME record. Required.
      zone_name           = string # The name of the private DNS zone for the CNAME record. Required.
      ttl                 = number # The TTL in seconds for the CNAME record. Required.
      record              = string # The canonical name for the CNAME record. Required.
      tags                = optional(map(string), null) # A map of tags to assign to the CNAME record. Optional, defaults to null.
    })), {}) # A map of CNAME record configurations. Optional, defaults to an empty map.
    mx_records = optional(map(object({
      name                = optional(string, "@") # The name of the MX record. Optional, defaults to "@".
      resource_group_name = string # The name of the resource group for the MX record. Required.
      zone_name           = string # The name of the private DNS zone for the MX record. Required.
      ttl                 = number # The TTL in seconds for the MX record. Required.
      records = map(object({
        preference = number # The preference value for the MX record. Required.
        exchange   = string # The mail exchange server for the MX record. Required.
      })) # A
      })) # A map of mail exchange records for the MX record. Required.
      tags = optional(map(string), null) # A map of tags to assign to the MX record. Optional, defaults to null.
    })), {}) # A map of MX record configurations. Optional, defaults to an empty map.
    txt_records = optional(map(object({
      name                = string # The name of the TXT record. Required.
      resource_group_name = string # The name of the resource group for the TXT record. Required.
      zone_name           = string # The name of the private DNS zone for the TXT record. Required.
      ttl                 = number # The TTL in seconds for the TXT record. Required.
      records             = list(string) # A list of text values for the TXT record. Required.
      tags                = optional(map(string), null) # A map of tags to assign to the TXT record. Optional, defaults to null.
    })), {}) # A map of TXT record configurations. Optional, defaults to an empty map.
    srv_records = optional(map(object({
      name                = string # The name of the SRV record. Required.
      resource_group_name = string # The name of the resource group for the SRV record. Required.
      zone_name           = string # The name of the private DNS zone for the SRV record. Required.
      ttl                 = number # The TTL in seconds for the SRV record. Required.
      records = list(object({
        priority = number # The priority value for the SRV record. Required.
        weight   = number # The weight value for the SRV record. Required.
        port     = number # The port number for the SRV record. Required.
        target   = string # The target server for the SRV record. Required.
      })) # A list of service records for the SRV record. Required.
      tags = optional(map(string), null) # A map of tags to assign to the SRV record. Optional, defaults to null.
    })), {}) # A map of SRV record configurations. Optional, defaults to an empty map.
    ptr_records = optional(map(object({
      name                = string # The name of the PTR record. Required.
      resource_group_name = string # The name of the resource group for the PTR record. Required.
      zone_name           = string # The name of the private DNS zone for the PTR record. Required.
      ttl                 = number # The TTL in seconds for the PTR record. Required.
      records             = list(string) # A list of pointer values for the PTR record. Required.
      tags                = optional(map(string), null) # A map of tags to assign to the PTR record. Optional, defaults to null.
    })), {}) # A map of PTR record configurations. Optional, defaults to an empty map.
    caa_records = optional(map(object({
      name                = string # The name of the CAA record. Required.
      resource_group_name = string # The name of the resource group for the CAA record. Required.
      zone_name           = string # The name of the private DNS zone for the CAA record. Required.
      ttl                 = number # The TTL in seconds for the CAA record. Required.
      records = list(object({
        flags = number # The flags value for the CAA record. Required.
        tag   = string # The tag value for the CAA record. Required.
        value = string # The value for the CAA record. Required.
      })) # A list of certification authority authorization records for the CAA record. Required.
      tags = optional(map(string), null) # A map of tags to assign to the CAA record. Optional, defaults to null.
    })), {}) # A map of CAA record configurations. Optional, defaults to an empty map.
  }) # Configuration for the private DNS zone and its records.
}
