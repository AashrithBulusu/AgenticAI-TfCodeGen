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
    enable_telemetry = optional(bool, true)
  })
  description = <<EOT
Configuration object for the Network Security Group module.

- `location` - (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.
- `name` - (Required) Specifies the name of the network security group. Changing this forces a new resource to be created.
- `resource_group_name` - (Required) The name of the resource group in which to create the network security group. Changing this forces a new resource to be created.
- `tags` - (Optional) A mapping of tags to assign to the resource.
- `timeouts` - (Optional) Configuration for resource timeouts.
  - `create` - (Defaults to 30 minutes) Used when creating the Network Security Group.
  - `delete` - (Defaults to 30 minutes) Used when deleting the Network Security Group.
  - `read` - (Defaults to 5 minutes) Used when retrieving the Network Security Group.
  - `update` - (Defaults to 30 minutes) Used when updating the Network Security Group.
- `lock` - (Optional) Controls the Resource Lock configuration for this resource.
  - `kind` - (Required) The type of lock. Possible values are `CanNotDelete` and `ReadOnly`.
  - `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.
- `role_assignments` - (Optional) A map of role assignments to create on this resource.
  - `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
  - `principal_id` - The ID of the principal to assign the role to.
  - `description` - The description of the role assignment.
  - `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
  - `condition` - The condition which will be used to scope the role assignment.
  - `condition_version` - The version of the condition syntax. Valid values are '2.0'.
  - `delegated_managed_identity_resource_id` - The resource ID of the delegated managed identity.
  - `principal_type` - (Optional) The type of the `principal_id`. Possible values are `User`, `Group` and `ServicePrincipal`.
- `diagnostic_settings` - (Optional) A map of diagnostic settings to create on the Network Security Group.
  - `name` - (Optional) The name of the diagnostic setting. One will be generated if not set.
  - `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
  - `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
  - `metric_categories` - (Optional) A set of metric categories to send to the log analytics workspace. Defaults to `["AllMetrics"]`.
  - `log_analytics_destination_type` - (Optional) The destination type for the diagnostic setting. Possible values are `Dedicated` and `AzureDiagnostics`.
variable "network_interface_config" {
  type = object({
    location                                     = string
    name                                         = string
    resource_group_name                         = string
    accelerated_networking_enabled              = optional(bool, false)
    application_gateway_backend_address_pool_association = optional(object({
      application_gateway_backend_address_pool_id = string
      ip_configuration_name                       = string
    }), null)
    application_security_group_ids              = optional(list(string), null)
    dns_servers                                 = optional(list(string), null)
    edge_zone                                   = optional(string, null)
    enable_telemetry                            = optional(bool, true)
    internal_dns_name_label                     = optional(string, null)
    ip_forwarding_enabled                       = optional(bool, false)
    ip_configurations                           = map(object({
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
    lock = optional(object({
      kind = string
      name = optional(string, null)
    }), null)
    nat_rule_association = optional(map(object({
      nat_rule_id           = string
      ip_configuration_name = string
    })), {})
    network_security_group_ids = optional(list(string), null)
    tags                       = optional(map(string), null)
  })
  description = "Configuration object for the network interface, including all required and optional parameters."
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
    managed_identities                 = object({
      system_assigned            = optional(bool, false)
      user_assigned_resource_ids = optional(set(string), [])
    })
    memory_mb                          = optional(number, 8192)
    name                               = string
    nic_tags                           = optional(map(string), null)
    no_proxy                           = optional(list(string), [])
    os_type                            = optional(string, "Windows")
    private_ip_address                 = optional(string, "")
    resource_group_name                = string
    role_assignments                   = map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type                         = optional(string, null)
    }))
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
  description = "Configuration object for the Azure Stack HCI Virtual Machine Instance."
}
variable "load_balancer_config" {
  type = object({
    location                          = string
    name                              = string
    resource_group_name               = string
    edge_zone                         = optional(string)
    sku                               = optional(string, "Standard")
    sku_tier                          = optional(string, "Regional")
    tags                              = optional(map(string))
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
      tunnel_interfaces           = optional(map(object({
        identifier = optional(number)
        type       = optional(string)
        protocol   = optional(string)
        port       = optional(number)
      })), {})
    }))
    backend_address_pool_addresses   = map(object({
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
    lb_probes                        = map(object({
      name                            = optional(string)
      protocol                        = optional(string, "Tcp")
      port                            = optional(number, 80)
      interval_in_seconds             = optional(number, 15)
      probe_threshold                 = optional(number, 1)
      request_path                    = optional(string)
      number_of_probes_before_removal = optional(number, 2)
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
    lb_nat_pools                     = map(object({
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
    public_ip_address_configuration  = optional(object({
      resource_group_name              = optional(string)
      allocation_method                = optional(string, "Static")
      ddos_protection_mode             = optional(string, "VirtualNetworkInherited")
      ddos_protection_plan_resource_id = optional(string)
      domain_name_label                = optional(string)
      idle_timeout_in_minutes          = optional(number,
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
    azure_files_authentication = optional(object({
      directory_type                 = string
      default_share_level_permission = string
      active_directory = optional(object({
        domain_guid         = string
        domain_name         = string
        domain_sid          = string
        forest_name         = string
        netbios_domain_name = string
        storage_sid         = string
      }), null)
    }), null)
    blob_properties = optional(object({
      change_feed_enabled           = optional(bool, false)
      change_feed_retention_in_days = optional(number, null)
      default_service_version       = optional(string, null)
      last_access_time_enabled      = optional(bool, false)
      versioning_enabled            = optional(bool, false)
      container_delete_retention_policy = optional(object({
        days = number
      }), null)
      cors_rule = optional(list(object({
        allowed_headers    = list(string)
        allowed_methods    = list(string)
        allowed_origins    = list(string)
        exposed_headers    = list(string)
        max_age_in_seconds = number
      })), null)
      delete_retention_policy = optional(object({
        days = number
      }), null)
      restore_policy = optional(object({
        days = number
      }), null)
    }), null)
    custom_domain = optional(object({
      name          = string
      use_subdomain = bool
    }), null)
    managed_identities = optional(object({
      system_assigned            = optional(bool, false)
      user_assigned_resource_ids = optional(set(string), [])
    }), {})
    immutability_policy = optional(object({
      allow_protected_append_writes = optional(bool, false)
      period_since_creation_in_days = number
      state                         = string
    }), null)
    network_rules = optional(object({
      default_action             = string
      bypass                     = optional(string, null)
      ip_rules                   = optional(list(string), [])
      virtual_network_subnet_ids = optional(list(string), [])
      private_link_access = optional(list(object({
        endpoint_resource_id = string
        endpoint_tenant_id   = string
      })), null)
    }), null)
    routing = optional(object({
      choice                      = string
      publish_internet_endpoints  = optional(bool, false)
      publish_microsoft_endpoints = optional(bool, false)
    }), null)
    sas_policy = optional(object({
      expiration_period = string
      expiration_action = string
    }), null)
    share_properties = optional(object({
      cors_rule = optional(list(object({
        allowed_headers    = list(string)
        allowed_methods    = list(string)
        allowed_origins    = list(string)
        exposed_headers    = list(string)
        max_age_in_seconds = number
      })), null)
      retention_policy = optional(object({
        days = number
      }), null)
      smb = optional(object({
        authentication_types            = string
        channel_encryption_type         = string
        kerberos_ticket_encryption_type = string
        multichannel_enabled            = bool
        versions                        = string
      }), null)
    }), null)
    timeouts = optional(object({
      create = optional(string, null)
      delete = optional(string, null)
      read   = optional(string, null)
      update = optional(string, null)
    }), null)
    local_user = optional(map(object({
      name                 = string
      home_directory       = optional(string, null)
      ssh_key_enabled      = optional(bool, false)
      ssh_password_enabled = optional(bool, false)
      permission_scope = optional(list(object({
        resource_name = string
        service       = string
        permissions = object({
          create = bool
variable "sql_server_config" {
  type = object({
    location                                     = string
    name                                         = string
    resource_group_name                          = string
    server_version                               = string
    administrator_login                          = string
    administrator_login_password                 = string
    connection_policy                            = string
    outbound_network_restriction_enabled         = bool
    primary_user_assigned_identity_id            = optional(string, null)
    public_network_access_enabled                = bool
    tags                                         = optional(map(string), null)
    transparent_data_encryption_key_vault_key_id = optional(string, null)
    azuread_administrator = optional(object({
      login_username              = string
      object_id                   = string
      azuread_authentication_only = bool
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
    managed_identities = optional(object({
      system_assigned            = optional(bool, false)
      user_assigned_resource_ids = optional(set(string), [])
    }), {})
  })
  description = "Configuration object for the Azure SQL Server resource, containing all required and optional parameters for the module."
}

variable "private_dns_zone_config" {
  type = object({
    domain_name            = string
    resource_group_name    = string
    tags                   = optional(map(string), null)
    enable_telemetry       = optional(bool, true)
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
  description = "Configuration object for the private DNS zone module, including all required and optional inputs."
}
