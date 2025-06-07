variable "network_security_group_config" {
  type = object({
    location            = string
    name                = string
    resource_group_name = string
    tags                = optional(map(string), null)
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      read   = optional(string)
      update = optional(string)
    }), null)
    lock = optional(object({
      kind = string
      name = optional(string, null)
    }), null)
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type                         = optional(string, null)
    })), {})
    diagnostic_settings = optional(map(object({
      name                                     = optional(string, null)
      log_categories                           = optional(set(string), [])
      log_groups                               = optional(set(string), ["allLogs"])
      metric_categories                        = optional(set(string), ["AllMetrics"])
      log_analytics_destination_type           = optional(string, "Dedicated")
      workspace_resource_id                    = optional(string, null)
      storage_account_resource_id              = optional(string, null)
      event_hub_authorization_rule_resource_id = optional(string, null)
      event_hub_name                           = optional(string, null)
      marketplace_partner_resource_id          = optional(string, null)
    })), {})
  })
  description = <<DESCRIPTION
Defines the configuration for the Network Security Group resource. The following attributes are available:

- `location` - (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. Type: string.
- `name` - (Required) Specifies the name of the network security group. Changing this forces a new resource to be created. Type: string.
- `resource_group_name` - (Required) The name of the resource group in which to create the network security group. Changing this forces a new resource to be created. Type: string.
- `tags` - (Optional) A mapping of tags to assign to the resource. Type: map(string).
- `timeouts` - (Optional) Specifies custom timeouts for resource operations. Type: object with the following attributes:
  - `create` - (Optional) Timeout for creating the resource. Defaults to 30 minutes. Type: string.
  - `delete` - (Optional) Timeout for deleting the resource. Defaults to 30 minutes. Type: string.
  - `read` - (Optional) Timeout for reading the resource. Defaults to 5 minutes. Type: string.
  - `update` - (Optional) Timeout for updating the resource. Defaults to 30 minutes. Type: string.
- `lock` - (Optional) Controls the Resource Lock configuration for this resource. Type: object with the following attributes:
  - `kind` - (Required) The type of lock. Possible values are `"CanNotDelete"` and `"ReadOnly"`. Type: string.
  - `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Type: string.
- `role_assignments` - (Optional) A map of role assignments to create on this resource. Type: map(object) with the following attributes:
  - `role_definition_id_or_name` - (Required) The ID or name of the role definition to assign to the principal. Type: string.
  - `principal_id` - (Required) The ID of the principal to assign the role to. Type: string.
  - `description` - (Optional) The description of the role assignment. Type: string.
  - `skip_service_principal_aad_check` - (Optional) If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false. Type: bool.
  - `condition` - (Optional) The condition which will be used to scope the role assignment. Type: string.
  - `condition_version` - (Optional) The version of the condition syntax. Valid values are '2.0'. Type: string.
  - `delegated_managed_identity_resource_id` - (Optional) The resource ID of the delegated managed identity. Type: string.
  - `principal_type` - (Optional) The type of the `principal_id`. Possible values are `User`, `Group`, and `ServicePrincipal`. Type: string.
- `diagnostic_settings` - (Optional) A map of diagnostic settings to create on the resource. Type: map(object) with the following attributes:
  - `name` - (Optional) The name of the diagnostic setting. Type: string.
  - `log_categories` - (Optional)
DESCRIPTION
}
variable "network_interface_config" {
  type = object({
    location                                      = string
    name                                          = string
    resource_group_name                           = string
    accelerated_networking_enabled                = optional(bool, false)
    dns_servers                                   = optional(list(string), null)
    edge_zone                                     = optional(string, null)
    internal_dns_name_label                       = optional(string, null)
    ip_forwarding_enabled                         = optional(bool, false)
    tags                                          = optional(map(string), null)
    ip_configurations                             = map(object({
      name                                               = string
      private_ip_address_allocation                      = optional(string, "Dynamic")
      gateway_load_balancer_frontend_ip_configuration_id = optional(string, null)
      primary                                            = optional(bool, null)
      private_ip_address                                 = optional(string, null)
      private_ip_address_version                         = optional(string, "IPv4")
      public_ip_address_id                               = optional(string, null)
      subnet_id                                          = string
    }))
    load_balancer_backend_address_pool_association = optional(map(object({
      load_balancer_backend_address_pool_id = string
      ip_configuration_name                 = string
    })), null)
    application_gateway_backend_address_pool_association = optional(object({
      application_gateway_backend_address_pool_id = string
      ip_configuration_name                       = string
    }), null)
    application_security_group_ids = optional(list(string), null)
    network_security_group_ids     = optional(list(string), null)
    nat_rule_association           = optional(map(object({
      nat_rule_id           = string
      ip_configuration_name = string
    })), {})
    lock = optional(object({
      kind = string
      name = optional(string, null)
    }), null)
  })

  description = <<DESCRIPTION
The configuration object for the network interface. The following attributes are supported:

- `location` (Required, string): The Azure location where the network interface should exist.
- `name` (Required, string): The name of the network interface.
- `resource_group_name` (Required, string): The name of the resource group in which to create the network interface.
- `accelerated_networking_enabled` (Optional, bool): Specifies whether accelerated networking should be enabled on the network interface. Defaults to `false`.
- `dns_servers` (Optional, list(string)): Specifies a list of IP addresses representing DNS servers. Defaults to `null`.
- `edge_zone` (Optional, string): Specifies the extended location of the network interface. Defaults to `null`.
- `internal_dns_name_label` (Optional, string): The (relative) DNS Name used for internal communications between virtual machines in the same virtual network. Defaults to `null`.
- `ip_forwarding_enabled` (Optional, bool): Specifies whether IP forwarding should be enabled on the network interface. Defaults to `false`.
- `tags` (Optional, map(string)): Map of tags to assign to the network interface. Defaults to `null`.
- `ip_configurations` (Required, map(object)): A map of IP configurations for the network interface. Each object includes:
  - `name` (Required, string): The name of the IP configuration.
  - `private_ip_address_allocation` (Optional, string): Specifies whether the private IP address is static or dynamic. Defaults to `Dynamic`.
  - `gateway_load_balancer_frontend_ip_configuration_id` (Optional, string): The ID of the gateway load balancer frontend IP configuration. Defaults to `null`.
  - `primary` (Optional, bool): Specifies whether this IP configuration is the primary one. Defaults to `null`.
  - `private_ip_address` (Optional, string): The private IP address to assign if allocation is `Static`. Defaults to `null`.
  - `private_ip_address_version` (Optional, string): The IP address version (`IPv4` or `IPv6`). Defaults to `IPv4`.
  - `public_ip_address_id` (Optional, string): The ID of the public IP address associated with this configuration. Defaults to `null`.
  - `subnet_id` (Required, string): The ID of the subnet to associate with this configuration.
- `load_balancer_backend_address_pool_association` (Optional, map(object)): A map describing the load balancer backend address pool associations. Each object includes:
  - `load_balancer_backend_address_pool_id` (Required, string): The resource ID of the load balancer backend address pool.
  - `ip_configuration_name` (Required, string): The name of the network interface IP configuration.
- `application_gateway_backend_address_pool_association` (Optional, object): An object describing the application gateway backend address pool association. Includes:
  - `application_gateway_backend_address_pool_id` (Required, string): The resource ID of the application gateway backend address pool.
  - `ip_configuration_name` (Required, string): The name of the network interface IP configuration.
- `application_security_group_ids` (Optional, list(string)): A list of application security group
DESCRIPTION
}
variable "virtual_machine_config" {
  type = object({
    admin_password                     = string
    admin_username                     = string
    auto_upgrade_minor_version         = optional(bool, true)
    custom_location_id                 = string
    data_disk_params                   = optional(map(object({
      name        = string
      diskSizeGB  = number
      dynamic     = bool
      tags        = optional(map(string))
      containerId = optional(string)
    })), {})
    domain_join_extension_tags         = optional(map(string), null)
    domain_join_password               = optional(string, null)
    domain_join_user_name              = optional(string, "")
    domain_target_ou                   = optional(string, "")
    domain_to_join                     = optional(string, "")
    dynamic_memory                     = optional(bool, true)
    dynamic_memory_buffer              = optional(number, 20)
    dynamic_memory_max                 = optional(number, 8192)
    dynamic_memory_min                 = optional(number, 512)
    enable_telemetry                   = bool
    http_proxy                         = optional(string, null)
    https_proxy                        = optional(string, null)
    image_id                           = string
    linux_ssh_config                   = optional(object({
      publicKeys = list(object({
        keyData = string
        path    = string
      }))
    }), null)
    location                           = string
    lock                               = optional(object({
      kind = string
      name = optional(string, null)
    }), null)
    logical_network_id                 = string
    managed_identities                 = optional(object({
      system_assigned            = optional(bool, false)
      user_assigned_resource_ids = optional(set(string), [])
    }), {})
    memory_mb                          = optional(number, 8192)
    name                               = string
    nic_tags                           = optional(map(string), null)
    no_proxy                           = optional(list(string), [])
    os_type                            = optional(string, "Windows")
    private_ip_address                 = optional(string, "")
    resource_group_name                = string
    role_assignments                   = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type                         = optional(string, null)
    })), {})
    secure_boot_enabled                = optional(bool, true)
    tags                               = optional(map(string), null)
    trusted_ca                         = optional(string, null)
    type_handler_version               = optional(string, "1.3")
    user_storage_id                    = optional(string, "")
    v_cpu_count                        = optional(number, 2)
    windows_ssh_config                 = optional(object({
      publicKeys = list(object({
        keyData = string
        path    = string
      }))
    }), null)
  })

  description = <<DESCRIPTION
The `virtual_machine_config` variable is an object that defines the configuration for the Azure Stack HCI Virtual Machine Instance. Below is a detailed explanation of each attribute:

- `admin_password` (string, required): The administrator password for the virtual machine. This value is sensitive and must not be empty.
- `admin_username` (string, required): The administrator username for the virtual machine. This value must not be empty.
- `auto_upgrade_minor_version` (bool, optional, default: true): Specifies whether to enable automatic upgrades for minor versions.
- `custom_location_id` (string, required): The custom location ID for the Azure Stack HCI cluster.
- `data_disk_params` (map(object), optional, default: {}): A map describing the data disks to attach to the VM. Each object includes:
  - `name` (string): The name of the data disk.
  - `diskSizeGB` (number): The size of the disk in GB.
  - `dynamic` (bool): Whether the disk is dynamic.
  - `tags` (map(string), optional): Tags for the data disk.
  - `containerId` (string, optional): The container ID for the data disk.
- `domain_join_extension_tags` (map(string), optional, default: null): Tags for the domain join extension.
- `domain_join_password` (string, optional, default: null): The password for the domain join user. Required if `domain_to_join` is specified. This value is sensitive.
- `domain_join_user_name` (string, optional, default: ""): The username for the domain join operation. Required if `domain_to_join` is specified.
- `domain_target_ou` (string, optional, default: ""): The organizational unit to join in the domain.
- `domain_to_join` (string, optional, default: ""): The domain name to join. If left empty, domain join parameters are ignored.
- `dynamic_memory`
DESCRIPTION
}
variable "load_balancer_config" {
  type = object({
    location                           = string
    name                               = string
    resource_group_name                = string
    edge_zone                          = optional(string, null)
    sku                                = optional(string, "Standard")
    sku_tier                           = optional(string, "Regional")
    tags                               = optional(map(string), null)
    frontend_ip_configurations         = map(object({
      name                                               = optional(string)
      frontend_private_ip_address                        = optional(string)
      frontend_private_ip_address_version                = optional(string)
      frontend_private_ip_address_allocation             = optional(string, "Dynamic")
      frontend_private_ip_subnet_resource_id             = optional(string)
      gateway_load_balancer_frontend_ip_configuration_id = optional(string)
      public_ip_address_resource_id                      = optional(string)
      create_public_ip_address                           = optional(bool, false)
      zones                                              = optional(list(string), ["1", "2", "3"])
    }))
    backend_address_pools             = map(object({
      name                        = optional(string, "bepool-1")
      virtual_network_resource_id = optional(string)
      tunnel_interfaces = optional(map(object({
        identifier = optional(number)
        type       = optional(string)
        protocol   = optional(string)
        port       = optional(number)
      })), {})
    }))
    backend_address_pool_addresses    = map(object({
      name                             = optional(string)
      backend_address_pool_object_name = optional(string)
      ip_address                       = optional(string)
      virtual_network_resource_id      = optional(string)
    }))
    backend_address_pool_network_interfaces = map(object({
      backend_address_pool_object_name = optional(string)
      ip_configuration_name            = optional(string)
      network_interface_resource_id    = optional(string)
    }))
    lb_probes                         = map(object({
      name                            = optional(string)
      protocol                        = optional(string, "Tcp")
      port                            = optional(number, 80)
      interval_in_seconds             = optional(number, 15)
      probe_threshold                 = optional(number, 1)
      request_path                    = optional(string)
      number_of_probes_before_removal = optional(number, 2)
    }))
    lb_rules                          = map(object({
      name                              = optional(string)
      frontend_ip_configuration_name    = optional(string)
      protocol                          = optional(string, "Tcp")
      frontend_port                     = optional(number, 3389)
      backend_port                      = optional(number, 3389)
      backend_address_pool_resource_ids = optional(list(string))
      backend_address_pool_object_names = optional(list(string))
      probe_resource_id                 = optional(string)
      probe_object_name                 = optional(string)
      enable_floating_ip                = optional(bool, false)
      idle_timeout_in_minutes           = optional(number, 4)
      load_distribution                 = optional(string, "Default")
      disable_outbound_snat             = optional(bool, false)
      enable_tcp_reset                  = optional(bool, false)
    }))
    lb_nat_rules                      = map(object({
      name                             = optional(string)
      frontend_ip_configuration_name   = optional(string)
      protocol                         = optional(string)
      frontend_port                    = optional(number)
      backend_port                     = optional(number)
      frontend_port_start              = optional(number)
      frontend_port_end                = optional(number)
      backend_address_pool_resource_id = optional(string)
      backend_address_pool_object_name = optional(string)
      idle_timeout_in_minutes          = optional(number, 4)
      enable_floating_ip               = optional(bool, false)
      enable_tcp_reset                 = optional(bool, false)
    }))
    lb_outbound_rules                 = map(object({
      name                               = optional(string)
      frontend_ip_configurations         = optional(list(object({ name = optional(string) })))
      backend_address_pool_resource_id   = optional(string)
      backend_address_pool_object_name   = optional(string)
      protocol                           = optional(string, "Tcp")
      enable_tcp_reset                   = optional(bool, false)
      number_of_allocated_outbound_ports = optional(number, 1024)
      idle_timeout_in_minutes            = optional(number, 4)
    }))
    lb_nat_pools                      = map(object({
      name                           = optional(string)
      frontend_ip_configuration_name = optional(string)
      protocol                       = optional(string, "Tcp")
      frontend_port_start            = optional(number, 3000)
      frontend_port_end              = optional(number, 3389)
      backend_port                   = optional(number, 3389)
      idle_timeout_in_minutes        = optional(number, 4)
      enable_floating_ip             = optional(bool, false)
      enable_tcp_reset               = optional(bool, false)
    }))
  })
  description = <<DESCRIPTION
  An object variable that defines the configuration for an Azure Load Balancer. The following attributes are included:

  - `location`: (Required) The Azure region where the resources should be deployed. Type: string.
  - `name`: (Required) The name of the load balancer. Type: string.
  - `
DESCRIPTION
}
variable "storage_account_config" {
  type = object({
    account_replication_type          = string
    account_tier                      = string
    location                          = string
    name                              = string
    resource_group_name               = string
    access_tier                       = optional(string, null)
    account_kind                      = string
    allow_nested_items_to_be_public   = optional(bool, false)
    allowed_copy_scope                = optional(string, null)
    cross_tenant_replication_enabled  = optional(bool, false)
    default_to_oauth_authentication   = optional(bool, false)
    edge_zone                         = optional(string, null)
    https_traffic_only_enabled        = optional(bool, true)
    infrastructure_encryption_enabled = optional(bool, false)
    is_hns_enabled                    = optional(bool, false)
    large_file_share_enabled          = optional(bool, false)
    min_tls_version                   = optional(string, "TLS1_2")
    nfsv3_enabled                     = optional(bool, false)
    public_network_access_enabled     = optional(bool, true)
    queue_encryption_key_type         = optional(string, null)
    sftp_enabled                      = optional(bool, false)
    shared_access_key_enabled         = optional(bool, true)
    table_encryption_key_type         = optional(string, null)
    tags                              = optional(map(string), {})
  })
  description = <<DESCRIPTION
This variable defines the configuration for an Azure Storage Account. The attributes are as follows:

- `account_replication_type` (Required): The replication type for the storage account. Possible values include `LRS`, `GRS`, `RAGRS`, etc.
- `account_tier` (Required): The performance tier of the storage account. Possible values are `Standard` or `Premium`.
- `location` (Required): The Azure region where the storage account will be deployed.
- `name` (Required): The name of the storage account. Must be globally unique and adhere to Azure naming conventions.
- `resource_group_name` (Required): The name of the resource group where the storage account will be created.
- `access_tier` (Optional): The access tier for the storage account. Possible values are `Hot` or `Cool`. Only applicable for `BlobStorage` or `StorageV2` accounts.
- `account_kind` (Required): The kind of storage account. Possible values include `Storage`, `StorageV2`, `BlobStorage`, etc.
- `allow_nested_items_to_be_public` (Optional): Specifies whether nested items in containers can be made public. Defaults to `false`.
- `allowed_copy_scope` (Optional): Specifies the allowed copy scope for the storage account. Possible values are `Private` or `Azure`.
- `cross_tenant_replication_enabled` (Optional): Specifies whether cross-tenant replication is enabled. Defaults to `false`.
- `default_to_oauth_authentication` (Optional): Specifies whether OAuth authentication is the default for the storage account. Defaults to `false`.
- `edge_zone` (Optional): The edge zone where the storage account will be deployed, if applicable.
- `https_traffic_only_enabled` (Optional): Specifies whether only HTTPS traffic is allowed. Defaults to `true`.
- `infrastructure_encryption_enabled` (Optional): Specifies whether infrastructure encryption is enabled. Defaults to `false`.
- `is_hns_enabled` (Optional): Specifies whether the storage account has hierarchical namespace enabled. Defaults to `false`.
- `large_file_share_enabled` (Optional): Specifies whether large file shares are enabled. Defaults to `false`.
- `min_tls_version` (Optional): The minimum TLS version required for the storage account. Defaults to `TLS1_2`.
- `nfsv3_enabled` (Optional): Specifies whether NFSv3 protocol support is enabled. Defaults to `false`.
- `public_network_access_enabled` (Optional): Specifies whether public network access is enabled. Defaults to `true`.
- `queue_encryption_key_type` (Optional): Specifies the encryption key type for queues. Possible values are `Service` or `Account`.
- `sftp_enabled` (Optional): Specifies whether SFTP protocol support is enabled. Defaults to `false`.
- `shared_access_key_enabled` (Optional): Specifies whether shared access keys are enabled. Defaults to `true`.
- `table_encryption_key_type` (Optional): Specifies the encryption key type for tables. Possible values are `Service` or `Account`.
- `tags` (Optional): A map of tags to assign to the storage account.

DESCRIPTION
}
variable "sql_server_config" {
  type = object({
    location                                     = string
    name                                         = string
    resource_group_name                          = string
    server_version                               = string
    administrator_login                          = string
    administrator_login_password                 = string
    connection_policy                            = optional(string, null)
    express_vulnerability_assessment_enabled     = optional(bool, false)
    outbound_network_restriction_enabled         = optional(bool, false)
    primary_user_assigned_identity_id            = optional(string, null)
    public_network_access_enabled                = optional(bool, true)
    tags                                         = optional(map(string), {})
    transparent_data_encryption_key_vault_key_id = optional(string, null)
    azuread_administrator = optional(object({
      login_username              = string
      object_id                   = string
      azuread_authentication_only = optional(bool, false)
      tenant_id                   = string
    }), null)
    lock = optional(object({
      kind = string
      name = optional(string, null)
    }), null)
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type                         = optional(string, null)
    })), {})
    diagnostic_settings = optional(map(object({
      name                                     = optional(string, null)
      log_categories                           = optional(set(string), [])
      log_groups                               = optional(set(string), ["allLogs"])
      metric_categories                        = optional(set(string), ["AllMetrics"])
      log_analytics_destination_type           = optional(string, "Dedicated")
      workspace_resource_id                    = optional(string, null)
      storage_account_resource_id              = optional(string, null)
      event_hub_authorization_rule_resource_id = optional(string, null)
      event_hub_name                           = optional(string, null)
      marketplace_partner_resource_id          = optional(string, null)
    })), {})
  })
  description = <<DESCRIPTION
  The configuration object for the Azure SQL Server resource. The following attributes can be specified:

  - `location` - (Required) The Azure region where the SQL Server will be deployed.
  - `name` - (Required) The name of the SQL Server.
  - `resource_group_name` - (Required) The name of the resource group where the SQL Server will be deployed.
  - `server_version` - (Required) The version of the SQL Server. Example: "12.0".
  - `administrator_login` - (Required) The administrator username for the SQL Server.
  - `administrator_login_password` - (Required) The administrator password for the SQL Server.
  - `connection_policy` - (Optional) The connection policy for the SQL Server. Possible values are "Default", "Proxy", and "Redirect".
  - `express_vulnerability_assessment_enabled` - (Optional) Whether to enable Express Vulnerability Assessment. Defaults to `false`.
  - `outbound_network_restriction_enabled` - (Optional) Whether to enable outbound network restrictions. Defaults to `false`.
  - `primary_user_assigned_identity_id` - (Optional) The ID of the primary user-assigned managed identity.
  - `public_network_access_enabled` - (Optional) Whether public network access is enabled for the SQL Server. Defaults to `true`.
  - `tags` - (Optional) A map of tags to assign to the SQL Server.
  - `transparent_data_encryption_key_vault_key_id` - (Optional) The key vault key ID for transparent data encryption.

  - `azuread_administrator` - (Optional) Configuration for the Azure AD administrator. The following attributes can be specified:
    - `login_username` - (Required) The username of the Azure AD administrator.
    - `object_id` - (Required) The object ID of the Azure AD administrator.
    - `azuread_authentication_only` - (Optional) Whether to enable Azure AD authentication only. Defaults to `false`.
    - `tenant_id` - (Required) The tenant ID of the Azure AD administrator.

  - `lock` - (Optional) Configuration for resource locks. The following attributes can be specified:
    - `kind` - (Required) The type of lock. Possible values are `"CanNotDelete"` and `"ReadOnly"`.
    - `name` - (Optional) The name of the lock. If not specified, a name will be generated.

  - `role_assignments` - (Optional) A map of role assignments to create on the SQL Server. The map key is arbitrary. The following attributes can be specified:
    - `role_definition_id_or_name` - (Required) The ID or name of the role definition to assign.
    - `principal_id` - (
DESCRIPTION
}

