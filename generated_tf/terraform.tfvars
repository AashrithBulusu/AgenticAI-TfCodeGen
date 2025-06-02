network_security_group_config = {
  location            = "eastus"
  name                = "my-nsg"
  resource_group_name = "my-resource-group"
  tags = {
    environment = "production"
    owner       = "team-network"
  }
  timeouts = {
    create = "30m"
    delete = "30m"
    read   = "5m"
    update = "20m"
  }
}
```hcl
network_interface_config = {
  location                                     = "eastus"
  name                                         = "example-nic"
  resource_group_name                         = "example-resource-group"
  accelerated_networking_enabled              = true
  application_gateway_backend_address_pool_association = {
    application_gateway_backend_address_pool_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.Network/applicationGateways/example-appgw/backendAddressPools/example-backend-pool"
    ip_configuration_name                       = "example-ip-config"
  }
}
```
virtual_machine_config = {
  admin_password         = "P@ssw0rd123!"
  admin_username         = "adminuser"
  auto_upgrade_minor_version = true
  custom_location_id     = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/myResourceGroup/providers/Microsoft.ExtendedLocation/customLocations/myCustomLocation"
  data_disk_params = {
    disk1 = {
      name        = "dataDisk1"
      diskSizeGB  = 128
      dynamic     = false
      tags        = {
        environment = "production"
        team        = "devops"
      }
      containerId = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/myResourceGroup/providers/Microsoft.Storage/storageAccounts/myStorageAccount/blobServices/default/containers/myContainer"
    }
    disk2 = {
      name        = "dataDisk2"
      diskSizeGB  = 256
      dynamic     = true
    }
  }
}
load_balancer_config = {
  location            = "eastus"
  name                = "my-load-balancer"
  resource_group_name = "my-resource-group"
  edge_zone           = "edge-zone-1"
  sku                 = "Standard"
  sku_tier            = "Regional"
  tags = {
    environment = "production"
    owner       = "team-a"
  }
  frontend_ip_configurations = {
    frontend1 = {
      name                                               = "frontend-ip-1"
      frontend_private_ip_address                        = "10.0.0.5"
      frontend_private_ip_address_version                = "IPv4"
      frontend_private_ip_address_allocation             = "Static"
      frontend_private_ip_subnet_resource_id             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-subnet"
      gateway_load_balancer_frontend_ip_configuration_id = null
      public_ip_address_resource_id                      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/publicIPAddresses/my-public-ip"
      create_public_ip_address                           = false
      zones                                              = ["1", "2", "3"]
    }
    frontend2 = {
      name                                               = "frontend-ip-2"
      frontend_private_ip_address                        = null
      frontend_private_ip_address_version                = "IPv4"
      frontend_private_ip_address_allocation             = "Dynamic"
      frontend_private_ip_subnet_resource_id             = null
      gateway_load_balancer_frontend_ip_configuration_id = null
      public_ip_address_resource_id                      = null
      create_public_ip_address                           = true
      zones                                              = ["1", "2", "3"]
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
  allow_nested_items_to_be_public   = false
  allowed_copy_scope                = null
  cross_tenant_replication_enabled  = false
  default_to_oauth_authentication   = false
  edge_zone                         = null
  https_traffic_only_enabled        = true
  infrastructure_encryption_enabled = false
  is_hns_enabled                    = false
  large_file_share_enabled          = false
  min_tls_version                   = "TLS1_2"
  nfsv3_enabled                     = false
  public_network_access_enabled     = true
  queue_encryption_key_type         = null
  sftp_enabled                      = false
  shared_access_key_enabled         = true
  table_encryption_key_type         = null
  tags                              = {
    environment = "production"
    department  = "IT"
  }
  azure_files_authentication = {
    directory_type                 = "AADDS"
    default_share_level_permission = "StorageFileDataSmbShareContributor"
    active_directory = {
      domain_guid         = "12345678-1234-1234-1234-123456789abc"
      domain_name         = "example.com"
      domain_sid          = "S-1-5-21-1234567890-1234567890-1234567890"
      forest_name         = "example.com"
      netbios_domain_name = "EXAMPLE"
      storage_sid         = "S-1-5-21-0987654321-0987654321-0987654321"
    }
  }
}
sql_server_config = {
  location                                     = "eastus"
  name                                         = "my-sql-server"
  resource_group_name                          = "my-resource-group"
  server_version                               = "12.0"
  administrator_login                          = "adminuser"
  administrator_login_password                 = "P@ssw0rd123!"
  connection_policy                            = "Default"
  outbound_network_restriction_enabled         = true
  primary_user_assigned_identity_id            = null
  public_network_access_enabled                = false
  tags                                         = {
    environment = "production"
    owner       = "team-a"
  }
  transparent_data_encryption_key_vault_key_id = null
  azuread_administrator = {
    login_username              = "aadadminuser"
    object_id                   = "00000000-0000-0000-0000-000000000000"
    azuread_authentication_only = true
    tenant_id                   = "11111111-1111-1111-1111-111111111111"
  }
}
private_dns_zone_config = {
  domain_name         = "example.com"
  resource_group_name = "rg-private-dns"
  tags = {
    environment = "production"
    owner       = "team-network"
  }
  enable_telemetry = true
  soa_record = {
    email        = "admin@example.com"
    expire_time  = 2419200
    minimum_ttl  = 10
    refresh_time = 3600
    retry_time   = 300
    ttl          = 3600
    tags = {
      managed_by = "terraform"
      purpose    = "dns-management"
    }
  }
}
