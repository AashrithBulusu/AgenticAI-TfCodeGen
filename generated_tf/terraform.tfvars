network_security_group_config = {
  location            = "eastus"
  name                = "example-nsg"
  resource_group_name = "example-rg"
  tags = {
    environment = "production"
    owner       = "team-network"
  }
  timeouts = {
    create = "40m"
    delete = "20m"
    read   = "10m"
    update = "35m"
  }
  lock = {
    kind = "CanNotDelete"
    name = "example-lock"
  }
  role_assignments = {
    "assignment1" = {
      role_definition_id_or_name          = "Contributor"
      principal_id                        = "00000000-0000-0000-0000-000000000001"
      description                         = "Role assignment for Contributor"
      skip_service_principal_aad_check    = true
      condition                           = "resource.type == 'Microsoft.Network/networkSecurityGroups'"
      condition_version                   = "2.0"
      delegated_managed_identity_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/example-identity"
      principal_type                      = "User"
    }
    "assignment2" = {
      role_definition_id_or_name          = "Reader"
      principal_id                        = "00000000-0000-0000-0000-000000000002"
      description                         = null
      skip_service_principal_aad_check    = false
      condition                           = null
      condition_version                   = null
      delegated_managed_identity_resource_id = null
      principal_type                      = "Group"
    }
  }
  diagnostic_settings = {
    "diagnostic1" = {
      name                              = "example-diagnostic"
      log_categories                    = ["NetworkSecurityGroupEvent", "NetworkSecurityGroupRuleCounter"]
      log_groups                        = ["allLogs"]
      metric_categories                 = ["AllMetrics"]
      log_analytics_destination_type    = "Dedicated"
      workspace_resource_id             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.OperationalInsights/workspaces/example-workspace"
      storage_account_resource_id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Storage/storageAccounts/examplestorage"
      event_hub_authorization_rule_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.EventHub/namespaces/example-namespace/authorizationRules/example-rule"
      event_hub_name                    = "example-eventhub"
      marketplace_partner_resource_id   = null
    }
    "diagnostic2" = {
      name                              = null
      log_categories                    = []
      log_groups                        = ["allLogs"]
      metric_categories                 = ["AllMetrics"]
      log_analytics_destination_type    = "AzureDiagnostics"
      workspace_resource_id             = null
      storage_account_resource_id       = null
      event_hub_authorization_rule_resource_id = null
      event_hub_name                    = null
      marketplace_partner_resource_id   = null
    }
  }
}

network_interface_config = {
  location                          = "eastus"
  name                              = "example-nic"
  resource_group_name               = "example-resource-group"
  accelerated_networking_enabled    = true
  dns_servers                       = ["8.8.8.8", "8.8.4.4"]
  edge_zone                         = "example-edge-zone"
  internal_dns_name_label           = "example-dns-label"
  ip_forwarding_enabled             = true
  tags                              = { environment = "production", owner = "team-a" }
  ip_configurations = {
    ipconfig1 = {
      name                                      = "ipconfig1"
      private_ip_address_allocation             = "Static"
      private_ip_address_version                = "IPv4"
      private_ip_address                        = "10.0.0.4"
      public_ip_address_id                      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.Network/publicIPAddresses/example-pip"
      gateway_load_balancer_frontend_ip_configuration_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.Network/loadBalancers/example-lb/frontendIPConfigurations/example-frontend"
      subnet_id                                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/example-vnet/subnets/example-subnet"
      primary                                   = true
    }
    ipconfig2 = {
      name                                      = "ipconfig2"
      private_ip_address_allocation             = "Dynamic"
      private_ip_address_version                = "IPv6"
      private_ip_address                        = null
      public_ip_address_id                      = null
      gateway_load_balancer_frontend_ip_configuration_id = null
      subnet_id                                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/example-vnet/subnets/example-subnet"
      primary                                   = false
    }
  }
  load_balancer_backend_address_pool_association = {
    lbpool1 = {
      load_balancer_backend_address_pool_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.Network/loadBalancers/example-lb/backendAddressPools/example-pool"
      ip_configuration_name                 = "ipconfig1"
    }
  }
  application_gateway_backend_address_pool_association = {
    application_gateway_backend_address_pool_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.Network/applicationGateways/example-ag/backendAddressPools/example-ag-pool"
    ip_configuration_name                       = "ipconfig1"
  }
  application_security_group_ids = [
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.Network/applicationSecurityGroups/example-asg1",
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.Network/applicationSecurityGroups/example-asg2"
  ]
  nat_rule_association = {
    natrule1 = {
      nat_rule_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.Network/loadBalancers/example-lb/inboundNatRules/example-nat-rule"
      ip_configuration_name = "ipconfig1"
    }
  }
  network_security_group_ids = [
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.Network/networkSecurityGroups/example-nsg1",
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.Network/networkSecurityGroups/example-nsg2"
  ]
  lock = {
    kind = "CanNotDelete"
    name = "example-lock"
  }
}

