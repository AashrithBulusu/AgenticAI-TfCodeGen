network_security_group_config = {
  location             = "East US"
  name                 = "example-nsg"
  resource_group_name  = "example-resource-group"
  tags                 = { environment = "production", owner = "team-a" }
  timeouts = {
    create = "40m"
    delete = "20m"
    read   = "10m"
    update = "30m"
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
      principal_type                      = "ServicePrincipal"
    }
  }
  diagnostic_settings = {
    "diag1" = {
      name                                = "example-diagnostic"
      log_categories                      = ["NetworkSecurityGroupEvent", "NetworkSecurityGroupRuleCounter"]
      log_groups                          = ["allLogs"]
      metric_categories                   = ["AllMetrics"]
      log_analytics_destination_type      = "AzureDiagnostics"
      workspace_resource_id               = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.OperationalInsights/workspaces/example-workspace"
      storage_account_resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Storage/storageAccounts/examplestorage"
      event_hub_authorization_rule_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.EventHub/namespaces/example-namespace/authorizationRules/example-rule"
      event_hub_name                      = "example-eventhub"
      marketplace_partner_resource_id     = null
    }
    "diag2" = {
      name                                = null
      log_categories                      = []
      log_groups                          = ["allLogs"]
      metric_categories                   = ["AllMetrics"]
      log_analytics_destination_type      = "Dedicated"
      workspace_resource_id               = null
      storage_account_resource_id         = null
      event_hub_authorization_rule_resource_id = null
      event_hub_name                      = null
      marketplace_partner_resource_id     = null
    }
  }
  enable_telemetry = true
}

