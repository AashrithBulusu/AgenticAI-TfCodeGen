network_security_group_config = {
  location            = "eastus"
  name                = "example-nsg"
  resource_group_name = "example-resource-group"
  tags = {
    environment = "production"
    owner       = "team-xyz"
  }
  timeouts = {
    create = "40m"
    delete = "35m"
    read   = "10m"
    update = "45m"
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
      delegated_managed_identity_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.ManagedIdentity/userAssignedIdentities/example-identity"
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
      principal_type                      = null
    }
  }
  diagnostic_settings = {
    "diagnostic1" = {
      name                              = "example-diagnostic"
      log_categories                   = ["NetworkSecurityGroupEvent", "NetworkSecurityGroupRuleCounter"]
      log_groups                       = ["allLogs"]
      metric_categories                = ["AllMetrics"]
      log_analytics_destination_type   = "Dedicated"
      workspace_resource_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.OperationalInsights/workspaces/example-workspace"
      storage_account_resource_id      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.Storage/storageAccounts/examplestorage"
      event_hub_authorization_rule_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.EventHub/namespaces/example-namespace/authorizationRules/example-rule"
      event_hub_name                   = "example-eventhub"
      marketplace_partner_resource_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.Marketplace/resources/example-partner-resource"
    }
    "diagnostic2" = {
      name                              = null
      log_categories                   = []
      log_groups                       = ["allLogs"]
      metric_categories                = ["AllMetrics"]
      log_analytics_destination_type   = "Dedicated"
      workspace_resource_id            = null
      storage_account_resource_id      = null
      event_hub_authorization_rule_resource_id = null
      event_hub_name                   = null
      marketplace_partner_resource_id  = null
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
  internal_dns_name_label        = "example-dns-label"
  ip_forwarding_enabled          = true
  tags                           = {
    environment = "production"
    owner       = "team-example"
  }
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
    kind = "ReadOnly"
    name = "example-lock"
  }
}

azurestackhci_virtual_machine_config = {
  admin_password          = "P@ssw0rd123!"
  admin_username          = "adminuser"
  custom_location_id      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.CustomLocation/customLocations/myCustomLocation"
  image_id                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Compute/galleries/myGallery/images/myImage/versions/1.0.0"
  location                = "eastus"
  logical_network_id      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Network/logicalNetworks/myLogicalNetwork"
  name                    = "myvm01"
  resource_group_name     = "myResourceGroup"
  auto_upgrade_minor_version = true
  data_disk_params = {
    disk1 = {
      name         = "datadisk1"
      diskSizeGB   = 128
      dynamic      = true
      tags         = { environment = "production", team = "devops" }
      containerId  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Storage/storageAccounts/myStorageAccount"
    }
    disk2 = {
      name         = "datadisk2"
      diskSizeGB   = 256
      dynamic      = false
      tags         = { environment = "staging" }
      containerId  = null
    }
  }
  domain_join_extension_tags = { environment = "production", team = "it" }
  domain_join_password       = "DomainP@ssw0rd!"
  domain_join_user_name      = "DOMAIN\\adminuser"
  domain_target_ou           = "OU=Servers,DC=example,DC=com"
  domain_to_join             = "example.com"
  dynamic_memory             = true
  dynamic_memory_buffer      = 25
  dynamic_memory_max         = 16384
  dynamic_memory_min         = 1024
  enable_telemetry           = true
  http_proxy                 = "http://proxy.example.com:8080"
  https_proxy                = "https://proxy.example.com:8443"
  linux_ssh_config = {
    publicKeys = [
      {
        keyData = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEArandomkeydata"
        path    = "/home/adminuser/.ssh/authorized_keys"
      },
      {
        keyData = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAdifferentkeydata"
        path    = "/home/adminuser/.ssh/another_authorized_keys"
      }
    ]
  }
  lock = {
    kind = "ReadOnly"
    name = "vm-lock"
  }
  managed_identities = {
    system_assigned           = true
    user_assigned_resource_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myIdentity"]
  }
  memory_mb           = 16384
  nic_tags            = { environment = "production", team = "network" }
  no_proxy            = ["localhost", "127.0.0.1", "example.com"]
  os_type             = "Windows"
  private_ip_address  = "10.0.0.4"
  role_assignments = {
    role1 = {
      role_definition_id_or_name      = "Contributor"
      principal_id                    = "00000000-0000-0000-0000-000000000001"
      description                     = "Role assignment for VM management"
      skip_service_principal_aad_check = false
      condition                       = null
      condition_version               = null
      delegated_managed_identity_resource_id = null
    }
    role2 = {
      role_definition_id_or_name      = "Reader"
      principal_id                    = "00000000-0000-0000-0000-000000000002"
      description                     = "Read-only access"
      skip_service_principal_aad_check = true
      condition                       = "resource.type == 'Microsoft.Compute/virtualMachines'"
      condition_version               = "1.0"
      delegated_managed_identity_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myDelegatedIdentity"
    }
  }
  tags = { environment = "production", project = "azurestackhci" }
  time_zone = "Pacific Standard Time"
  vm_size   = "Standard_D4s_v3"
  vnet_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myVnet"
  windows_configuration = {
    enable_automatic_updates = true
    provision_vm_agent       = true
    timezone                 = "Pacific Standard Time"
  }
}