virtual_machine_config = {
  name                        = "my-vm"
  location                    = "East US"
  resource_group_name         = "my-resource-group"
  admin_username              = "adminuser"
  admin_password              = "P@ssw0rd123!"
  custom_location_id          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.CustomLocation/customLocations/my-custom-location"
  image_id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Compute/images/my-image"
  memory_mb                   = 16384
  v_cpu_count                 = 4
  os_type                     = "Linux"
  dynamic_memory              = true
  dynamic_memory_min          = 1024
  dynamic_memory_max          = 16384
  dynamic_memory_buffer       = 25
  secure_boot_enabled         = true
  logical_network_id          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet"
  private_ip_address          = "10.0.0.4"
  tags                        = { "environment" = "production", "owner" = "team-a" }
  nic_tags                    = { "role" = "frontend", "project" = "project-x" }
  data_disk_params = {
    "disk1" = {
      name        = "data-disk-1"
      diskSizeGB  = 128
      dynamic     = true
      tags        = { "tier" = "gold" }
      containerId = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Storage/storageAccounts/my-storage-account"
    }
    "disk2" = {
      name        = "data-disk-2"
      diskSizeGB  = 256
      dynamic     = false
      tags        = { "tier" = "silver" }
    }
  }
  domain_to_join              = "mydomain.local"
  domain_join_user_name       = "domainadmin"
  domain_join_password        = "DomainP@ssw0rd!"
  domain_target_ou            = "OU=Servers,DC=mydomain,DC=local"
  domain_join_extension_tags  = { "extension" = "domain-join", "version" = "1.0" }
  auto_upgrade_minor_version  = true
  enable_telemetry            = true
  http_proxy                  = "http://proxy.example.com:8080"
  https_proxy                 = "https://proxy.example.com:8443"
  no_proxy                    = ["localhost", "127.0.0.1", "example.com"]
  trusted_ca                  = "-----BEGIN CERTIFICATE-----\nMIID...END CERTIFICATE-----"
  type_handler_version        = "1.4"
  user_storage_id             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Storage/storageAccounts/user-storage"
  linux_ssh_config = {
    publicKeys = [
      {
        keyData = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEArandomkeydata"
        path    = "/home/adminuser/.ssh/authorized_keys"
      }
    ]
  }
  windows_ssh_config = {
    publicKeys = [
      {
        keyData = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEArandomkeydata"
        path    = "C:\\Users\\adminuser\\.ssh\\authorized_keys"
      }
    ]
  }
  lock = {
    level = "CanNotDelete"
    notes = "This lock prevents accidental deletion of the VM."
  }
  backup_policy_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.RecoveryServices/vaults/my-backup-vault/backupPolicies/my-policy"
  diagnostics_profile = {
    boot_diagnostics = {
      enabled     = true
      storage_uri = "https://mydiagstorage.blob.core.windows.net/"
    }
  }
  availability_set_id             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Compute/availabilitySets/my-availability-set"
  proximity_placement_group_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Compute/proximityPlacementGroups/my-ppg"
  ultra_ssd_enabled               = true
  eviction_policy                 = "Deallocate"
  priority                        = "Spot"
  max_price                       = 0.05
  scheduled_events_profile = {
    terminate_notification = {
      enabled             = true
      not_before_timeout  = "PT5M"
    }
  }
}

