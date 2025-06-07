network_security_group_config = {
  location            = "eastus"
  name                = "example-nsg"
  resource_group_name = "example-resource-group"
  tags = {
    environment = "production"
    owner       = "team-a"
  }
  timeouts = {
    create = "30m"
    delete = "30m"
    read   = "5m"
    update = "30m"
  }
  lock = {
    kind = "CanNotDelete"
    name = "example-lock"
  }
  role_assignments = {
    "assignment1" = {
      role_definition_id_or_name             = "Contributor"
      principal_id                           = "00000000-0000-0000-0000-000000000001"
      description                            = "Role assignment for Contributor"
      skip_service_principal_aad_check       = true
      condition                              = "resource.type == 'Microsoft.Network/networkSecurityGroups'"
      condition_version                      = "2.0"
      delegated_managed_identity_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.ManagedIdentity/userAssignedIdentities/example-identity"
      principal_type                         = "User"
    }
    "assignment2" = {
      role_definition_id_or_name             = "Reader"
      principal_id                           = "00000000-0000-0000-0000-000000000002"
      description                            = null
      skip_service_principal_aad_check       = false
      condition                              = null
      condition_version                      = null
      delegated_managed_identity_resource_id = null
      principal_type                         = "ServicePrincipal"
    }
  }
  diagnostic_settings = {
    "diagnostic1" = {
      name                                     = "example-diagnostic-setting"
      log_categories                           = ["NetworkSecurityGroupEvent", "NetworkSecurityGroupRuleCounter"]
      log_groups                               = ["allLogs"]
      metric_categories                        = ["AllMetrics"]
      log_analytics_destination_type           = "Dedicated"
      workspace_resource_id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.OperationalInsights/workspaces/example-workspace"
      storage_account_resource_id              = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.Storage/storageAccounts/examplestorage"
      event_hub_authorization_rule_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.EventHub/namespaces/example-namespace/authorizationRules/example-rule"
      event_hub_name                           = "example-event-hub"
      marketplace_partner_resource_id          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.MarketplacePartner/example-partner"
    }
    "diagnostic2" = {
      name                                     = null
      log_categories                           = []
      log_groups                               = ["allLogs"]
      metric_categories                        = ["AllMetrics"]
      log_analytics_destination_type           = "Dedicated"
      workspace_resource_id                    = null
      storage_account_resource_id              = null
      event_hub_authorization_rule_resource_id = null
      event_hub_name                           = null
      marketplace_partner_resource_id          = null
    }
  }
}

