network_security_group_config = {
  location            = "eastus"
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
    update = "30m"
  }
  lock = {
    kind = "CanNotDelete"
    name = "example-lock"
  }
  role_assignments = {
    "assignment1" = {
      role_definition_id_or_name          = "Contributor"
      principal_id                        = "00000000-0000-0000-0000-000000000000"
      description                         = "Role assignment for Contributor"
      skip_service_principal_aad_check    = true
      condition                           = "resource.location == 'eastus'"
      condition_version                   = "2.0"
      delegated_managed_identity_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/example-identity"
      principal_type                      = "User"
    }
    "assignment2" = {
      role_definition_id_or_name          = "Reader"
      principal_id                        = "11111111-1111-1111-1111-111111111111"
      description                         = null
      skip_service_principal_aad_check    = false
      condition                           = null
      condition_version                   = null
      delegated_managed_identity_resource_id = null
      principal_type                      = "ServicePrincipal"
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
      storage_account_resource_id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Storage/storageAccounts/exampleaccount"
      event_hub_authorization_rule_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.EventHub/namespaces/example-namespace/authorizationRules/example-rule"
      event_hub_name                    = "example-eventhub"
      marketplace_partner_resource_id   = null
    }
    "diagnostic2" = {
      name                              = null
      log_categories                    = []
      log_groups                        = ["allLogs"]
      metric_categories                 = ["AllMetrics"]
      log_analytics_destination_type    = "Dedicated"
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
  name                              = "my-network-interface"
  resource_group_name               = "my-resource-group"
  accelerated_networking_enabled    = true
  dns_servers                       = ["8.8.8.8", "8.8.4.4"]
  edge_zone                         = "edge-zone-1"
  internal_dns_name_label           = "internal-dns-label"
  ip_forwarding_enabled             = true
  tags                              = {
    environment = "production"
    owner       = "team-network"
  }
  ip_configurations = {
    ipconfig1 = {
      name                                     = "ipconfig1"
      private_ip_address_allocation            = "Static"
      private_ip_address                       = "10.0.0.4"
      private_ip_address_version               = "IPv4"
      public_ip_address_id                     = "/subscriptions/12345678/resourceGroups/my-resource-group/providers/Microsoft.Network/publicIPAddresses/my-public-ip"
      subnet_id                                = "/subscriptions/12345678/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-subnet"
      gateway_load_balancer_frontend_ip_configuration_id = "/subscriptions/12345678/resourceGroups/my-resource-group/providers/Microsoft.Network/loadBalancers/my-load-balancer/frontendIPConfigurations/my-frontend-ip"
      primary                                  = true
    }
    ipconfig2 = {
      name                                     = "ipconfig2"
      private_ip_address_allocation            = "Dynamic"
      private_ip_address                       = null
      private_ip_address_version               = "IPv6"
      public_ip_address_id                     = null
      subnet_id                                = "/subscriptions/12345678/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-subnet"
      gateway_load_balancer_frontend_ip_configuration_id = null
      primary                                  = false
    }
  }
  load_balancer_backend_address_pool_association = {
    lbpool1 = {
      load_balancer_backend_address_pool_id = "/subscriptions/12345678/resourceGroups/my-resource-group/providers/Microsoft.Network/loadBalancers/my-load-balancer/backendAddressPools/my-backend-pool"
      ip_configuration_name                 = "ipconfig1"
    }
    lbpool2 = {
      load_balancer_backend_address_pool_id = "/subscriptions/12345678/resourceGroups/my-resource-group/providers/Microsoft.Network/loadBalancers/my-load-balancer/backendAddressPools/another-backend-pool"
      ip_configuration_name                 = "ipconfig2"
    }
  }
  application_gateway_backend_address_pool_association = {
    application_gateway_backend_address_pool_id = "/subscriptions/12345678/resourceGroups/my-resource-group/providers/Microsoft.Network/applicationGateways/my-app-gateway/backendAddressPools/my-app-backend-pool"
    ip_configuration_name                        = "ipconfig1"
  }
  application_security_group_ids = [
    "/subscriptions/12345678/resourceGroups/my-resource-group/providers/Microsoft.Network/applicationSecurityGroups/my-app-security-group"
  ]
  network_security_group_ids = [
    "/subscriptions/12345678/resourceGroups/my-resource-group/providers/Microsoft.Network/networkSecurityGroups/my-nsg"
  ]
  nat_rule_association = {
    natrule1 = {
      nat_rule_id           = "/subscriptions/12345678/resourceGroups/my-resource-group/providers/Microsoft.Network/loadBalancers/my-load-balancer/inboundNatRules/my-nat-rule"
      ip_configuration_name = "ipconfig1"
    }
  }
  lock = {
    kind = "CanNotDelete"
    name = "my-lock"
  }
}

azurestackhci_virtual_machine_config = {
  admin_password        = "P@ssw0rd123!"
  admin_username        = "adminuser"
  custom_location_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.ExtendedLocation/customLocations/myCustomLocation"
  image_id              = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Compute/galleries/myGallery/images/myImage/versions/1.0.0"
  location              = "eastus"
  logical_network_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Network/logicalNetworks/myLogicalNetwork"
  name                  = "myVirtualMachine"
  resource_group_name   = "myResourceGroup"
  auto_upgrade_minor_version = true
  data_disk_params = {
    disk1 = {
      name        = "dataDisk1"
      diskSizeGB  = 128
      dynamic     = true
      tags        = { environment = "production", team = "devops" }
      containerId = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Storage/storageAccounts/myStorageAccount"
    }
    disk2 = {
      name        = "dataDisk2"
      diskSizeGB  = 256
      dynamic     = false
      tags        = { environment = "staging" }
    }
  }
  domain_join_extension_tags = { environment = "production", team = "it" }
  domain_join_password       = "DomainP@ssw0rd!"
  domain_join_user_name      = "domain\\adminuser"
  domain_target_ou           = "OU=Servers,DC=domain,DC=com"
  domain_to_join             = "domain.com"
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
      }
    ]
  }
  lock = {
    kind = "CanNotDelete"
    name = "myResourceLock"
  }
  managed_identities = {
    system_assigned          = true
    user_assigned_resource_ids = [
      "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myIdentity"
    ]
  }
  memory_mb = 16384
  nic_tags  = { environment = "production", role = "webserver" }
  os_disk_params = {
    name        = "osDisk"
    diskSizeGB  = 128
    dynamic     = false
    tags        = { environment = "production" }
    containerId = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Storage/storageAccounts/myStorageAccount"
  }
  private_ip_address  = "10.0.0.4"
  proxy_vm_tags       = { environment = "proxy", role = "network" }
  public_ip_address_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Network/publicIPAddresses/myPublicIP"
  size                = "Standard_D4s_v3"
  tags                = { environment = "production", application = "webapp" }
  time_zone           = "Pacific Standard Time"
  vm_extension = {
    name                    = "CustomScriptExtension"
    publisher               = "Microsoft.Compute"
    type                    = "CustomScriptExtension"
    typeHandlerVersion      = "1.10"
    autoUpgradeMinorVersion = true
    settings                = { commandToExecute = "echo Hello World > /tmp/hello.txt" }
    protectedSettings       = { storageAccountName = "myStorageAccount", storageAccountKey = "myStorageKey" }
  }
  vm_tags = { environment = "production", role = "application" }
  windows_config = {
    enableAutomaticUpdates = true
    provisionVmAgent       = true
    timeZone               = "Pacific Standard Time"
  }
}

