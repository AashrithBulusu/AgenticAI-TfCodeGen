network_security_group_config = {
  location            = "East US"
  name                = "example-nsg"
  resource_group_name = "example-resource-group"
  tags = {
    environment = "production"
    owner       = "team-network"
  }
  timeouts = {
    create = "40m"
    delete = "20m"
    read   = "10m"
    update = "25m"
  }
  lock = {
    kind = "CanNotDelete"
    name = "example-lock"
  }
  role_assignments = {
    admin_role = {
      role_definition_id_or_name             = "Contributor"
      principal_id                           = "00000000-0000-0000-0000-000000000001"
      description                            = "Admin role assignment"
      skip_service_principal_aad_check       = true
      condition                              = "resource.type == 'Microsoft.Network/networkSecurityGroups'"
      condition_version                      = "2.0"
      delegated_managed_identity_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/example-identity"
      principal_type                         = "User"
    }
    reader_role = {
      role_definition_id_or_name             = "Reader"
      principal_id                           = "00000000-0000-0000-0000-000000000002"
      description                            = "Reader role assignment"
      skip_service_principal_aad_check       = false
      condition                              = null
      condition_version                      = null
      delegated_managed_identity_resource_id = null
      principal_type                         = "Group"
    }
  }
  diagnostic_settings = {
    diagnostics1 = {
      name                          = "example-diagnostics"
      log_categories                = ["NetworkSecurityGroupEvent", "NetworkSecurityGroupRuleCounter"]
      log_groups                    = ["allLogs"]
      metric_categories             = ["AllMetrics"]
      log_analytics_destination_type = "AzureDiagnostics"
      workspace_resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.OperationalInsights/workspaces/example-workspace"
      storage_account_resource_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Storage/storageAccounts/examplestorage"
      event_hub_authorization_rule_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.EventHub/namespaces/example-namespace/authorizationRules/example-rule"
      event_hub_name                = "example-eventhub"
      marketplace_partner_resource_id = null
    }
    diagnostics2 = {
      name                          = "example-diagnostics-2"
      log_categories                = ["NetworkSecurityGroupEvent"]
      log_groups                    = ["allLogs"]
      metric_categories             = ["AllMetrics"]
      log_analytics_destination_type = "Dedicated"
      workspace_resource_id         = null
      storage_account_resource_id   = null
      event_hub_authorization_rule_resource_id = null
      event_hub_name                = null
      marketplace_partner_resource_id = null
    }
  }
}

network_interface_config = {
  location                       = "eastus"
  name                           = "my-network-interface"
  resource_group_name            = "my-resource-group"
  accelerated_networking_enabled = true
  dns_servers                    = ["8.8.8.8", "8.8.4.4"]
  edge_zone                      = "edge-zone-1"
  internal_dns_name_label        = "internal-dns-label"
  ip_forwarding_enabled          = true
  tags                           = {
    environment = "production"
    owner       = "team-a"
  }
  ip_configurations = {
    ipconfig1 = {
      name                                               = "ipconfig1"
      private_ip_address_allocation                      = "Static"
      gateway_load_balancer_frontend_ip_configuration_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/loadBalancers/my-load-balancer/frontendIPConfigurations/my-frontend-ip"
      primary                                            = true
      private_ip_address                                 = "10.0.0.4"
      private_ip_address_version                         = "IPv4"
      public_ip_address_id                               = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/publicIPAddresses/my-public-ip"
      subnet_id                                          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-subnet"
    }
    ipconfig2 = {
      name                                               = "ipconfig2"
      private_ip_address_allocation                      = "Dynamic"
      gateway_load_balancer_frontend_ip_configuration_id = null
      primary                                            = false
      private_ip_address                                 = null
      private_ip_address_version                         = "IPv6"
      public_ip_address_id                               = null
      subnet_id                                          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-subnet"
    }
  }
  load_balancer_backend_address_pool_association = {
    lbpool1 = {
      load_balancer_backend_address_pool_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/loadBalancers/my-load-balancer/backendAddressPools/my-backend-pool"
      ip_configuration_name                 = "ipconfig1"
    }
  }
  application_gateway_backend_address_pool_association = {
    application_gateway_backend_address_pool_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/applicationGateways/my-app-gateway/backendAddressPools/my-backend-pool"
    ip_configuration_name                       = "ipconfig1"
  }
  application_security_group_ids = [
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/applicationSecurityGroups/my-asg"
  ]
  nat_rule_association = {
    natrule1 = {
      nat_rule_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/loadBalancers/my-load-balancer/inboundNatRules/my-nat-rule"
      ip_configuration_name = "ipconfig1"
    }
  }
  network_security_group_ids = [
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/networkSecurityGroups/my-nsg"
  ]
  lock = {
    kind = "CanNotDelete"
    name = "my-lock"
  }
}