load_balancer_config = {
  location              = "eastus"
  name                  = "my-load-balancer"
  resource_group_name   = "my-resource-group"
  edge_zone             = null
  sku                   = "Standard"
  sku_tier              = "Regional"
  tags                  = { environment = "production", owner = "team-a" }
  frontend_ip_configurations = {
    frontend1 = {
      name                                      = "frontend-ip-config-1"
      frontend_private_ip_address               = "10.0.0.5"
      frontend_private_ip_address_version       = "IPv4"
      frontend_private_ip_address_allocation    = "Static"
      frontend_private_ip_subnet_resource_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-subnet"
      gateway_load_balancer_frontend_ip_configuration_id = null
      public_ip_address_resource_id             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/publicIPAddresses/my-public-ip"
      create_public_ip_address                  = false
      zones                                     = ["1", "2", "3"]
    }
  }
  backend_address_pools = {
    backend1 = {
      name                        = "backend-pool-1"
      virtual_network_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet"
      tunnel_interfaces           = {
        tunnel1 = {
          identifier = 1
          type       = "IPSec"
          protocol   = "Tcp"
          port       = 443
        }
      }
    }
  }
  lb_rules = {
    rule1 = {
      name                           = "lb-rule-1"
      frontend_ip_configuration_name = "frontend-ip-config-1"
      protocol                       = "Tcp"
      frontend_port                  = 80
      backend_port                   = 8080
      backend_address_pool_resource_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/loadBalancers/my-load-balancer/backendAddressPools/backend-pool-1"]
      probe_resource_id              = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/loadBalancers/my-load-balancer/probes/my-probe"
      enable_floating_ip             = false
      idle_timeout_in_minutes        = 5
      load_distribution              = "Default"
    }
  }
  lb_probes = {
    probe1 = {
      name                  = "my-probe"
      protocol              = "Tcp"
      port                  = 80
      request_path          = null
      interval_in_seconds   = 5
      number_of_probes      = 2
    }
  }
  inbound_nat_rules = {
    natrule1 = {
      name                           = "nat-rule-1"
      frontend_ip_configuration_name = "frontend-ip-config-1"
      protocol                       = "Tcp"
      frontend_port                  = 22
      backend_port                   = 22
      backend_ip_configuration_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/networkInterfaces/my-nic/ipConfigurations/ipconfig1"
      enable_floating_ip             = false
      idle_timeout_in_minutes        = 4
    }
  }
  outbound_rules = {
    outbound1 = {
      name                           = "outbound-rule-1"
      frontend_ip_configuration_name = "frontend-ip-config-1"
      backend_address_pool_resource_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/loadBalancers/my-load-balancer/backendAddressPools/backend-pool-1"]
      protocol                       = "All"
      idle_timeout_in_minutes        = 4
      enable_tcp_reset               = true
    }
  }
}