load_balancer_config = {
  location              = "East US"
  name                  = "my-load-balancer"
  resource_group_name   = "my-resource-group"
  sku                   = "Standard"
  sku_tier              = "Regional"
  edge_zone             = null
  tags                  = { environment = "production", owner = "team-a" }
  frontend_ip_configurations = {
    frontend1 = {
      name                                      = "frontend-config-1"
      frontend_private_ip_address               = "10.0.0.5"
      frontend_private_ip_address_allocation    = "Static"
      frontend_private_ip_address_version       = "IPv4"
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
      name                              = "rule-1"
      frontend_ip_configuration_name    = "frontend-config-1"
      protocol                          = "Tcp"
      frontend_port                     = 80
      backend_port                      = 8080
      backend_address_pool_resource_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/loadBalancers/my-load-balancer/backendAddressPools/backend-pool-1"]
      enable_floating_ip                = false
      idle_timeout_in_minutes           = 5
      load_distribution                 = "Default"
    }
  }
  lb_probes = {
    probe1 = {
      name                = "probe-1"
      protocol            = "Http"
      port                = 80
      interval_in_seconds = 10
      probe_threshold     = 2
      request_path        = "/healthcheck"
    }
  }
  inbound_nat_rules = {
    nat1 = {
      name                           = "nat-rule-1"
      frontend_ip_configuration_name = "frontend-config-1"
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
      name                              = "outbound-rule-1"
      frontend_ip_configuration_name    = "frontend-config-1"
      protocol                          = "All"
      idle_timeout_in_minutes           = 5
      backend_address_pool_resource_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/loadBalancers/my-load-balancer/backendAddressPools/backend-pool-1"]
    }
  }
}