virtual_machine_config = {
  admin_password              = "P@ssw0rd123!"
  admin_username              = "adminuser"
  custom_location_id          = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/myResourceGroup/providers/Microsoft.CustomLocation/customLocations/myCustomLocation"
  image_id                    = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/myResourceGroup/providers/Microsoft.Compute/galleries/myGallery/images/myImage"
  location                    = "eastus"
  logical_network_id          = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/myResourceGroup/providers/Microsoft.Network/logicalNetworks/myLogicalNetwork"
  name                        = "my-vm-name"
  resource_group_name         = "myResourceGroup"
  auto_upgrade_minor_version  = true
  data_disk_params = {
    disk1 = {
      name        = "dataDisk1"
      diskSizeGB  = 128
      dynamic     = true
      tags        = { environment = "production", owner = "admin" }
      containerId = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/myResourceGroup/providers/Microsoft.Storage/storageAccounts/myStorageAccount"
    }
    disk2 = {
      name        = "dataDisk2"
      diskSizeGB  = 256
      dynamic     = false
      tags        = { environment = "staging", owner = "developer" }
      containerId = null
    }
  }
  domain_join_extension_tags  = { environment = "production", role = "domain-join" }
  domain_join_password        = "DomainP@ssw0rd!"
  domain_join_user_name       = "domainAdmin"
  domain_target_ou            = "OU=Servers,DC=example,DC=com"
  domain_to_join              = "example.com"
  dynamic_memory              = true
  dynamic_memory_buffer       = 25
  dynamic_memory_max          = 16384
  dynamic_memory_min          = 1024
  enable_telemetry            = true
  http_proxy                  = "http://proxy.example.com:8080"
  https_proxy                 = "https://proxy.example.com:8443"
  linux_ssh_config = {
    publicKeys = [
      {
        keyData = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEArandomkeydata"
        path    = "/home/adminuser/.ssh/authorized_keys"
      },
      {
        keyData = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAnotherRandomKeyData"
        path    = "/home/adminuser/.ssh/id_rsa.pub"
      }
    ]
  }
  lock = {
    kind = "ReadOnly"
    name = "vm-lock"
  }
  managed_identities = {
    system_assigned          = true
    user_assigned_resource_ids = ["/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myIdentity"]
  }
  memory_mb                  = 8192
  nic_tags                   = { environment = "production", role = "network-interface" }
  no_proxy                   = ["localhost", "127.0.0.1"]
  os_type                    = "Windows"
  private_ip_address         = "10.0.0.4"
  private_ip_address_version = "IPv4"
  processor_count            = 4
  public_ip_address_id       = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/myResourceGroup/providers/Microsoft.Network/publicIPAddresses/myPublicIP"
  public_ip_address_tags     = { environment = "production", role = "public-ip" }
  require_guest_provision_signal = true
  secure_boot_enabled        = true
  storage_account_tags       = { environment = "production", role = "storage-account" }
  tags                       = { environment = "production", owner = "admin" }
  time_zone                  = "Pacific Standard Time"
  use_custom_location        = true
  vm_size                    = "Standard_D2s_v3"
  vnet_id                    = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myVNet"
  vnet_subnet_id             = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myVNet/subnets/mySubnet"
  windows_boot_diagnostics_enabled = true
  windows_configuration = {
    enableAutomaticUpdates = true
    provisionVmAgent       = true
    timeZone               = "Pacific Standard Time"
  }
}