storage_account_config = {
  account_replication_type          = "LRS"
  account_tier                      = "Standard"
  location                          = "eastus"
  name                              = "mystorageaccount"
  resource_group_name               = "my-resource-group"
  access_tier                       = "Hot"
  account_kind                      = "StorageV2"
  allow_nested_items_to_be_public   = true
  allowed_copy_scope                = "Private"
  cross_tenant_replication_enabled  = true
  default_to_oauth_authentication   = true
  edge_zone                         = "edge-zone-1"
  https_traffic_only_enabled        = true
  infrastructure_encryption_enabled = true
  is_hns_enabled                    = true
  large_file_share_enabled          = true
  min_tls_version                   = "TLS1_2"
  nfsv3_enabled                     = true
  public_network_access_enabled     = true
  queue_encryption_key_type         = "Account"
  sftp_enabled                      = true
  shared_access_key_enabled         = true
  table_encryption_key_type         = "Service"
  tags                              = {
    environment = "production"
    owner       = "team-a"
  }
  azure_files_authentication = {
    directory_type                 = "AADDS"
    default_share_level_permission = "Read"
    active_directory = {
      domain_guid         = "12345678-1234-1234-1234-123456789abc"
      domain_name         = "example.com"
      domain_sid          = "S-1-5-21-1234567890-1234567890-1234567890"
      forest_name         = "exampleforest.com"
      netbios_domain_name = "EXAMPLE"
      storage_sid         = "S-1-5-21-0987654321-0987654321-0987654321"
    }
  }
  blob_properties = {
    change_feed_enabled           = true
    change_feed_retention_in_days = 7
    default_service_version       = "2021-08-06"
    last_access_time_enabled      = true
    container_delete_retention_policy = {
      days = 30
    }
    versioning_enabled = true
  }
  queue_properties = {
    logging = {
      delete                = true
      read                  = true
      write                 = true
      retention_policy_days = 7
    }
    hour_metrics = {
      enabled               = true
      include_apis          = true
      retention_policy_days = 30
    }
    minute_metrics = {
      enabled               = true
      include_apis          = true
      retention_policy_days = 7
    }
  }
  share_properties = {
    delete_retention_policy = {
      days = 14
    }
  }
}

sql_server_config = {
  location                                     = "eastus"
  name                                         = "my-sql-server"
  resource_group_name                          = "my-resource-group"
  server_version                               = "12.0"
  administrator_login                          = "adminuser"
  administrator_login_password                 = "P@ssw0rd123"
  connection_policy                            = "Redirect"
  express_vulnerability_assessment_enabled     = true
  outbound_network_restriction_enabled         = true
  primary_user_assigned_identity_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.ManagedIdentity/userAssignedIdentities/my-identity"
  public_network_access_enabled                = false
  tags                                         = {
    environment = "production"
    owner       = "team-a"
  }
  transparent_data_encryption_key_vault_key_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.KeyVault/vaults/my-key-vault/keys/my-key"

  azuread_administrator = {
    login_username              = "aadadminuser"
    object_id                   = "00000000-0000-0000-0000-000000000000"
    azuread_authentication_only = true
    tenant_id                   = "00000000-0000-0000-0000-000000000000"
  }

  identity = {
    type                     = "SystemAssigned,UserAssigned"
    user_assigned_resource_ids = [
      "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.ManagedIdentity/userAssignedIdentities/identity1",
      "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.ManagedIdentity/userAssignedIdentities/identity2"
    ]
  }

  lock = {
    kind = "CanNotDelete"
    name = "sql-server-lock"
  }

  role_assignments = {
    "role1" = {
      role_definition_id_or_name             = "Contributor"
      principal_id                           = "00000000-0000-0000-0000-000000000000"
      description                            = "Role assignment for Contributor"
      skip_service_principal_aad_check       = true
      condition                              = "resource.type == 'Microsoft.Sql/servers'"
      condition_version                      = "2.0"
      delegated_managed_identity_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.ManagedIdentity/userAssignedIdentities/delegated-identity"
      principal_type                         = "ServicePrincipal"
    }
    "role2" = {
      role_definition_id_or_name             = "Reader"
      principal_id                           = "11111111-1111-1111-1111-111111111111"
      description                            = null
      skip_service_principal_aad_check       = false
      condition                              = null
      condition_version                      = null
      delegated_managed_identity_resource_id = null
      principal_type                         = "User"
    }
  }

  diagnostic_settings = {
    "diagnostic1" = {
      name                                     = "sql-server-diagnostic"
      log_categories                           = ["SQLSecurityAuditEvents", "SQLInsights"]
      log_groups                               = ["allLogs"]
      metric_categories                        = ["AllMetrics"]
      log_analytics_destination_type           = "Dedicated"
      log_analytics_workspace_id              = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-log-workspace"
      event_hub_authorization_rule_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.EventHub/namespaces/my-eventhub/authorizationRules/my-rule"
      event_hub_name                          = "my-eventhub"
      storage_account_id                      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Storage/storageAccounts/my-storage-account"
      storage_account_key                     = "my-storage-account-key"
      storage_account_sas_token               = "my-storage-account-sas-token"
    }
  }

  timeouts = {
    create = "30m"
    update = "20m"
    delete = "15m"
  }
}