network_interface_config = {
  location                                      = "eastus"
  name                                          = "example-nic"
  resource_group_name                           = "example-rg"
  accelerated_networking_enabled                = true
  dns_servers                                   = ["8.8.8.8", "8.8.4.4"]
  edge_zone                                     = "example-edge-zone"
  internal_dns_name_label                       = "example-dns-label"
  ip_forwarding_enabled                         = true
  tags                                          = { environment = "production", team = "networking" }
  ip_configurations                             = {
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
      private_ip_address_version                         = "IPv4"
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
  network_security_group_ids = [
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/networkSecurityGroups/example-nsg1",
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/networkSecurityGroups/example-nsg2"
  ]
  nat_rule_association = {
    natrule1 = {
      nat_rule_id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/loadBalancers/example-lb/inboundNatRules/example-nat-rule"
      ip_configuration_name = "ipconfig1"
    }
  }
  lock = {
    kind = "CanNotDelete"
    name = "example-lock"
  }
}

virtual_machine_config = {
  admin_password           = "P@ssw0rd123!"
  admin_username           = "adminuser"
  auto_upgrade_minor_version = true
  custom_location_id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.CustomLocation/customLocations/myCustomLocation"
  data_disk_params = {
    disk1 = {
      name        = "datadisk1"
      diskSizeGB  = 128
      dynamic     = true
      tags        = { environment = "production", team = "devops" }
      containerId = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Storage/storageAccounts/mystorageaccount"
    }
    disk2 = {
      name        = "datadisk2"
      diskSizeGB  = 256
      dynamic     = false
      tags        = { environment = "staging" }
      containerId = null
    }
  }
  domain_join_extension_tags = { key1 = "value1", key2 = "value2" }
  domain_join_password       = "DomainP@ssw0rd!"
  domain_join_user_name      = "domainuser"
  domain_target_ou           = "OU=Servers,DC=example,DC=com"
  domain_to_join             = "example.com"
  dynamic_memory             = true
  dynamic_memory_buffer      = 25
  dynamic_memory_max         = 16384
  dynamic_memory_min         = 1024
  enable_telemetry           = true
  http_proxy                 = "http://proxy.example.com:8080"
  https_proxy                = "https://proxy.example.com:8443"
  image_id                   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Compute/images/myCustomImage"
  linux_ssh_config = {
    publicKeys = [
      {
        keyData = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEArandomkeydata"
        path    = "/home/adminuser/.ssh/authorized_keys"
      }
    ]
  }
  location                   = "eastus"
  lock = {
    kind = "CanNotDelete"
    name = "myLockName"
  }
  logical_network_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myVNet"
  managed_identities = {
    system_assigned            = true
    user_assigned_resource_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myIdentity"]
  }
  memory_mb                  = 16384
  name                       = "myVirtualMachine"
  nic_tags                   = { environment = "production", team = "networking" }
  no_proxy                   = ["localhost", "127.0.0.1", "example.com"]
  os_type                    = "Linux"
  private_ip_address         = "10.0.0.4"
  resource_group_name        = "myResourceGroup"
  role_assignments = {
    role1 = {
      role_definition_id_or_name             = "Contributor"
      principal_id                           = "00000000-0000-0000-0000-000000000000"
      description                            = "Role assignment for VM"
      skip_service_principal_aad_check       = false
      condition                              = null
      condition_version                      = null
      delegated_managed_identity_resource_id = null
      principal_type                         = "User"
    }
  }
  secure_boot_enabled        = true
  tags                       = { environment = "production", application = "webapp" }
  trusted_ca                 = "trusted-ca-cert-data"
  type_handler_version       = "1.3"
  user_storage_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Storage/storageAccounts/mystorageaccount"
  v_cpu_count                = 4
  windows_ssh_config = {
    publicKeys = [
      {
        keyData = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEArandomkeydata"
        path    = "C:\\Users\\adminuser\\.ssh\\authorized_keys"
      }
    ]
  }
}

load_balancer_config = {
  location            = "eastus"
  name                = "my-load-balancer"
  resource_group_name = "my-resource-group"
  edge_zone           = null
  sku                 = "Standard"
  sku_tier            = "Regional"
  tags = {
    environment = "production"
    owner       = "team-a"
  }
  frontend_ip_configurations = {
    frontend1 = {
      name                                               = "frontend-config-1"
      frontend_private_ip_address                        = "10.0.0.4"
      frontend_private_ip_address_version                = "IPv4"
      frontend_private_ip_address_allocation             = "Dynamic"
      frontend_private_ip_subnet_resource_id             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-subnet"
      gateway_load_balancer_frontend_ip_configuration_id = null
      public_ip_address_resource_id                      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/publicIPAddresses/my-public-ip"
      create_public_ip_address                           = false
      zones                                              = ["1", "2", "3"]
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
          protocol   = "TCP"
          port       = 443
        }
      }
    }
  }
  backend_address_pool_addresses = {
    address1 = {
      name                             = "address-1"
      backend_address_pool_object_name = "backend-pool-1"
      ip_address                       = "10.0.0.5"
      virtual_network_resource_id      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet"
    }
  }
  backend_address_pool_network_interfaces = {
    nic1 = {
      backend_address_pool_object_name = "backend-pool-1"
      ip_configuration_name            = "ipconfig1"
      network_interface_resource_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/networkInterfaces/my-nic"
    }
  }
  lb_probes = {
    probe1 = {
      name                            = "probe-1"
      protocol                        = "Tcp"
      port                            = 80
      interval_in_seconds             = 15
      probe_threshold                 = 1
      request_path                    = "/health"
      number_of_probes_before_removal = 2
    }
  }
  lb_rules = {
    rule1 = {
      name                              = "rule-1"
      frontend_ip_configuration_name    = "frontend-config-1"
      protocol                          = "Tcp"
      frontend_port                     = 3389
      backend_port                      = 3389
      backend_address_pool_resource_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/loadBalancers/my-load-balancer/backendAddressPools/backend-pool-1"]
      backend_address_pool_object_names = ["backend-pool-1"]
      probe_resource_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/loadBalancers/my-load-balancer/probes/probe-1"
      probe_object_name                 = "probe-1"
      enable_floating_ip                = false
      idle_timeout_in_minutes           = 4
      load_distribution                 = "Default"
      disable_outbound_snat             = false
      enable_tcp_reset                  = false
    }
  }
  lb_nat_rules = {
    nat1 = {
      name                             = "nat-rule-1"
      frontend_ip_configuration_name   = "frontend-config-1"
      protocol                         = "Tcp"
      frontend_port                    = 22
      backend_port                     = 22
      frontend_port_start              = null
      frontend_port_end                = null
      backend_address_pool_resource_id = null
      backend_address_pool_object_name = null
      idle_timeout_in_minutes          = 4
      enable_floating_ip               = false
      enable_tcp_reset                 = false
    }
  }
  lb_outbound_rules = {
    outbound1 = {
      name                               = "outbound-rule-1"
      frontend_ip_configurations         = [{ name = "frontend-config-1" }]
      backend_address_pool_resource_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/loadBalancers/my-load-balancer/backendAddressPools/backend-pool-1"
      backend_address_pool_object_name   = "backend-pool-1"
      protocol                           = "Tcp"
      enable_tcp_reset                   = false
      number_of_allocated_outbound_ports = 1024
      idle_timeout_in_minutes            = 4
    }
  }
  lb_nat_pools = {
    natpool1 = {
      name                           = "nat-pool-1"
      frontend_ip_configuration_name = "frontend-config-1"
      protocol                       = "Tcp"
      frontend_port_start            = 3000
      frontend_port_end              = 3389
      backend_port                   = 3389
      idle_timeout_in_minutes        = 4
      enable_floating_ip             = false
      enable_tcp_reset               = false
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
  edge_zone                         = "edgezone1"
  https_traffic_only_enabled        = true
  infrastructure_encryption_enabled = true
  is_hns_enabled                    = true
  large_file_share_enabled          = true
  min_tls_version                   = "TLS1_2"
  nfsv3_enabled                     = true
  public_network_access_enabled     = true
  queue_encryption_key_type         = "Service"
  sftp_enabled                      = true
  shared_access_key_enabled         = true
  table_encryption_key_type         = "Account"
  tags                              = {
    environment = "production"
    owner       = "team-a"
  }
}

sql_server_config = {
  location                                     = "East US"
  name                                         = "my-sql-server"
  resource_group_name                          = "my-resource-group"
  server_version                               = "12.0"
  administrator_login                          = "adminuser"
  administrator_login_password                 = "P@ssw0rd123!"
  connection_policy                            = "Default"
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
    login_username              = "aadadmin@mydomain.com"
    object_id                   = "11111111-1111-1111-1111-111111111111"
    azuread_authentication_only = true
    tenant_id                   = "22222222-2222-2222-2222-222222222222"
  }

  lock = {
    kind = "CanNotDelete"
    name = "sql-server-lock"
  }

  role_assignments = {
    role1 = {
      role_definition_id_or_name             = "Contributor"
      principal_id                           = "33333333-3333-3333-3333-333333333333"
      description                            = "Role assignment for SQL Server management"
      skip_service_principal_aad_check       = false
      condition                              = "resource.location == 'East US'"
      condition_version                      = "1.0"
      delegated_managed_identity_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.ManagedIdentity/userAssignedIdentities/my-identity"
      principal_type                         = "User"
    }
    role2 = {
      role_definition_id_or_name             = "Reader"
      principal_id                           = "44444444-4444-4444-4444-444444444444"
      description                            = null
      skip_service_principal_aad_check       = true
      condition                              = null
      condition_version                      = null
      delegated_managed_identity_resource_id = null
      principal_type                         = null
    }
  }

  diagnostic_settings = {
    diag1 = {
      name                                     = "sql-server-diagnostics"
      log_categories                           = ["SQLInsights", "AutomaticTuning"]
      log_groups                               = ["allLogs"]
      metric_categories                        = ["AllMetrics"]
      log_analytics_destination_type           = "Dedicated"
      workspace_resource_id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace"
      storage_account_resource_id              = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Storage/storageAccounts/mystorageaccount"
      event_hub_authorization_rule_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.EventHub/namespaces/mynamespace/authorizationRules/myrule"
      event_hub_name                           = "myeventhub"
      marketplace_partner_resource_id          = null
    }
    diag2 = {
      name                                     = null
      log_categories                           = []
      log_groups                               = ["allLogs"]
      metric_categories                        = ["AllMetrics"]
      log_analytics_destination_type           = "Dedicated"
      workspace_resource_id                    = null
      storage_account_resource_id              = null
      event_hub_authorization_rule_resource_id = null
      event_hub_name                           = null
      marketplace_partner_resource_id          = null
    }
  }
}