load_balancer_config = {
  location              = "East US"
  name                  = "my-load-balancer"
  resource_group_name   = "my-resource-group"
  edge_zone             = null
  sku                   = "Standard"
  sku_tier              = "Regional"
  tags                  = { environment = "production", team = "devops" }
  frontend_ip_configurations = {
    frontend1 = {
      name                                      = "frontend-ip-config-1"
      frontend_private_ip_address               = "10.0.0.4"
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
      name                       = "backend-pool-1"
      virtual_network_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet"
      tunnel_interfaces          = {
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
      name                              = "lb-rule-1"
      frontend_ip_configuration_name    = "frontend-ip-config-1"
      protocol                          = "Tcp"
      frontend_port                     = 80
      backend_port                      = 80
      backend_address_pool_object_names = ["backend-pool-1"]
      probe_object_name                 = "probe-1"
      enable_floating_ip                = false
      idle_timeout_in_minutes           = 5
      load_distribution                 = "SourceIP"
    }
  }
  lb_probes = {
    probe1 = {
      name                = "probe-1"
      protocol            = "Http"
      port                = 80
      interval_in_seconds = 10
      probe_threshold     = 2
      request_path        = "/health"
    }
  }
  inbound_nat_rules = {
    nat1 = {
      name                           = "nat-rule-1"
      frontend_ip_configuration_name = "frontend-ip-config-1"
      protocol                       = "Tcp"
      frontend_port                  = 22
      backend_port                   = 22
      enable_floating_ip             = false
      idle_timeout_in_minutes        = 4
    }
  }
  outbound_rules = {
    outbound1 = {
      name                              = "outbound-rule-1"
      frontend_ip_configuration_name    = "frontend-ip-config-1"
      backend_address_pool_object_names = ["backend-pool-1"]
      protocol                          = "All"
      idle_timeout_in_minutes           = 4
      allocated_outbound_ports          = 1024
    }
  }
}

storage_account_config = {
  account_replication_type          = "LRS"
  account_tier                      = "Standard"
  location                          = "East US"
  name                              = "mystorageaccount123"
  resource_group_name               = "my-resource-group"
  access_tier                       = "Hot"
  account_kind                      = "StorageV2"
  allow_nested_items_to_be_public   = true
  allowed_copy_scope                = "Azure"
  cross_tenant_replication_enabled  = true
  default_to_oauth_authentication   = true
  edge_zone                         = "edge-zone-1"
  https_traffic_only_enabled        = true
  infrastructure_encryption_enabled = true
  is_hns_enabled                    = true
  large_file_share_enabled          = true
  min_tls_version                   = "TLS1_2"
  nfsv3_enabled                     = true
  public_network_access_enabled     = false
  queue_encryption_key_type         = "Account"
  sftp_enabled                      = true
  shared_access_key_enabled         = false
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
    default_service_version       = "2020-06-12"
    last_access_time_enabled      = true
    versioning_enabled            = true
    delete_retention_policy = {
      days = 30
    }
  }
  container_delete_retention_policy = {
    days = 15
  }
  cors_rules = [
    {
      allowed_headers    = ["x-ms-meta-*", "x-ms-blob-type"]
      allowed_methods    = ["GET", "POST", "PUT"]
      allowed_origins    = ["https://example.com", "https://anotherexample.com"]
      exposed_headers    = ["x-ms-meta-*", "x-ms-request-id"]
      max_age_in_seconds = 3600
    }
  ]
  delete_retention_policy = {
    days = 14
  }
  immutability_policy = {
    state  = "Locked"
    period = 90
  }
}