storage_account_config = {
  account_replication_type          = "LRS"
  account_tier                      = "Standard"
  location                          = "eastus"
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
    default_service_version       = "2020-06-12"
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
      delete           = true
      read             = true
      write            = true
      retention_in_days = 7
    }
    hour_metrics = {
      enabled          = true
      include_apis     = true
      retention_in_days = 7
    }
    minute_metrics = {
      enabled          = true
      include_apis     = true
      retention_in_days = 7
    }
  }
  routing = {
    publish_internet_endpoints  = true
    publish_microsoft_endpoints = true
    choice                      = "MicrosoftRouting"
  }
}

sql_server_config = {
  location                                     = "eastus"
  name                                         = "my-sql-server"
  resource_group_name                          = "my-resource-group"
  server_version                               = "15.0"
  administrator_login                          = "adminuser"
  administrator_login_password                 = "P@ssw0rd123!"
  connection_policy                            = "Default"
  express_vulnerability_assessment_enabled     = true
  outbound_network_restriction_enabled         = false
  primary_user_assigned_identity_id            = null
  public_network_access_enabled                = true
  tags                                         = {
    environment = "production"
    owner       = "team-xyz"
  }
  transparent_data_encryption_key_vault_key_id = null
  azuread_administrator = {
    login_username              = "aadadminuser"
    object_id                   = "00000000-0000-0000-0000-000000000000"
    azuread_authentication_only = false
    tenant_id                   = "11111111-1111-1111-1111-111111111111"
  }
  identity = {
    type                       = "SystemAssigned,UserAssigned"
    user_assigned_resource_ids = [
      "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.ManagedIdentity/userAssignedIdentities/my-identity"
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
      description                            = "Role assignment for SQL Server"
      skip_service_principal_aad_check       = false
      condition                              = null
      condition_version                      = null
      delegated_managed_identity_resource_id = null
      principal_type                         = "User"
    }
    "role2" = {
      role_definition_id_or_name             = "Reader"
      principal_id                           = "33333333-3333-3333-3333-333333333333"
      description                            = null
      skip_service_principal_aad_check       = true
      condition                              = "resourceGroup().name == 'my-resource-group'"
      condition_version                      = "2.0"
      delegated_managed_identity_resource_id = null
      principal_type                         = "Group"
    }
  }
  diagnostic_settings = {
    "diag1" = {
      name                                     = "sql-server-diagnostics"
      log_categories                           = ["SQLInsights", "Security"]
      log_groups                               = ["allLogs"]
      metric_categories                        = ["AllMetrics"]
      log_analytics_destination_type           = "Dedicated"
      workspace_resource_id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-log-analytics"
      storage_account_resource_id              = null
      event_hub_authorization_rule_resource_id = null
      event_hub_name                           = null
    }
    "diag2" = {
      name                                     = "sql-server-diagnostics-2"
      log_categories                           = ["SQLInsights"]
      log_groups                               = ["allLogs"]
      metric_categories                        = ["AllMetrics"]
      log_analytics_destination_type           = "AzureDiagnostics"
      workspace_resource_id                    = null
      storage_account_resource_id              = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Storage/storageAccounts/mystorageaccount"
      event_hub_authorization_rule_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.EventHub/namespaces/myeventhubnamespace/authorizationRules/myauthrule"
      event_hub_name                           = "myeventhub"
    }
  }
}