network_interface_config = {
  location                       = "eastus"
  name                           = "example-nic"
  resource_group_name            = "example-resource-group"
  accelerated_networking_enabled = true
  dns_servers                    = ["8.8.8.8", "8.8.4.4"]
  edge_zone                      = "example-edge-zone"
  internal_dns_name_label        = "example-internal-dns"
  ip_forwarding_enabled          = true
  tags                           = { environment = "production", team = "networking" }
  ip_configurations = {
    ipconfig1 = {
      name                                               = "ipconfig1"
      private_ip_address_allocation                      = "Static"
      gateway_load_balancer_frontend_ip_configuration_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/loadBalancers/example-lb/frontendIPConfigurations/example-frontend"
      primary                                            = true
      private_ip_address                                 = "10.0.0.4"
      private_ip_address_version                         = "IPv4"
      public_ip_address_id                               = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/publicIPAddresses/example-pip"
      subnet_id                                          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/virtualNetworks/example-vnet/subnets/example-subnet"
    }
    ipconfig2 = {
      name                                               = "ipconfig2"
      private_ip_address_allocation                      = "Dynamic"
      gateway_load_balancer_frontend_ip_configuration_id = null
      primary                                            = false
      private_ip_address                                 = null
      private_ip_address_version                         = "IPv6"
      public_ip_address_id                               = null
      subnet_id                                          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/virtualNetworks/example-vnet/subnets/example-subnet"
    }
  }
  load_balancer_backend_address_pool_association = {
    lbpool1 = {
      load_balancer_backend_address_pool_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/loadBalancers/example-lb/backendAddressPools/example-pool"
      ip_configuration_name                 = "ipconfig1"
    }
  }
  application_gateway_backend_address_pool_association = {
    application_gateway_backend_address_pool_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/applicationGateways/example-ag/backendAddressPools/example-ag-pool"
    ip_configuration_name                       = "ipconfig1"
  }
  application_security_group_ids = [
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/applicationSecurityGroups/example-asg1",
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/applicationSecurityGroups/example-asg2"
  ]
  nat_rule_association = {
    natrule1 = {
      nat_rule_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/loadBalancers/example-lb/inboundNatRules/example-nat-rule"
      ip_configuration_name = "ipconfig1"
    }
  }
  network_security_group_ids = [
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/networkSecurityGroups/example-nsg1",
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/networkSecurityGroups/example-nsg2"
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
  custom_location_id          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.ExtendedLocation/customLocations/my-custom-location"
  os_type                     = "Linux"
  admin_username              = "adminuser"
  admin_password              = "P@ssw0rd123!"
  v_cpu_count                 = 4
  memory_mb                   = 16384
  dynamic_memory              = true
  dynamic_memory_min          = 1024
  dynamic_memory_max          = 16384
  dynamic_memory_buffer       = 25
  secure_boot_enabled         = true
  image_id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Compute/images/my-image"
  logical_network_id          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/logicalNetworks/my-logical-network"
  private_ip_address          = "10.0.0.4"
  tags                        = { environment = "production", team = "devops" }
  lock = {
    kind = "CanNotDelete"
    name = "vm-lock"
  }
  role_assignments = {
    "assignment1" = {
      role_definition_id_or_name             = "Contributor"
      principal_id                           = "00000000-0000-0000-0000-000000000001"
      description                            = "Role assignment for VM"
      skip_service_principal_aad_check       = false
      condition                              = null
      condition_version                      = null
      delegated_managed_identity_resource_id = null
      principal_type                         = null
    }
  }
  managed_identities = {
    system_assigned          = true
    user_assigned_resource_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.ManagedIdentity/userAssignedIdentities/my-identity"]
  }
  linux_ssh_config = {
    publicKeys = [
      {
        keyData = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEArandomkeydata"
        path    = "/home/adminuser/.ssh/authorized_keys"
      }
    ]
  }
  windows_ssh_config = null
  domain_to_join           = "mydomain.local"
  domain_join_user_name    = "domainadmin"
  domain_join_password     = "DomainP@ssw0rd!"
  domain_target_ou         = "OU=Servers,DC=mydomain,DC=local"
  domain_join_extension_tags = { key1 = "value1", key2 = "value2" }
  boot_diagnostics = {
    enabled     = true
    storage_uri = "https://mystorageaccount.blob.core.windows.net/"
  }
  availability_set_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Compute/availabilitySets/my-availability-set"
  proximity_placement_group_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Compute/proximityPlacementGroups/my-proximity-group"
  extensions = [
    {
      name                       = "CustomScriptExtension"
      publisher                  = "Microsoft.Compute"
      type                       = "CustomScriptExtension"
      type_handler_version       = "1.10"
      auto_upgrade_minor_version = true
      settings                   = { commandToExecute = "echo Hello World" }
      protected_settings         = {}
    }
  ]
  diagnostics_profile = {
    boot_diagnostics = {
      enabled     = true
      storage_uri = "https://mystorageaccount.blob.core.windows.net/"
    }
  }
  network_interfaces = [
    {
      name    = "my-nic"
      primary = true
      ip_configurations = [
        {
          name                        = "ipconfig1"
          private_ip_address          = "10.0.0.5"
          private_ip_address_version  = "IPv4"
          public_ip_address_id        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/publicIPAddresses/my-public-ip"
          subnet_id                   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-subnet"
          application_security_groups = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/applicationSecurityGroups/my-asg"]
        }
      ]
    }
  ]
  plan = {
    name       = "my-plan"
    publisher  = "my-publisher"
    product    = "my-product"
  }
  license_type             = "Windows_Server"
  priority                 = "Regular"
  eviction_policy          = "Deallocate"
  ultra_ssd_enabled        = true
  zones                    = ["1", "2"]
}

load_balancer_config = {
  name                  = "my-load-balancer"
  location              = "East US"
  resource_group_name   = "my-resource-group"
  sku                   = "Standard"
  sku_tier              = "Regional"
  edge_zone             = null
  tags                  = {
    environment = "production"
    owner       = "team-a"
  }
  frontend_ip_configurations = {
    frontend1 = {
      name                                = "frontend-ip-config-1"
      frontend_private_ip_address         = "10.0.0.5"
      frontend_private_ip_address_allocation = "Static"
      frontend_private_ip_address_version = "IPv4"
      frontend_private_ip_subnet_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-subnet"
      public_ip_address_resource_id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/publicIPAddresses/my-public-ip"
      create_public_ip_address            = false
      zones                               = ["1", "2", "3"]
      tags                                = {
        purpose = "frontend"
      }
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
      name                          = "lb-rule-1"
      frontend_ip_configuration_name = "frontend-ip-config-1"
      protocol                      = "Tcp"
      frontend_port                 = 80
      backend_port                  = 8080
      backend_address_pool_resource_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/loadBalancers/my-load-balancer/backendAddressPools/backend-pool-1"]
      probe_resource_id             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/loadBalancers/my-load-balancer/probes/probe-1"
      enable_floating_ip            = false
      idle_timeout_in_minutes       = 5
      load_distribution             = "SourceIP"
      disable_outbound_snat         = false
      enable_tcp_reset              = true
    }
  }
  probes = {
    probe1 = {
      name                = "probe-1"
      protocol            = "Http"
      port                = 80
      request_path        = "/healthcheck"
      interval_in_seconds = 10
      number_of_probes    = 3
    }
  }
  outbound_rules = {
    outbound1 = {
      name                          = "outbound-rule-1"
      frontend_ip_configuration_name = "frontend-ip-config-1"
      protocol                      = "All"
      idle_timeout_in_minutes       = 4
      allocated_outbound_ports      = 1024
      backend_address_pool_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/loadBalancers/my-load-balancer/backendAddressPools/backend-pool-1"
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
  edge_zone                         = "edgezone1"
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
    team        = "devops"
  }
  azure_files_authentication = {
    directory_type                 = "AD"
    default_share_level_permission = "Full"
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
    default_service_version       = "2020-10-02"
    last_access_time_enabled      = true
    versioning_enabled            = true
    delete_retention_policy = {
      days = 30
    }
    container_delete_retention_policy = {
      days = 15
    }
  }
  queue_properties = {
    logging = {
      delete            = true
      read              = true
      write             = true
      retention_in_days = 7
      version           = "1.0"
    }
    hour_metrics = {
      enabled           = true
      include_apis      = true
      retention_in_days = 7
      version           = "1.0"
    }
    minute_metrics = {
      enabled           = true
      include_apis      = true
      retention_in_days = 7
      version           = "1.0"
    }
  }
  routing = {
    publish_internet_endpoints  = true
    publish_microsoft_endpoints = false
    routing_choice              = "MicrosoftRouting"
  }
}

sql_server_config = {
  location                                     = "East US"
  name                                         = "my-sql-server"
  resource_group_name                          = "my-resource-group"
  server_version                               = "14.0"
  administrator_login                          = "adminuser"
  administrator_login_password                 = "P@ssw0rd123"
  connection_policy                            = "Proxy"
  express_vulnerability_assessment_enabled     = true
  outbound_network_restriction_enabled         = true
  primary_user_assigned_identity_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.ManagedIdentity/userAssignedIdentities/my-identity"
  public_network_access_enabled                = false
  tags                                         = { environment = "production", department = "IT" }
  transparent_data_encryption_key_vault_key_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.KeyVault/vaults/my-keyvault/keys/my-key"

  azuread_administrator = {
    login_username              = "aadadmin@mydomain.com"
    object_id                   = "11111111-1111-1111-1111-111111111111"
    azuread_authentication_only = true
    tenant_id                   = "22222222-2222-2222-2222-222222222222"
  }

  identity = {
    type                      = "SystemAssigned,UserAssigned"
    user_assigned_resource_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.ManagedIdentity/userAssignedIdentities/identity1"]
  }

  lock = {
    kind = "CanNotDelete"
    name = "sql-server-lock"
  }

  role_assignments = {
    "role1" = {
      role_definition_id_or_name             = "Contributor"
      principal_id                           = "33333333-3333-3333-3333-333333333333"
      description                            = "Role assignment for SQL Server"
      skip_service_principal_aad_check       = true
      condition                              = "resource.type == 'Microsoft.Sql/servers'"
      condition_version                      = "2.0"
      delegated_managed_identity_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.ManagedIdentity/userAssignedIdentities/identity2"
      principal_type                         = "ServicePrincipal"
    }
  }

  diagnostic_settings = {
    "diag1" = {
      name                                     = "sql-server-diagnostics"
      log_categories                           = ["SQLSecurityAuditEvents", "SQLInsights"]
      log_groups                               = ["allLogs"]
      metric_categories                        = ["AllMetrics"]
      log_analytics_destination_type           = "AzureMonitor"
      log_analytics_workspace_id               = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-log-analytics"
      storage_account_id                       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Storage/storageAccounts/mystorageaccount"
      eventhub_authorization_rule_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.EventHub/namespaces/myeventhub/authorizationRules/myrule"
      eventhub_name                            = "myeventhub"
    }
  }
}

private_dns_zone_config = {
  domain_name         = "example.com"
  resource_group_name = "example-resource-group"
  tags                = { environment = "production", owner = "team-a" }

  soa_record = {
    email        = "admin@example.com"
    expire_time  = 2592000
    minimum_ttl  = 30
    refresh_time = 7200
    retry_time   = 600
    ttl          = 3600
    tags         = { managed_by = "terraform", priority = "high" }
  }

  virtual_network_links = {
    vnet1 = {
      vnetlinkname    = "vnet-link-1"
      vnetid          = "/subscriptions/12345678/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/vnet1"
      autoregistration = true
      tags            = { environment = "production", region = "eastus" }
    }
    vnet2 = {
      vnetlinkname    = "vnet-link-2"
      vnetid          = "/subscriptions/12345678/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/vnet2"
      autoregistration = false
      tags            = { environment = "staging", region = "westus" }
    }
  }

  a_records = {
    record1 = {
      name                = "www"
      resource_group_name = "example-resource-group"
      zone_name           = "example.com"
      ttl                 = 300
      records             = ["192.168.1.1", "192.168.1.2"]
      tags                = { environment = "production", service = "web" }
    }
  }

  aaaa_records = {
    record1 = {
      name                = "www"
      resource_group_name = "example-resource-group"
      zone_name           = "example.com"
      ttl                 = 300
      records             = ["2001:db8::1", "2001:db8::2"]
      tags                = { environment = "production", service = "web" }
    }
  }

  cname_records = {
    record1 = {
      name                = "alias"
      resource_group_name = "example-resource-group"
      zone_name           = "example.com"
      ttl                 = 300
      record              = "www.example.com"
      tags                = { environment = "production", service = "alias" }
    }
  }

  mx_records = {
    record1 = {
      name                = "@"
      resource_group_name = "example-resource-group"
      zone_name           = "example.com"
      ttl                 = 3600
      records             = {
        mail1 = { preference = 10, exchange = "mail1.example.com" }
        mail2 = { preference = 20, exchange = "mail2.example.com" }
      }
      tags                = { environment = "production", service = "mail" }
    }
  }

  ptr_records = {
    record1 = {
      name                = "1.168.192.in-addr.arpa"
      resource_group_name = "example-resource-group"
      zone_name           = "example.com"
      ttl                 = 300
      records             = ["www.example.com"]
      tags                = { environment = "production", service = "ptr" }
    }
  }

  srv_records = {
    record1 = {
      name                = "_sip._tcp"
      resource_group_name = "example-resource-group"
      zone_name           = "example.com"
      ttl                 = 3600
      records             = [
        { priority = 10, weight = 5, port = 5060, target = "sip1.example.com" },
        { priority = 20, weight = 10, port = 5060, target = "sip2.example.com" }
      ]
      tags                = { environment = "production", service = "sip" }
    }
  }

  txt_records = {
    record1 = {
      name                = "txt-record"
      resource_group_name = "example-resource-group"
      zone_name           = "example.com"
      ttl                 = 3600
      records             = ["v=spf1 include:example.com ~all", "google-site-verification=abc123"]
      tags                = { environment = "production", service = "verification" }
    }
  }
}