private_dns_zone_config = {
  domain_name         = "example.private"
  resource_group_name = "example-rg"
  tags = {
    environment = "production"
    owner       = "team-a"
  }
  soa_record = {
    email        = "admin@example.private"
    expire_time  = 2592000
    minimum_ttl  = 30
    refresh_time = 7200
    retry_time   = 600
    ttl          = 7200
    tags = {
      managed_by = "terraform"
    }
  }
  virtual_network_links = {
    vnet1 = {
      vnetlinkname     = "vnet1-link"
      vnetid           = "/subscriptions/12345678-1234-1234-1234-123456789abc/resourceGroups/example-rg/providers/Microsoft.Network/virtualNetworks/vnet1"
      autoregistration = true
      tags = {
        purpose = "link"
      }
    }
    vnet2 = {
      vnetlinkname     = "vnet2-link"
      vnetid           = "/subscriptions/12345678-1234-1234-1234-123456789abc/resourceGroups/example-rg/providers/Microsoft.Network/virtualNetworks/vnet2"
      autoregistration = false
      tags = {
        purpose = "link"
      }
    }
  }
  a_records = {
    record1 = {
      name                = "web"
      resource_group_name = "example-rg"
      zone_name           = "example.private"
      ttl                 = 3600
      records             = ["10.0.0.1", "10.0.0.2"]
      tags = {
        role = "frontend"
      }
    }
  }
  aaaa_records = {
    record1 = {
      name                = "web-ipv6"
      resource_group_name = "example-rg"
      zone_name           = "example.private"
      ttl                 = 3600
      records             = ["2001:db8::1", "2001:db8::2"]
      tags = {
        role = "frontend"
      }
    }
  }
  cname_records = {
    record1 = {
      name                = "alias"
      resource_group_name = "example-rg"
      zone_name           = "example.private"
      ttl                 = 3600
      record              = "web.example.private"
      tags = {
        alias_for = "web"
      }
    }
  }
  mx_records = {
    record1 = {
      name                = "@"
      resource_group_name = "example-rg"
      zone_name           = "example.private"
      ttl                 = 3600
      records = {
        mail1 = {
          preference = 10
          exchange   = "mail1.example.private"
        }
        mail2 = {
          preference = 20
          exchange   = "mail2.example.private"
        }
      }
      tags = {
        role = "mail"
      }
    }
  }
  txt_records = {
    record1 = {
      name                = "verification"
      resource_group_name = "example-rg"
      zone_name           = "example.private"
      ttl                 = 3600
      records             = ["v=spf1 include:example.com ~all"]
      tags = {
        purpose = "email-verification"
      }
    }
  }
  srv_records = {
    record1 = {
      name                = "_sip._tcp"
      resource_group_name = "example-rg"
      zone_name           = "example.private"
      ttl                 = 3600
      records = [
        {
          priority = 10
          weight   = 5
          port     = 5060
          target   = "sipserver1.example.private"
        },
        {
          priority = 20
          weight   = 10
          port     = 5060
          target   = "sipserver2.example.private"
        }
      ]
      tags = {
        service = "sip"
      }
    }
  }
  ptr_records = {
    record1 = {
      name                = "1.0.10.in-addr.arpa"
      resource_group_name = "example-rg"
      zone_name           = "example.private"
      ttl                 = 3600
      records             = ["web.example.private"]
      tags = {
        reverse_lookup = "true"
      }
    }
  }
}