private_dns_zone_config = {
  domain_name         = "example.com"
  resource_group_name = "example-resource-group"
  tags = {
    environment = "production"
    owner       = "team@example.com"
  }
  soa_record = {
    email        = "admin@example.com"
    expire_time  = 2419200
    minimum_ttl  = 10
    refresh_time = 3600
    retry_time   = 300
    ttl          = 3600
    tags = {
      record_type = "SOA"
    }
  }
  timeouts = {
    dns_zones = {
      create = "30m"
      delete = "30m"
      update = "30m"
      read   = "5m"
    }
    vnet_links = {
      create = "30m"
      delete = "30m"
      update = "30m"
      read   = "5m"
    }
  }
  virtual_network_links = {
    link1 = {
      vnetlinkname     = "vnet-link-1"
      vnetid           = "/subscriptions/12345/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/vnet1"
      autoregistration = true
      tags = {
        link_type = "primary"
      }
    }
  }
  a_records = {
    record1 = {
      name                = "www"
      resource_group_name = "example-resource-group"
      zone_name           = "example.com"
      ttl                 = 3600
      records             = ["192.168.1.1", "192.168.1.2"]
      tags = {
        record_type = "A"
      }
    }
  }
  aaaa_records = {
    record1 = {
      name                = "www"
      resource_group_name = "example-resource-group"
      zone_name           = "example.com"
      ttl                 = 3600
      records             = ["2001:0db8:85a3:0000:0000:8a2e:0370:7334"]
      tags = {
        record_type = "AAAA"
      }
    }
  }
  cname_records = {
    record1 = {
      name                = "alias"
      resource_group_name = "example-resource-group"
      zone_name           = "example.com"
      ttl                 = 3600
      record              = "www.example.com"
      tags = {
        record_type = "CNAME"
      }
    }
  }
  mx_records = {
    record1 = {
      name                = "@"
      resource_group_name = "example-resource-group"
      zone_name           = "example.com"
      ttl                 = 3600
      records = {
        mail1 = {
          preference = 10
          exchange   = "mail1.example.com"
        }
        mail2 = {
          preference = 20
          exchange   = "mail2.example.com"
        }
      }
      tags = {
        record_type = "MX"
      }
    }
  }
  ptr_records = {
    record1 = {
      name                = "1.1.168.192.in-addr.arpa"
      resource_group_name = "example-resource-group"
      zone_name           = "example.com"
      ttl                 = 3600
      records             = ["example.com"]
      tags = {
        record_type = "PTR"
      }
    }
  }
  srv_records = {
    record1 = {
      name                = "_sip._tcp"
      resource_group_name = "example-resource-group"
      zone_name           = "example.com"
      ttl                 = 3600
      records = {
        service1 = {
          priority = 10
          weight   = 5
          port     = 5060
          target   = "sip.example.com"
        }
      }
      tags = {
        record_type = "SRV"
      }
    }
  }
  txt_records = {
    record1 = {
      name                = "txt-record"
      resource_group_name = "example-resource-group"
      zone_name           = "example.com"
      ttl                 = 3600
      records = {
        key1 = {
          value = "This is a TXT record"
        }
      }
      tags = {
        record_type = "TXT"
      }
    }
  }
  role_assignments = {
    assignment1 = {
      role_definition_id_or_name             = "Contributor"
      principal_id                           = "00000000-0000-0000-0000-000000000000"
      description                            = "Role assignment for DNS management"
      skip_service_principal_aad_check       = false
      condition                              = null
      condition_version                      = null
      delegated_managed_identity_resource_id = null
      principal_type                         = null
    }
  }
}