variable "private_dns_zone_config" {
  type = object({
    domain_name           = string
    resource_group_name   = string
    tags                  = optional(map(string), null)
    soa_record            = optional(object({
      email        = string
      expire_time  = optional(number, 2419200)
      minimum_ttl  = optional(number, 10)
      refresh_time = optional(number, 3600)
      retry_time   = optional(number, 300)
      ttl          = optional(number, 3600)
      tags         = optional(map(string), null)
    }), null)
    timeouts              = optional(object({
      dns_zones = optional(object({
        create = optional(string, "30m")
        delete = optional(string, "30m")
        update = optional(string, "30m")
        read   = optional(string, "5m")
      }), {})
      vnet_links = optional(object({
        create = optional(string, "30m")
        delete = optional(string, "30m")
        update = optional(string, "30m")
        read   = optional(string, "5m")
      }), {})
    }), {})
    virtual_network_links = optional(map(object({
      vnetlinkname     = string
      vnetid           = string
      autoregistration = optional(bool, false)
      tags             = optional(map(string), null)
    })), {})
    a_records             = optional(map(object({
      name                = string
      resource_group_name = string
      zone_name           = string
      ttl                 = number
      records             = list(string)
      tags                = optional(map(string), null)
    })), {})
    aaaa_records          = optional(map(object({
      name                = string
      resource_group_name = string
      zone_name           = string
      ttl                 = number
      records             = list(string)
      tags                = optional(map(string), null)
    })), {})
    cname_records         = optional(map(object({
      name                = string
      resource_group_name = string
      zone_name           = string
      ttl                 = number
      record              = string
      tags                = optional(map(string), null)
    })), {})
    mx_records            = optional(map(object({
      name                = optional(string, "@")
      resource_group_name = string
      zone_name           = string
      ttl                 = number
      records = map(object({
        preference = number
        exchange   = string
      }))
      tags = optional(map(string), null)
    })), {})
    ptr_records           = optional(map(object({
      name                = string
      resource_group_name = string
      zone_name           = string
      ttl                 = number
      records             = list(string)
      tags                = optional(map(string), null)
    })), {})
    srv_records           = optional(map(object({
      name                = string
      resource_group_name = string
      zone_name           = string
      ttl                 = number
      records = map(object({
        priority = number
        weight   = number
        port     = number
        target   = string
      }))
      tags = optional(map(string), null)
    })), {})
    txt_records           = optional(map(object({
      name                = string
      resource_group_name = string
      zone_name           = string
      ttl                 = number
      records = map(object({
        value = string
      }))
      tags = optional(map(string), null)
    })), {})
    role_assignments      = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type                         = optional(string, null)
    })), {})
  })
  description = <<DESCRIPTION
The `private_dns_zone_config` variable is an object that defines the configuration for the Azure Private DNS Zone module. It includes the following attributes:

- `domain_name` (Required, string): The name of the private DNS zone.
- `resource_group_name` (Required, string): The name of the resource group where the private DNS zone will be deployed.
- `tags` (Optional, map(string)): A map of tags to assign to the private DNS zone.
- `soa_record` (Optional, object): Configuration for the SOA record. Includes:
  - `email` (Required, string): The email address for the SOA record.
  - `expire_time` (Optional, number): The expire time for the SOA record. Defaults to `2419200`.
  - `minimum_ttl` (Optional, number): The minimum TTL for the SOA record. Defaults to `10`.
  - `refresh_time` (Optional, number
DESCRIPTION
}