sql_server_config = {
  location                                     = "East US"
  name                                         = "my-sql-server"
  resource_group_name                          = "my-resource-group"
  server_version                               = "14.0"
  administrator_login                          = "adminuser"
  administrator_login_password                 = "P@ssw0rd123!"
  connection_policy                            = "Redirect"
  express_vulnerability_assessment_enabled     = true
  outbound_network_restriction_enabled         = true
  primary_user_assigned_identity_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.ManagedIdentity/userAssignedIdentities/my-identity"
  public_network_access_enabled                = false
  tags                                         = {
    environment = "production"
    team        = "devops"
  }
  transparent_data_encryption_key_vault_key_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.KeyVault/vaults/my-keyvault/keys/my-key"

  azuread_administrator = {
    login_username              = "aadadminuser"
    object_id                   = "00000000-0000-0000-0000-000000000000"
    azuread_authentication_only = true
    tenant_id                   = "11111111-1111-1111-1111-111111111111"
  }

  identity = {
    type                       = "SystemAssigned,UserAssigned"
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
      principal_id                           = "22222222-2222-2222-2222-222222222222"
      description                            = "Role assignment for SQL Server management"
      skip_service_principal_aad_check       = true
      condition                              = "resource.type == 'Microsoft.Sql/servers'"
      condition_version                      = "2.0"
      delegated_managed_identity_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.ManagedIdentity/userAssignedIdentities/delegated-identity"
    }
    "role2" = {
      role_definition_id_or_name             = "Reader"
      principal_id                           = "33333333-3333-3333-3333-333333333333"
    }
  }

  diagnostic_settings = {
    "diag1" = {
      name                          = "sql-server-diagnostics"
      log_categories                = ["SQLSecurityAuditEvents", "SQLInsights"]
      log_groups                    = ["allLogs"]
      metric_categories             = ["AllMetrics"]
      log_analytics_destination_type = "Dedicated"
      workspace_resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-log-analytics"
      storage_account_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Storage/storageAccounts/mystorageaccount"
      event_hub_authorization_rule_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.EventHub/namespaces/myeventhubnamespace/authorizationRules/myauthrule"
      event_hub_name                = "myeventhub"
    }
  }
}

private_dns_zone_config = {
  domain_name         = "example.private"
  resource_group_name = "example-resource-group"
  tags = {
    environment = "production"
    owner       = "team-example"
  }
  soa_record = {
    email        = "admin@example.private"
    expire_time  = 2592000
    minimum_ttl  = 15
    refresh_time = 7200
    retry_time   = 600
    ttl          = 3600
    tags = {
      managed_by = "terraform"
    }
  }
  virtual_network_links = {
    vnet-link-1 = {
      vnetlinkname     = "vnet-link-1"
      vnetid           = "/subscriptions/12345678-1234-1234-1234-123456789abc/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/example-vnet"
      autoregistration = true
      tags = {
        purpose = "link-to-vnet"
      }
    }
  }
  a_records = {
    record1 = {
      name                = "record1"
      resource_group_name = "example-resource-group"
      zone_name           = "example.private"
      ttl                 = 3600
      records             = ["10.0.0.1", "10.0.0.2"]
      tags = {
        type = "A-record"
      }
    }
  }
  aaaa_records = {
    record1 = {
      name                = "record1"
      resource_group_name = "example-resource-group"
      zone_name           = "example.private"
      ttl                 = 3600
      records             = ["2001:0db8:85a3:0000:0000:8a2e:0370:7334"]
      tags = {
        type = "AAAA-record"
      }
    }
  }
  cname_records = {
    record1 = {
      name                = "record1"
      resource_group_name = "example-resource-group"
      zone_name           = "example.private"
      ttl                 = 3600
      record              = "alias.example.private"
      tags = {
        type = "CNAME-record"
      }
    }
  }
  mx_records = {
    record1 = {
      name                = "mail"
      resource_group_name = "example-resource-group"
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
        type = "MX-record"
      }
    }
  }
  txt_records = {
    record1 = {
      name                = "record1"
      resource_group_name = "example-resource-group"
      zone_name           = "example.private"
      ttl                 = 3600
      records             = ["v=spf1 include:example.com ~all"]
      tags = {
        type = "TXT-record"
      }
    }
  }
  srv_records = {
    record1 = {
      name                = "_sip._tcp"
      resource_group_name = "example-resource-group"
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
        type = "SRV-record"
      }
    }
  }
  ptr_records = {
    record1 = {
      name                = "1.0.0.10.in-addr.arpa"
      resource_group_name = "example-resource-group"
      zone_name           = "example.private"
      ttl                 = 3600
      records             = ["example.private"]
      tags = {
        type = "PTR-record"
      }
    }
  }
  caa_records = {
    record1 = {
      name                = "record1"
      resource_group_name = "example-resource-group"
      zone_name           = "example.private"
      ttl                 = 3600
      records = [
        {
          flags = 0
          tag   = "issue"
          value = "letsencrypt.org"
        }
      ]
      tags = {
        type = "CAA-record"
      }
    }
  }
}