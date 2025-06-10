variable "network_security_group_config" {
  type = object({
    location = string # Specifies the Azure location where the resource exists. Required.
    name = string # Specifies the name of the network security group. Required.
    resource_group_name = string # The name of the resource group in which to create the network security group. Required.
    tags = optional(map(string), null) # A mapping of tags to assign to the resource. Optional, defaults to null.
    timeouts = optional(object({ # Configuration for resource operation timeouts. Optional, defaults to null.
      create = optional(string) # Timeout for creating the resource. Optional, defaults to 30 minutes.
      delete = optional(string) # Timeout for deleting the resource. Optional, defaults to 30 minutes.
      read = optional(string) # Timeout for reading the resource. Optional, defaults to 5 minutes.
      update = optional(string) # Timeout for updating the resource. Optional, defaults to 30 minutes.
    }), null)
    lock = optional(object({ # Configuration for resource locks. Optional, defaults to null.
      kind = string # The type of lock. Required. Valid values: "CanNotDelete", "ReadOnly".
      name = optional(string, null) # The name of the lock. Optional, defaults to a generated name based on the kind.
    }), null)
    role_assignments = optional(map(object({ # A map of role assignments to create on the resource. Optional, defaults to an empty map.
      role_definition_id_or_name = string # The ID or name of the role definition to assign. Required.
      principal_id = string # The ID of the principal to assign the role to. Required.
      description = optional(string, null) # The description of the role assignment. Optional, defaults to null.
      skip_service_principal_aad_check = optional(bool, false) # Skips Azure AD check for service principal. Optional, defaults to false.
      condition = optional(string, null) # The condition for scoping the role assignment. Optional, defaults to null.
      condition_version = optional(string, null) # The version of the condition syntax. Optional, defaults to null.
      delegated_managed_identity_resource_id = optional(string, null) # The resource ID of the delegated managed identity. Optional, defaults to null.
      principal_type = optional(string, null) # The type of the principal (e.g., User, Group, ServicePrincipal). Optional, defaults to null.
    })), {})
    diagnostic_settings = optional(map(object({ # A map of diagnostic settings for the resource. Optional, defaults to an empty map.
      name = optional(string, null) # The name of the diagnostic setting. Optional, defaults to null.
      log_categories = optional(set(string), []) # A set of log categories to send to the log analytics workspace. Optional, defaults to an empty set.
      log_groups = optional(set(string), ["allLogs"]) # A set of log groups to send to the log analytics workspace. Optional, defaults to ["allLogs"].
      metric_categories = optional(set(string), ["AllMetrics"]) # A set of metric categories to send to the log analytics workspace. Optional, defaults to ["AllMetrics"].
      log_analytics_destination_type = optional(string, "Dedicated") # The destination type for the diagnostic setting. Optional, defaults to "Dedicated".
      workspace_resource_id = optional(string, null) # The resource ID of the log analytics workspace. Optional, defaults to null.
      storage_account_resource_id = optional(string, null) # The resource ID of the storage account. Optional, defaults to null.
      event_hub_authorization_rule_resource_id = optional(string, null) # The resource ID of the event hub authorization rule. Optional, defaults to null.
      event_hub_name = optional(string, null) # The name of the event hub. Optional, defaults to null.
      marketplace_partner_resource_id = optional(string, null) # The ARM resource ID of the Marketplace partner resource. Optional, defaults to null.
    })), {})
    enable_telemetry = optional(bool, true) # Controls whether telemetry is enabled for the module. Optional, defaults to true.
  })
  description = "Configuration object for the Azure network_security_group resource."
}
variable "network_interface_config" {
  type = object({
    location                       = string # The Azure region where the network interface will be deployed. Required.
    name                           = string # The name of the network interface. Required.
    resource_group_name            = string # The name of the resource group in which the network interface will be created. Required.
    accelerated_networking_enabled = optional(bool, false) # Specifies whether accelerated networking is enabled. Optional, defaults to false.
    dns_servers                    = optional(list(string), null) # List of DNS server IP addresses. Optional, defaults to null.
    edge_zone                      = optional(string, null) # Specifies the extended location of the network interface. Optional, defaults to null.
    internal_dns_name_label        = optional(string, null) # DNS name for internal communication within the virtual network. Optional, defaults to null.
    ip_forwarding_enabled          = optional(bool, false) # Specifies whether IP forwarding is enabled. Optional, defaults to false.
    tags                           = optional(map(string), null) # Map of tags to assign to the network interface. Optional, defaults to null.
    ip_configurations = map(object({
      name                                               = string # Name of the IP configuration. Required.
      private_ip_address_allocation                      = optional(string, "Dynamic") # Allocation method for the private IP address. Optional, defaults to "Dynamic". Valid values: "Static", "Dynamic".
      gateway_load_balancer_frontend_ip_configuration_id = optional(string, null) # ID of the gateway load balancer frontend IP configuration. Optional, defaults to null.
      primary                                            = optional(bool, null) # Specifies whether this IP configuration is the primary one. Optional, defaults to null.
      private_ip_address                                 = optional(string, null) # The private IP address if allocation is "Static". Optional, defaults to null.
      private_ip_address_version                         = optional(string, "IPv4") # IP address version. Optional, defaults to "IPv4". Valid values: "IPv4", "IPv6".
      public_ip_address_id                               = optional(string, null) # ID of the public IP address associated with the configuration. Optional, defaults to null.
      subnet_id                                          = string # ID of the subnet to associate with the IP configuration. Required.
    })) # A map of IP configurations for the network interface. Required.
    load_balancer_backend_address_pool_association = optional(map(object({
      load_balancer_backend_address_pool_id = string # ID of the load balancer backend address pool. Required.
      ip_configuration_name                 = string # Name of the network interface IP configuration. Required.
    })), null) # Map of load balancer backend address pool associations. Optional, defaults to null.
    application_gateway_backend_address_pool_association = optional(object({
      application_gateway_backend_address_pool_id = string # ID of the application gateway backend address pool. Required.
      ip_configuration_name                       = string # Name of the network interface IP configuration. Required.
    }), null) # Object describing the application gateway backend address pool association. Optional, defaults to null.
    application_security_group_ids = optional(list(string), null) # List of application security group IDs. Optional, defaults to null.
    nat_rule_association = optional(map(object({
      nat_rule_id           = string # ID of the NAT rule. Required.
      ip_configuration_name = string # Name of the network interface IP configuration. Required.
    })), {}) # Map of NAT rule associations. Optional, defaults to an empty map.
    network_security_group_ids = optional(list(string), null) # List of network security group IDs. Optional, defaults to null.
    lock = optional(object({
      kind = string # Type of lock. Required. Valid values: "CanNotDelete", "ReadOnly".
      name = optional(string, null) # Name of the lock. Optional, defaults to null.
    }), null) # Object describing the resource lock configuration. Optional, defaults to null.
  })
  description = "Configuration object for the Azure network_interface resource."
}
variable "azurestackhci_virtual_machine_config" {
  type = object({
    admin_password = string # Admin password for the VM. Required.
    admin_username = string # Admin username for the VM. Required.
    custom_location_id = string # The custom location ID for the Azure Stack HCI cluster. Required.
    image_id = string # The name of a Marketplace Gallery Image already downloaded to the Azure Stack HCI cluster. Required.
    location = string # Azure region where the resource should be deployed. Required.
    logical_network_id = string # The ID of the logical network to use for the NIC. Required.
    name = string # Name of the VM resource. Must be alphanumeric and <= 15 characters. Required.
    resource_group_name = string # The resource group where the resources will be deployed. Required.
    auto_upgrade_minor_version = optional(bool, true) # Whether to enable auto upgrade minor version. Defaults to true.
    data_disk_params = optional(map(object({ # Configuration for additional data disks. Optional.
      name = string # Name of the data disk. Required.
      diskSizeGB = number # Size of the disk in GB. Required.
      dynamic = bool # Whether the disk is dynamic. Required.
      tags = optional(map(string)) # Tags for the data disk. Optional.
      containerId = optional(string) # Container ID for the data disk. Optional.
    })), {}) # Defaults to an empty map.
    domain_join_extension_tags = optional(map(string), null) # Tags of the domain join extension. Optional.
    domain_join_password = optional(string, null) # Password for domain join. Required if 'domain_to_join' is specified. Optional.
    domain_join_user_name = optional(string, "") # Username for domain join. Required if 'domain_to_join' is specified. Optional.
    domain_target_ou = optional(string, "") # Organizational unit for domain join. Optional.
    domain_to_join = optional(string, "") # Domain name to join. Optional.
    dynamic_memory = optional(bool, true) # Enable dynamic memory. Defaults to true.
    dynamic_memory_buffer = optional(number, 20) # Buffer memory in MB when dynamic memory is enabled. Defaults to 20.
    dynamic_memory_max = optional(number, 8192) # Maximum memory in MB when dynamic memory is enabled. Defaults to 8192.
    dynamic_memory_min = optional(number, 512) # Minimum memory in MB when dynamic memory is enabled. Defaults to 512.
    enable_telemetry = optional(bool, true) # Whether to enable telemetry for the module. Defaults to true.
    http_proxy = optional(string, null) # HTTP proxy server URL. Optional.
    https_proxy = optional(string, null) # HTTPS proxy server URL. Optional.
    linux_ssh_config = optional(object({ # SSH configuration for Linux VMs. Optional.
      publicKeys = list(object({
        keyData = string # SSH public key data. Required.
        path = string # Path to store the SSH key. Required.
      })) # List of public keys. Required.
    }), null) # Defaults to null.
    lock = optional(object({ # Resource lock configuration. Optional.
      kind = string # Type of lock. Valid values: "CanNotDelete", "ReadOnly". Required.
      name = optional(string, null) # Name of the lock. Defaults to null.
    }), null) # Defaults to null.
    managed_identities = optional(object({ # Managed identity configuration. Optional.
      system_assigned = optional(bool, false) # Enable system-assigned identity. Defaults to false.
      user_assigned_resource_ids = optional(set(string), []) # List of user-assigned identity resource IDs. Defaults to an empty set.
    }), {}) # Defaults to an empty object.
    memory_mb = optional(number, 8192) # Memory in MB for the VM. Defaults to 8192.
    nic_tags = optional(map(string), null) # Tags for the NIC. Optional.
    no_proxy = optional(list(string), []) # List of URLs to bypass proxy. Defaults to an empty list.
    os_type = optional(string, "Windows") # OS type of the VM. Valid values: "Windows", "Linux". Defaults to "Windows".
    private_ip_address = optional(string, "") # Private IP address of the NIC. Optional.
    role_assignments = optional(map(object({ # Role assignments for the VM. Optional.
      role_definition_id_or_name = string # Role definition ID or name. Required.
      principal_id = string # Principal ID for the role assignment. Required.
      description = optional(string, null) # Description of the role assignment. Optional.
      skip_service_principal_aad_check = optional(bool, false) # Skip AAD check for service principal. Defaults to false.
      condition = optional(string, null) # Condition for the role assignment. Optional.
      condition_version = optional(string, null) # Version of the condition syntax. Optional.
delegated_managed_identity_resource_id = optional(string, null) # Resource ID of the delegated managed identity. Optional.
    })), {}) # Defaults to an empty map.
    tags = optional(map(string), {}) # Tags to associate with the VM resource. Defaults to an empty map.
    time_zone = optional(string, null) # Time zone for the VM. Optional.
    vm_size = optional(string, "Standard_D2s_v3") # Size of the VM. Defaults to "Standard_D2s_v3".
    vnet_id = optional(string, null) # Virtual network ID for the VM NIC. Optional.
    windows_configuration = optional(object({ # Windows-specific configuration for the VM. Optional.
      enable_automatic_updates = optional(bool, true) # Enable automatic updates. Defaults to true.
      provision_vm_agent = optional(bool, true) # Provision the VM agent. Defaults to true.
      timezone = optional(string, null) # Time zone for the Windows VM. Optional.
    }), null) # Defaults to null.
  })
  description = "Configuration object for Azure Stack HCI virtual machine deployment."
}
variable "load_balancer_config" {
  type = object({
    location = string # The Azure region where the Load Balancer will be deployed. Required.
    name = string # The name of the Load Balancer. Required.
    resource_group_name = string # The name of the resource group where the Load Balancer will be deployed. Required.
    edge_zone = optional(string, null) # Specifies the Edge Zone within the Azure Region where the Load Balancer should exist. Optional.
    sku = optional(string, "Standard") # The SKU of the Load Balancer. Accepted values are "Basic", "Standard", and "Gateway". Defaults to "Standard". Optional.
    sku_tier = optional(string, "Regional") # Specifies the SKU tier of the Load Balancer. Accepted values are "Global" and "Regional". Defaults to "Regional". Optional.
    tags = optional(map(string), null) # A map of tags to assign to the Load Balancer. Optional.
    frontend_ip_configurations = map(object({
      name = optional(string) # The name of the frontend IP configuration. Optional.
      frontend_private_ip_address = optional(string) # The private IP address to assign to the Load Balancer. Optional.
      frontend_private_ip_address_allocation = optional(string, "Dynamic") # The allocation method for the private IP address. Accepted values are "Dynamic" or "Static". Defaults to "Dynamic". Optional.
      frontend_private_ip_address_version = optional(string) # The version of the private IP address. Accepted values are "IPv4" or "IPv6". Optional.
      frontend_private_ip_subnet_resource_id = optional(string) # The ID of the subnet associated with the frontend IP configuration. Optional.
      gateway_load_balancer_frontend_ip_configuration_id = optional(string) # The ID of the gateway Load Balancer frontend IP configuration. Optional.
      public_ip_address_id = optional(string) # The ID of the public IP address associated with the frontend IP configuration. Optional.
      zones = optional(list(string), null) # A list of availability zones for the frontend IP configuration. Optional.
    })) # A map of frontend IP configurations for the Load Balancer. At least one configuration is required.
    backend_address_pools = map(object({
      name = optional(string, "bepool-1") # The name of the backend address pool. Defaults to "bepool-1". Optional.
      virtual_network_resource_id = optional(string) # The ID of the virtual network associated with the backend pool. Optional.
      tunnel_interfaces = optional(map(object({
        identifier = optional(number) # The identifier of the tunnel interface. Optional.
        type = optional(string) # The type of the tunnel interface. Optional.
        protocol = optional(string) # The protocol of the tunnel interface. Optional.
        port = optional(number) # The port of the tunnel interface. Optional.
      })), {}) # A map of tunnel interfaces for the backend pool. Optional.
    })) # A map of backend address pools for the Load Balancer. Optional.
    lb_rules = map(object({
      name = optional(string) # The name of the Load Balancer rule. Optional.
      frontend_ip_configuration_name = optional(string) # The name of the frontend IP configuration associated with the rule. Optional.
      protocol = optional(string, "Tcp") # The transport protocol for the rule. Accepted values are "Tcp", "Udp", or "All". Defaults to "Tcp". Optional.
      frontend_port = optional(number, 3389) # The frontend port for the rule. Defaults to 3389. Optional.
      backend_port = optional(number, 3389) # The backend port for the rule. Defaults to 3389. Optional.
      backend_address_pool_resource_ids = optional(list(string)) # A list of backend address pool resource IDs for the rule. Optional.
      probe_id = optional(string) # The ID of the probe associated with the rule. Optional.
      enable_floating_ip = optional(bool, false) # Whether to enable floating IP for the rule. Defaults to false. Optional.
      idle_timeout_in_minutes = optional(number, 4) # The idle timeout in minutes for the rule. Defaults to 4. Optional.
      load_distribution = optional(string, "Default") # The load distribution method for the rule. Defaults to "Default". Optional.
    })) # A map of Load Balancer rules. Optional.
    probes = map(object({
      name = optional(string) # The name of the probe. Optional.
      protocol = optional(string, "Tcp") # The protocol of the probe. Accepted values are "Tcp", "Http", or "Https". Defaults to "Tcp". Optional.
      port = optional(number, 80) # The port on which the probe queries the backend endpoint. Defaults to 80. Optional.
      interval_in_seconds = optional(number, 15) # The interval in seconds between probes. Defaults to 15. Optional.
      number_of_probes = optional(number,
2) # The number of consecutive probe failures required to mark a backend endpoint as unhealthy. Defaults to 2. Optional.
      request_path = optional(string) # The path to send the probe request when using HTTP or HTTPS protocols. Optional.
    })) # A map of probes for the Load Balancer. Optional.
    outbound_rules = map(object({
      name = optional(string) # The name of the outbound rule. Optional.
      frontend_ip_configuration_name = optional(string) # The name of the frontend IP configuration associated with the outbound rule. Optional.
      protocol = optional(string, "Tcp") # The transport protocol for the outbound rule. Accepted values are "Tcp" or "Udp". Defaults to "Tcp". Optional.
      allocated_outbound_ports = optional(number) # The number of outbound ports to allocate for the rule. Optional.
      idle_timeout_in_minutes = optional(number, 4) # The idle timeout in minutes for the outbound rule. Defaults to 4. Optional.
      backend_address_pool_resource_ids = optional(list(string)) # A list of backend address pool resource IDs for the outbound rule. Optional.
    })) # A map of outbound rules for the Load Balancer. Optional.
  })
  description = "Configuration object for defining an Azure Load Balancer."
}
variable "storage_account_config" {
  type = object({
    account_replication_type          = string # Specifies the replication type for the storage account. Required. Valid values: LRS, ZRS, GRS, RAGRS.
    account_tier                      = string # Specifies the performance tier for the storage account. Required. Valid values: Standard, Premium.
    location                          = string # Specifies the Azure region where the storage account will be created. Required.
    name                              = string # Specifies the name of the storage account. Required. Must be unique within Azure.
    resource_group_name               = string # Specifies the name of the resource group where the storage account will be created. Required.
    access_tier                       = optional(string, null) # Specifies the access tier for the storage account. Optional. Valid values: Hot, Cool. Default is null.
    account_kind                      = string # Specifies the kind of storage account. Required. Valid values: StorageV2, BlobStorage, FileStorage, BlockBlobStorage.
    allow_nested_items_to_be_public   = optional(bool, false) # Specifies whether nested items can be public. Optional. Default is false.
    allowed_copy_scope                = optional(string, null) # Specifies the allowed copy scope. Optional. Valid values: PrivateLink, Azure. Default is null.
    cross_tenant_replication_enabled  = optional(bool, false) # Specifies whether cross-tenant replication is enabled. Optional. Default is false.
    default_to_oauth_authentication   = optional(bool, false) # Specifies whether OAuth authentication is the default. Optional. Default is false.
    edge_zone                         = optional(string, null) # Specifies the edge zone for the storage account. Optional. Default is null.
    https_traffic_only_enabled        = optional(bool, true) # Specifies whether only HTTPS traffic is allowed. Optional. Default is true.
    infrastructure_encryption_enabled = optional(bool, false) # Specifies whether infrastructure encryption is enabled. Optional. Default is false.
    is_hns_enabled                    = optional(bool, false) # Specifies whether hierarchical namespace is enabled. Optional. Default is false.
    large_file_share_enabled          = optional(bool, false) # Specifies whether large file shares are enabled. Optional. Default is false.
    min_tls_version                   = optional(string, "TLS1_2") # Specifies the minimum TLS version. Optional. Default is TLS1_2.
    nfsv3_enabled                     = optional(bool, false) # Specifies whether NFSv3 is enabled. Optional. Default is false.
    public_network_access_enabled     = optional(bool, true) # Specifies whether public network access is enabled. Optional. Default is true.
    queue_encryption_key_type         = optional(string, null) # Specifies the encryption key type for queues. Optional. Valid values: Account, Service. Default is null.
    sftp_enabled                      = optional(bool, false) # Specifies whether SFTP is enabled. Optional. Default is false.
    shared_access_key_enabled         = optional(bool, true) # Specifies whether shared access keys are enabled. Optional. Default is true.
    table_encryption_key_type         = optional(string, null) # Specifies the encryption key type for tables. Optional. Valid values: Account, Service. Default is null.
    tags                              = optional(map(string), {}) # Specifies a map of tags to assign to the storage account. Optional. Default is an empty map.
    azure_files_authentication = optional(object({ # Specifies Azure Files authentication settings. Optional. Default is null.
      directory_type                 = string # Specifies the directory type. Required. Valid values: AD, AADDS.
      default_share_level_permission = string # Specifies the default share-level permission. Required. Valid values: None, Read, Write, Full.
      active_directory = optional(object({ # Specifies Active Directory settings. Optional. Default is null.
        domain_guid         = string # Specifies the domain GUID. Required.
        domain_name         = string # Specifies the domain name. Required.
        domain_sid          = string # Specifies the domain SID. Required.
        forest_name         = string # Specifies the forest name. Required.
        netbios_domain_name = string # Specifies the NetBIOS domain name. Required.
        storage_sid         = string # Specifies the storage SID. Required.
      }), null)
    }), null)
    blob_properties = optional(object({ # Specifies blob properties for the storage account. Optional. Default is null.
      change_feed_enabled           = optional(bool, false) # Specifies whether change feed is enabled. Optional. Default is false.
      change_feed_retention_in_days = optional(number, null) # Specifies the retention period for change feed in days. Optional. Default is null.
      default_service_version       = optional(string, null) # Specifies the default service version. Optional. Default is null.
      last_access_time_enabled      = optional(bool, false) # Specifies whether last access time tracking is enabled. Optional. Default is false.
      versioning_enabled            = optional(bool,
true) # Specifies whether blob versioning is enabled. Optional. Default is true.
      delete_retention_policy = optional(object({ # Specifies the delete retention policy for blobs. Optional. Default is null.
        days = number # Specifies the number of days to retain deleted blobs. Required.
      }), null)
      container_delete_retention_policy = optional(object({ # Specifies the delete retention policy for blob containers. Optional. Default is null.
        days = number # Specifies the number of days to retain deleted containers. Required.
      }), null)
    }), null)
    identity = optional(object({ # Specifies the identity configuration for the storage account. Optional. Default is null.
      type         = string # Specifies the type of managed identity. Required. Valid values: SystemAssigned, UserAssigned, SystemAssigned,UserAssigned.
      identities   = optional(list(string), []) # Specifies a list of user-assigned managed identity IDs. Optional. Default is an empty list.
    }), null)
    network_rules = optional(object({ # Specifies the network rules for the storage account. Optional. Default is null.
      bypass                     = optional(list(string), ["AzureServices"]) # Specifies services to bypass. Optional. Default is ["AzureServices"].
      default_action             = string # Specifies the default action for network rules. Required. Valid values: Allow, Deny.
      ip_rules                   = optional(list(string), []) # Specifies a list of IP address rules. Optional. Default is an empty list.
      virtual_network_subnet_ids = optional(list(string), []) # Specifies a list of subnet IDs for virtual networks. Optional. Default is an empty list.
    }), null)
  })
  description = "Configuration object for an Azure Storage Account."
}
variable "sql_server_config" {
  type = object({
    location                                     = string # The Azure region where the SQL Server will be deployed. Required.
    name                                         = string # The name of the SQL Server. Must be unique within the resource group. Required.
    resource_group_name                          = string # The name of the resource group where the SQL Server will be deployed. Required.
    server_version                               = string # The version of the SQL Server. Valid values are "12.0" or "14.0". Required.
    administrator_login                          = string # The administrator username for the SQL Server. Required.
    administrator_login_password                 = string # The administrator password for the SQL Server. Required.
    connection_policy                            = optional(string, "Default") # The connection policy for the SQL Server. Valid values are "Default", "Proxy", or "Redirect". Optional, defaults to "Default".
    express_vulnerability_assessment_enabled     = optional(bool, false) # Whether Express Vulnerability Assessment is enabled. Optional, defaults to false.
    outbound_network_restriction_enabled         = optional(bool, false) # Whether outbound network restrictions are enabled. Optional, defaults to false.
    primary_user_assigned_identity_id            = optional(string, null) # The ID of the primary user-assigned managed identity. Optional.
    public_network_access_enabled                = optional(bool, true) # Whether public network access is enabled for the SQL Server. Optional, defaults to true.
    tags                                         = optional(map(string), {}) # A map of tags to assign to the SQL Server. Optional, defaults to an empty map.
    transparent_data_encryption_key_vault_key_id = optional(string, null) # The Key Vault key ID for Transparent Data Encryption. Optional.
    azuread_administrator = optional(object({ # Configuration for Azure Active Directory administrator. Optional.
      login_username              = string # The username of the Azure AD administrator. Required.
      object_id                   = string # The object ID of the Azure AD administrator. Required.
      azuread_authentication_only = optional(bool, false) # Whether Azure AD authentication is required. Optional, defaults to false.
      tenant_id                   = optional(string, null) # The tenant ID of the Azure AD administrator. Optional.
    }), null)
    identity = optional(object({ # Configuration for managed identities. Optional.
      type         = string # The type of managed identity. Valid values are "SystemAssigned" or "UserAssigned". Required.
      user_assigned_resource_ids = optional(set(string), []) # A set of resource IDs for user-assigned managed identities. Optional, defaults to an empty set.
    }), null)
    lock = optional(object({ # Configuration for resource locks. Optional.
      kind = string # The type of lock. Valid values are "CanNotDelete" or "ReadOnly". Required.
      name = optional(string, null) # The name of the lock. Optional, defaults to null.
    }), null)
    role_assignments = optional(map(object({ # A map of role assignments for the SQL Server. Optional.
      role_definition_id_or_name             = string # The ID or name of the role definition. Required.
      principal_id                           = string # The ID of the principal to assign the role to. Required.
      description                            = optional(string, null) # A description of the role assignment. Optional.
      skip_service_principal_aad_check       = optional(bool, false) # Whether to skip the Azure AD check for service principals. Optional, defaults to false.
      condition                              = optional(string, null) # The condition for the role assignment. Optional.
      condition_version                      = optional(string, null) # The version of the condition syntax. Optional.
      delegated_managed_identity_resource_id = optional(string, null) # The resource ID of the delegated managed identity. Optional.
      principal_type                         = optional(string, null) # The type of principal. Valid values are "User", "Group", or "ServicePrincipal". Optional.
    })), {})
    diagnostic_settings = optional(map(object({ # A map of diagnostic settings for the SQL Server. Optional.
      name                                     = optional(string, null) # The name of the diagnostic setting. Optional.
      log_categories                           = optional(set(string), []) # A set of log categories to send to the log analytics workspace. Optional, defaults to an empty set.
      log_groups                               = optional(set(string), ["allLogs"]) # A set of log groups to send to the log analytics workspace. Optional, defaults to ["allLogs"].
      metric_categories                        = optional(set(string), ["AllMetrics"]) # A set of metric categories to send to the log analytics workspace. Optional, defaults to ["AllMetrics"].
      log_analytics_destination_type           = optional(string, "Dedicated") # The destination type for the diagnostic setting. Valid values are "Dedicated" or "AzureDiagnostics". Optional, defaults to "Dedicated".
      workspace_resource_id                    = optional(string, null) # The resource ID of the log analytics workspace.
storage_account_id                       = optional(string, null) # The resource ID of the storage account for diagnostic logs. Optional.
      event_hub_authorization_rule_id          = optional(string, null) # The authorization rule ID for the event hub. Optional.
      event_hub_name                           = optional(string, null) # The name of the event hub. Optional.
      retention_policy_enabled                 = optional(bool, false) # Whether the retention policy is enabled. Optional, defaults to false.
      retention_policy_days                    = optional(number, null) # The number of days to retain logs. Optional.
    })), {})
  })
  description = "Configuration object for the Azure SQL Server resource."
}