load_balancer_config = {
  location                  = "East US"
  name                      = "my-load-balancer"
  resource_group_name       = "my-resource-group"
  edge_zone                 = "edge-zone-1"
  sku                       = "Standard"
  sku_tier                  = "Regional"
  tags                      = { environment = "production", owner = "team-xyz" }
  frontend_ip_configurations = {
    frontend1 = {
      name                                      = "frontend-config-1"
      frontend_private_ip_address               = "10.0.0.4"
      frontend_private_ip_address_allocation    = "Static"
      frontend_private_ip_address_version       = "IPv4"
      frontend_private_ip_subnet_resource_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-subnet"
      gateway_load_balancer_frontend_ip_configuration_id = null
      public_ip_address_id                      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/publicIPAddresses/my-public-ip"
      zones                                     = ["1", "2"]
    }
  }
  backend_address_pools = {
    backend1 = {
      name                       = "backend-pool-1"
      virtual_network_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet"
      tunnel_interfaces = {
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
      frontend_ip_configuration_name    = "frontend-config-1"
      protocol                          = "Tcp"
      frontend_port                     = 80
      backend_port                      = 80
      backend_address_pool_resource_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/loadBalancers/my-load-balancer/backendAddressPools/backend-pool-1"]
      probe_id                          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/loadBalancers/my-load-balancer/probes/probe-1"
      enable_floating_ip                = false
      idle_timeout_in_minutes           = 5
      load_distribution                 = "Default"
    }
  }
  probes = {
    probe1 = {
      name                 = "probe-1"
      protocol             = "Http"
      port                 = 80
      interval_in_seconds  = 10
      number_of_probes     = 3
      request_path         = "/health"
    }
  }
  outbound_rules = {
    outbound1 = {
      name                              = "outbound-rule-1"
      frontend_ip_configuration_name    = "frontend-config-1"
      protocol                          = "Udp"
      allocated_outbound_ports          = 1024
      idle_timeout_in_minutes           = 10
      backend_address_pool_resource_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/loadBalancers/my-load-balancer/backendAddressPools/backend-pool-1"]
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
    directory_type                 = "AD"
    default_share_level_permission = "Full"
    active_directory = {
      domain_guid         = "12345678-1234-1234-1234-123456789012"
      domain_name         = "example.com"
      domain_sid          = "S-1-5-21-1234567890-1234567890-1234567890"
      forest_name         = "exampleforest.com"
      netbios_domain_name = "EXAMPLE"
      storage_sid         = "S-1-5-21-0987654321-0987654321-0987654321"
    }
  }
  blob_properties = {
    change_feed_enabled           = true
    change_feed_retention_in_days = 30
    default_service_version       = "2021-08-06"
    last_access_time_enabled      = true
    versioning_enabled            = true
    delete_retention_policy = {
      days = 90
    }
    container_delete_retention_policy = {
      days = 30
    }
  }
  identity = {
    type       = "SystemAssigned,UserAssigned"
    identities = ["12345678-1234-1234-1234-123456789012", "87654321-4321-4321-4321-210987654321"]
  }
  network_rules = {
    bypass                     = ["AzureServices", "Logging"]
    default_action             = "Allow"
    ip_rules                   = ["192.168.1.1", "10.0.0.1"]
    virtual_network_subnet_ids = ["/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-subnet"]
  }
}

sql_server_config = {
  location                                     = "East US"
  name                                         = "my-sql-server"
  resource_group_name                          = "my-resource-group"
  server_version                               = "14.0"
  administrator_login                          = "adminuser"
  administrator_login_password                 = "P@ssw0rd123!"
  connection_policy                            = "Proxy"
  express_vulnerability_assessment_enabled     = true
  outbound_network_restriction_enabled         = true
  primary_user_assigned_identity_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.ManagedIdentity/userAssignedIdentities/my-identity"
  public_network_access_enabled                = false
  tags                                         = {
    environment = "production"
    owner       = "team-a"
  }
  transparent_data_encryption_key_vault_key_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.KeyVault/vaults/my-keyvault/keys/my-key"

  azuread_administrator = {
    login_username              = "aadadmin@mydomain.com"
    object_id                   = "11111111-1111-1111-1111-111111111111"
    azuread_authentication_only = true
    tenant_id                   = "22222222-2222-2222-2222-222222222222"
  }

  identity = {
    type                       = "UserAssigned"
    user_assigned_resource_ids = [
      "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.ManagedIdentity/userAssignedIdentities/identity1",
      "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.ManagedIdentity/userAssignedIdentities/identity2"
    ]
  }

  lock = {
    kind = "ReadOnly"
    name = "sql-server-lock"
  }

  role_assignments = {
    "role1" = {
      role_definition_id_or_name             = "Contributor"
      principal_id                           = "33333333-3333-3333-3333-333333333333"
      description                            = "Role assignment for Contributor"
      skip_service_principal_aad_check       = true
      condition                              = "resourceGroup().name == 'my-resource-group'"
      condition_version                      = "1.0"
      delegated_managed_identity_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.ManagedIdentity/userAssignedIdentities/identity1"
      principal_type                         = "User"
    }
    "role2" = {
      role_definition_id_or_name             = "Reader"
      principal_id                           = "44444444-4444-4444-4444-444444444444"
      description                            = "Role assignment for Reader"
      skip_service_principal_aad_check       = false
      condition                              = null
      condition_version                      = null
      delegated_managed_identity_resource_id = null
      principal_type                         = "Group"
    }
  }

  diagnostic_settings = {
    "diag1" = {
      name                                     = "sql-server-diagnostics"
      log_categories                           = ["SQLSecurityAuditEvents", "SQLInsights"]
      log_groups                               = ["allLogs"]
      metric_categories                        = ["AllMetrics"]
      log_analytics_destination_type           = "Dedicated"
      workspace_resource_id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace"
      storage_account_id                       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Storage/storageAccounts/mystorageaccount"
      event_hub_authorization_rule_id          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.EventHub/namespaces/mynamespace/authorizationRules/myrule"
      event_hub_name                           = "myeventhub"
      retention_policy_enabled                 = true
      retention_policy_days                    = 30
    }
    "diag2" = {
      name                                     = "sql-server-diagnostics-2"
      log_categories                           = ["SQLSecurityAuditEvents"]
      log_groups                               = ["allLogs"]
      metric_categories                        = ["AllMetrics"]
      log_analytics_destination_type           = "AzureDiagnostics"
      workspace_resource_id                    = null
      storage_account_id                       = null
      event_hub_authorization_rule_id          = null
      event_hub_name                           = null
      retention_policy_enabled                 = false
      retention_policy_days                    = null
    }
  }
}