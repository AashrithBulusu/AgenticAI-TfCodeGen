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
Defines the configuration for the Network Security Group resource. The following attributes can be specified:

- `location` - (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. Type: string.
- `name` - (Required) Specifies the name of the network security group. Changing this forces a new resource to be created. Type: string.
- `resource_group_name` - (Required) The name of the resource group in which to create the network security group. Changing this forces a new resource to be created. Type: string.
- `tags` - (Optional) A mapping of tags to assign to the resource. Type: map(string). Defaults to null.
- `timeouts` - (Optional) Specifies the timeouts for the resource operations. Type: object with the following attributes:
  - `create` - (Optional) Timeout for creating the resource. Defaults to 30 minutes. Type: string.
  - `delete` - (Optional) Timeout for deleting the resource. Defaults to 30 minutes. Type: string.
  - `read` - (Optional) Timeout for reading the resource. Defaults to 5 minutes. Type: string.
  - `update` - (Optional) Timeout for updating the resource. Defaults to 30 minutes. Type: string.
- `lock` - (Optional) Controls the Resource Lock configuration for this resource. Type: object with the following attributes:
  - `kind` - (Required) The type of lock. Possible values are `CanNotDelete` and `ReadOnly`. Type: string.
  - `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Type: string. Defaults to null.
- `role_assignments` - (Optional) A map of role assignments to create on this resource. Type: map(object) with the following attributes:
  - `role_definition_id_or_name` - (Required) The ID or name of the role definition to assign to the principal. Type: string.
  - `principal_id` - (Required) The ID of the principal to assign the role to. Type: string.
  - `description` - (Optional) The description of the role assignment. Type: string. Defaults to null.
  - `skip_service_principal_aad_check` - (Optional) If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false. Type: bool.
  - `condition` - (Optional) The condition which will be used to scope the role assignment. Type: string. Defaults to null.
  - `condition_version` - (Optional) The version of the condition syntax. Valid values are '2.0'. Type: string. Defaults to null.
  - `delegated_managed_identity_resource_id` - (Optional) The resource ID of the delegated managed identity. Type: string. Defaults to null.
  - `principal_type` - (Optional) The type of the `principal_id`. Possible values are `User`, `Group`, and `ServicePrincipal`. Type: string. Defaults to null.
- `diagnostic_settings` - (Optional) A map of diagnostic settings to create on the resource. Type: map(object) with the following attributes:
DESCRIPTION
}
variable "network_interface_config" {
  type = object({
    location                       = string
    name                           = string
    resource_group_name            = string
    accelerated_networking_enabled = optional(bool, false)
    dns_servers                    = optional(list(string), null)
    edge_zone                      = optional(string, null)
    internal_dns_name_label        = optional(string, null)
    ip_forwarding_enabled          = optional(bool, false)
    tags                           = optional(map(string), null)
    ip_configurations              = map(object({
      name                                               = string
      gateway_load_balancer_frontend_ip_configuration_id = optional(string, null)
      subnet_id                                          = string
      private_ip_address_version                         = optional(string, "IPv4")
      private_ip_address_allocation                      = optional(string, "Dynamic")
      public_ip_address_id                               = optional(string, null)
      primary                                            = optional(bool, null)
      private_ip_address                                 = optional(string, null)
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
    nat_rule_association           = optional(map(object({
      nat_rule_id           = string
      ip_configuration_name = string
    })), {})
    network_security_group_ids = optional(list(string), null)
    lock                       = optional(object({
      kind = string
      name = optional(string, null)
    }), null)
  })
  description = <<DESCRIPTION
An object describing the configuration for the Azure network interface resource. The attributes are as follows:

- `location` (Required, string): The Azure location where the network interface should exist.
- `name` (Required, string): The name of the network interface.
- `resource_group_name` (Required, string): The name of the resource group in which to create the network interface.
- `accelerated_networking_enabled` (Optional, bool): Specifies whether accelerated networking should be enabled on the network interface. Defaults to `false`.
- `dns_servers` (Optional, list(string)): A list of IP addresses representing DNS servers. Defaults to `null`.
- `edge_zone` (Optional, string): Specifies the extended location of the network interface. Defaults to `null`.
- `internal_dns_name_label` (Optional, string): The DNS name used for internal communications between virtual machines in the same virtual network. Defaults to `null`.
- `ip_forwarding_enabled` (Optional, bool): Specifies whether IP forwarding should be enabled on the network interface. Defaults to `false`.
- `tags` (Optional, map(string)): A map of tags to assign to the network interface. Defaults to `null`.
- `ip_configurations` (Required, map(object)): A map of IP configurations for the network interface. Each configuration includes:
  - `name` (Required, string): The name of the IP configuration.
  - `gateway_load_balancer_frontend_ip_configuration_id` (Optional, string): The resource ID of the gateway load balancer frontend IP configuration. Defaults to `null`.
  - `subnet_id` (Required, string): The resource ID of the subnet.
  - `private_ip_address_version` (Optional, string): The IP address version (`"IPv4"` or `"IPv6"`). Defaults to `"IPv4"`.
  - `private_ip_address_allocation` (Optional, string): The allocation method for the private IP address (`"Static"` or `"Dynamic"`). Defaults to `"Dynamic"`.
  - `public_ip_address_id` (Optional, string): The resource ID of the public IP address. Defaults to `null`.
  - `primary` (Optional, bool): Specifies whether this IP configuration is the primary one. Defaults to `null`.
  - `private_ip_address` (Optional, string): The private IP address if allocation is `"Static"`. Defaults to `null`.
- `load_balancer_backend_address_pool_association` (Optional, map(object)): A map of load balancer backend address pool associations. Each association includes:
  - `load_balancer_backend_address_pool_id` (Required, string): The resource ID of the load balancer backend address pool.
  - `ip_configuration_name` (Required, string): The name of the network interface IP configuration.
- `application_gateway_backend_address_pool_association` (Optional, object): An object describing the application gateway backend address pool association. Includes:
  - `application_gateway_backend_address_pool_id` (Required, string): The resource ID of the application gateway backend address pool.
  - `ip_configuration_name` (Required, string): The name of the network interface IP configuration.
- `application_security_group_ids` (Optional, list(string)): A list of application
DESCRIPTION
}
variable "virtual_machine_config" {
  type = object({
    admin_password                  = string
    admin_username                  = string
    auto_upgrade_minor_version      = bool
    custom_location_id              = string
    data_disk_params                = map(object({
      name        = string
      diskSizeGB  = number
      dynamic     = bool
      tags        = optional(map(string))
      containerId = optional(string)
    }))
    domain_join_extension_tags      = optional(map(string), null)
    domain_join_password            = optional(string, null)
    domain_join_user_name           = optional(string, "")
    domain_target_ou                = optional(string, "")
    domain_to_join                  = optional(string, "")
    dynamic_memory                  = bool
    dynamic_memory_buffer           = number
    dynamic_memory_max              = number
    dynamic_memory_min              = number
    enable_telemetry                = bool
    http_proxy                      = optional(string, null)
    https_proxy                     = optional(string, null)
    image_id                        = string
    linux_ssh_config                = optional(object({
      publicKeys = list(object({
        keyData = string
        path    = string
      }))
    }), null)
    location                        = string
    lock                            = optional(object({
      kind = string
      name = optional(string, null)
    }), null)
    logical_network_id              = string
    managed_identities              = object({
      system_assigned            = optional(bool, false)
      user_assigned_resource_ids = optional(set(string), [])
    })
    memory_mb                       = number
    name                            = string
    nic_tags                        = optional(map(string), null)
    no_proxy                        = list(string)
    os_type                         = string
    private_ip_address              = optional(string, "")
    resource_group_name             = string
    role_assignments                = map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type                         = optional(string, null)
    }))
    secure_boot_enabled             = bool
    tags                            = optional(map(string), null)
    trusted_ca                      = optional(string, null)
    type_handler_version            = string
    user_storage_id                 = optional(string, "")
    v_cpu_count                     = number
    windows_ssh_config              = optional(object({
      publicKeys = list(object({
        keyData = string
        path    = string
      }))
    }), null)
  })

  description = <<DESCRIPTION
The configuration object for the Azure Stack HCI Virtual Machine Instance. The following attributes are supported:

- `admin_password` (string, required): The administrator password for the virtual machine.
- `admin_username` (string, required): The administrator username for the virtual machine.
- `auto_upgrade_minor_version` (bool, optional): Whether to enable auto-upgrade for minor versions. Defaults to true.
- `custom_location_id` (string, required): The custom location ID for the Azure Stack HCI cluster.
- `data_disk_params` (map(object), optional): A map of data disk configurations. Each object includes:
  - `name` (string, required): The name of the data disk.
  - `diskSizeGB` (number, required): The size of the disk in GB.
  - `dynamic` (bool, required): Whether the disk is dynamic.
  - `tags` (map(string), optional): Tags for the disk.
  - `containerId` (string, optional): The container ID for the disk.
- `domain_join_extension_tags` (map(string), optional): Tags for the domain join extension.
- `domain_join_password` (string, optional): Password for the domain join user. Required if `domain_to_join` is specified.
- `domain_join_user_name` (string, optional): Username for domain join. Required if `domain_to_join` is specified.
- `domain_target_ou` (string, optional): Organizational unit for domain join.
- `domain_to_join` (string, optional): Domain name to join the VM to.
- `dynamic_memory` (bool, optional): Whether to enable dynamic memory. Defaults to true.
- `dynamic_memory_buffer` (number, optional): Buffer memory in MB for dynamic memory. Defaults to 20.
- `dynamic_memory_max` (number, optional): Maximum memory in MB for dynamic memory. Defaults to 8192.
- `dynamic_memory_min` (number, optional): Minimum memory in MB for dynamic memory. Defaults to 512.
- `enable_telemetry` (bool, required): Whether to enable telemetry for the module.
- `http_proxy` (string, optional): HTTP proxy URL.
- `https_proxy`
DESCRIPTION
}
variable "load_balancer_config" {
  type = object({
    location                          = string
    name                              = string
    resource_group_name               = string
    edge_zone                         = optional(string, null)
    sku                               = optional(string, "Standard")
    sku_tier                          = optional(string, "Regional")
    tags                              = optional(map(string), {})
    frontend_ip_configurations        = map(object({
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
    backend_address_pools            = map(object({
      name                        = optional(string, "bepool-1")
      virtual_network_resource_id = optional(string)
      tunnel_interfaces = optional(map(object({
        identifier = optional(number)
        type       = optional(string)
        protocol   = optional(string)
        port       = optional(number)
      })), {})
    }))
    lb_rules                         = map(object({
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
    lb_probes                        = map(object({
      name                            = optional(string)
      protocol                        = optional(string, "Tcp")
      port                            = optional(number, 80)
      interval_in_seconds             = optional(number, 15)
      probe_threshold                 = optional(number, 1)
      request_path                    = optional(string)
      number_of_probes_before_removal = optional(number, 2)
    }))
    lb_nat_rules                     = map(object({
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
    lb_outbound_rules                = map(object({
      name                               = optional(string)
      frontend_ip_configurations         = optional(list(object({ name = optional(string) })))
      backend_address_pool_resource_id   = optional(string)
      backend_address_pool_object_name   = optional(string)
      protocol                           = optional(string, "Tcp")
      enable_tcp_reset                   = optional(bool, false)
      number_of_allocated_outbound_ports = optional(number, 1024)
      idle_timeout_in_minutes            = optional(number, 4)
    }))
  })
  description = <<DESCRIPTION
  An object variable that defines the configuration for an Azure Load Balancer.

  - `location`: (Required) The Azure region where the resources should be deployed. Example: "East US".
  - `name`: (Required) The name of the load balancer.
  - `resource_group_name`: (Required) The name of the resource group where the load balancer will be deployed.
  - `edge_zone`: (Optional) Specifies the Edge Zone within the Azure Region where this Load Balancer should exist. Defaults to null.
  - `sku`: (Optional) The SKU of the Azure Load Balancer. Accepted values are `Basic`, `Standard`, and `Gateway`. Defaults to `Standard`.
  - `sku_tier`: (Optional) Specifies the SKU tier of this Load Balancer. Possible values are `Global` and `Regional`. Defaults to `Regional`.
  - `tags`: (Optional) A mapping of tags to assign to the Load Balancer.

  - `frontend_ip_configurations`: (Required) A map of objects that define the frontend IP configurations for the Load Balancer.
    - `name`: (Optional) The name of the frontend IP configuration.
    - `frontend_private_ip_address`: (Optional) The private IP address to assign to the Load Balancer.
    -
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
    tags                              = optional(map(string), null)
  })
  description = <<DESCRIPTION
The configuration object for the Azure Storage Account resource. This object includes the following attributes:
- `account_replication_type` (Required, string): Specifies the replication type for the storage account. Possible values are `LRS`, `GRS`, `RAGRS`, or `ZRS`.
- `account_tier` (Required, string): Specifies the performance tier of the storage account. Possible values are `Standard` or `Premium`.
- `location` (Required, string): The Azure region where the storage account will be created.
- `name` (Required, string): The name of the storage account. Must be globally unique and conform to Azure naming rules.
- `resource_group_name` (Required, string): The name of the resource group in which to create the storage account.
- `access_tier` (Optional, string): Specifies the access tier for the storage account. Possible values are `Hot` or `Cool`. Only applicable for `BlobStorage` and `GeneralPurposeV2` accounts.
- `account_kind` (Required, string): Specifies the kind of storage account. Possible values are `Storage`, `StorageV2`, or `BlobStorage`.
- `allow_nested_items_to_be_public` (Optional, bool): Indicates whether nested items within the account can be made public. Defaults to `false`.
- `allowed_copy_scope` (Optional, string): Specifies the scope of copy operations. Possible values are `Private` or `Azure`.
- `cross_tenant_replication_enabled` (Optional, bool): Indicates whether cross-tenant replication is enabled. Defaults to `false`.
- `default_to_oauth_authentication` (Optional, bool): Indicates whether OAuth authentication is the default for the storage account. Defaults to `false`.
- `edge_zone` (Optional, string): Specifies the edge zone for the storage account, if applicable.
- `https_traffic_only_enabled` (Optional, bool): Indicates whether only HTTPS traffic is allowed. Defaults to `true`.
- `infrastructure_encryption_enabled` (Optional, bool): Indicates whether infrastructure encryption is enabled. Defaults to `false`.
- `is_hns_enabled` (Optional, bool): Indicates whether the storage account has a hierarchical namespace enabled. Defaults to `false`.
- `large_file_share_enabled` (Optional, bool): Indicates whether large file shares are enabled for the storage account. Defaults to `false`.
- `min_tls_version` (Optional, string): Specifies the minimum TLS version required for the storage account. Defaults to `TLS1_2`.
- `nfsv3_enabled` (Optional, bool): Indicates whether NFSv3 protocol is enabled. Defaults to `false`.
- `public_network_access_enabled` (Optional, bool): Indicates whether public network access is enabled for the storage account. Defaults to `true`.
- `queue_encryption_key_type` (Optional, string): Specifies the encryption key type for queues. Possible values are `Account` or `Service`.
- `sftp_enabled` (Optional, bool): Indicates whether SFTP is enabled for the storage account. Defaults to `false`.
- `shared_access_key_enabled` (Optional, bool): Indicates whether shared access keys are enabled for the storage account. Defaults to `true`.
- `table_encryption_key_type` (Optional, string): Specifies the encryption key type for tables. Possible values are `Account` or `Service`.
- `tags` (Optional, map(string)): A map of tags to assign to the storage account.
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
      tenant_id                   = optional(string, null)
    }), null)
  })
  description = <<DESCRIPTION
  Configuration object for the Azure SQL Server resource. The following attributes can be specified:

  - `location` - (Required) The Azure region where the SQL Server will be deployed.
  - `name` - (Required) The name of the SQL Server resource.
  - `resource_group_name` - (Required) The name of the resource group where the SQL Server will be deployed.
  - `server_version` - (Required) The version of the SQL Server. Example values include `12.0` or `14.0`.
  - `administrator_login` - (Required) The administrator username for the SQL Server.
  - `administrator_login_password` - (Required) The administrator password for the SQL Server.
  - `connection_policy` - (Optional) The connection policy for the SQL Server. Possible values are `Default`, `Proxy`, and `Redirect`. Defaults to `null`.
  - `express_vulnerability_assessment_enabled` - (Optional) Whether Express Vulnerability Assessment is enabled for the SQL Server. Defaults to `false`.
  - `outbound_network_restriction_enabled` - (Optional) Whether outbound network restrictions are enabled for the SQL Server. Defaults to `false`.
  - `primary_user_assigned_identity_id` - (Optional) The resource ID of the primary user-assigned identity to associate with the SQL Server. Defaults to `null`.
  - `public_network_access_enabled` - (Optional) Whether public network access is enabled for the SQL Server. Defaults to `true`.
  - `tags` - (Optional) A map of tags to assign to the SQL Server resource. Defaults to an empty map `{}`.
  - `transparent_data_encryption_key_vault_key_id` - (Optional) The resource ID of the Key Vault key to use for Transparent Data Encryption. Defaults to `null`.
  - `azuread_administrator` - (Optional) Configuration for the Azure Active Directory administrator for the SQL Server. If not specified, no Azure AD administrator will be configured. The following attributes can be specified:
    - `login_username` - (Required) The username of the Azure AD administrator.
    - `object_id` - (Required) The object ID of the Azure AD administrator.
    - `azuread_authentication_only` - (Optional) Whether Azure AD authentication is enabled only for the administrator. Defaults to `false`.
    - `tenant_id` - (Optional) The tenant ID of the Azure AD administrator. Defaults to `null`.
  DESCRIPTION
}

variable "private_dns_zone_config" {
  type = object({
    domain_name            = string
    resource_group_name    = string
    tags                   = optional(map(string), null)
    soa_record             = optional(object({
      email        = string
      expire_time  = optional(number, 2419200)
      minimum_ttl  = optional(number, 10)
      refresh_time = optional(number, 3600)
      retry_time   = optional(number, 300)
      ttl          = optional(number, 3600)
      tags         = optional(map(string), null)
    }), null)
    timeouts               = optional(object({
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
    virtual_network_links  = optional(map(object({
      vnetlinkname     = string
      vnetid           = string
      autoregistration = optional(bool, false)
      tags             = optional(map(string), null)
    })), {})
    a_records              = optional(map(object({
      name                = string
      resource_group_name = string
      zone_name           = string
      ttl                 = number
      records             = list(string)
      tags                = optional(map(string), null)
    })), {})
    aaaa_records           = optional(map(object({
      name                = string
      resource_group_name = string
      zone_name           = string
      ttl                 = number
      records             = list(string)
      tags                = optional(map(string), null)
    })), {})
    cname_records          = optional(map(object({
      name                = string
      resource_group_name = string
      zone_name           = string
      ttl                 = number
      record              = string
      tags                = optional(map(string), null)
    })), {})
    mx_records             = optional(map(object({
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
    ptr_records            = optional(map(object({
      name                = string
      resource_group_name = string
      zone_name           = string
      ttl                 = number
      records             = list(string)
      tags                = optional(map(string), null)
    })), {})
    srv_records            = optional(map(object({
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
    txt_records            = optional(map(object({
      name                = string
      resource_group_name = string
      zone_name           = string
      ttl                 = number
      records = map(object({
        value = string
      }))
      tags = optional(map(string), null)
    })), {})
    role_assignments       = optional(map(object({
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

- `domain_name` (string, required): The name of the private DNS zone.
- `resource_group_name` (string, required): The name of the resource group where the resources will be deployed.
- `tags` (map(string), optional): A map of tags to assign to the resources. Defaults to `null`.
- `soa_record` (object, optional): Configuration for the SOA record. Includes:
  - `email` (string, required): The email address for the SOA record.
  - `expire_time` (number, optional): The expire time in seconds. Defaults to `2419200`.
  - `minimum_ttl` (number, optional): The minimum TTL in seconds. Defaults to `10`.
  - `refresh_time` (number, optional): The refresh time
DESCRIPTION
}
