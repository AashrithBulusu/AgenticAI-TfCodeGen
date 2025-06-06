network_security_group_config = {
  location            = "eastus"
  name                = "example-nsg"
  resource_group_name = "example-resource-group"
  tags                = {
    environment = "production"
    owner       = "team-a"
  }
  timeouts = {
    create = "30m"
    delete = "30m"
    read   = "5m"
    update = "20m"
  }
}
network_interface_config = {
  location                       = "eastus"
  name                           = "example-nic"
  resource_group_name            = "example-rg"
  accelerated_networking_enabled = true
  dns_servers                    = ["8.8.8.8", "8.8.4.4"]
  edge_zone                      = null
  internal_dns_name_label        = "example-dns-label"
  ip_forwarding_enabled          = false
  tags                           = { environment = "production", team = "networking" }
  ip_configurations = {
    ipconfig1 = {
      name                                               = "ipconfig1"
      gateway_load_balancer_frontend_ip_configuration_id = null
      subnet_id                                          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/virtualNetworks/example-vnet/subnets/example-subnet"
      private_ip_address_version                         = "IPv4"
      private_ip_address_allocation                      = "Dynamic"
      public_ip_address_id                               = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/publicIPAddresses/example-pip"
      primary                                            = true
      private_ip_address                                 = null
    }
    ipconfig2 = {
      name                                               = "ipconfig2"
      gateway_load_balancer_frontend_ip_configuration_id = null
      subnet_id                                          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/virtualNetworks/example-vnet/subnets/example-subnet"
      private_ip_address_version                         = "IPv4"
      private_ip_address_allocation                      = "Static"
      public_ip_address_id                               = null
      primary                                            = false
      private_ip_address                                 = "10.0.0.5"
    }
  }
}
virtual_machine_config = {
  admin_password             = "P@ssw0rd123!"
  admin_username             = "vmadmin"
  auto_upgrade_minor_version = true
  custom_location_id         = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/myResourceGroup/providers/Microsoft.ExtendedLocation/customLocations/myCustomLocation"
  data_disk_params = {
    disk1 = {
      name        = "dataDisk1"
      diskSizeGB  = 128
      dynamic     = false
      tags        = { environment = "production", department = "IT" }
      containerId = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/myResourceGroup/providers/Microsoft.Storage/storageAccounts/myStorageAccount/blobServices/default/containers/myContainer"
    }
    disk2 = {
      name        = "dataDisk2"
      diskSizeGB  = 256
      dynamic     = true
      tags        = { environment = "staging" }
      containerId = null
    }
  }
}
load_balancer_config = {
  location            = "eastus"
  name                = "my-load-balancer"
  resource_group_name = "my-resource-group"
  edge_zone           = null
  sku                 = "Standard"
  sku_tier            = "Regional"
  tags                = {
    environment = "production"
    owner       = "team-a"
  }
  frontend_ip_configurations = {
    frontend1 = {
      name                                               = "frontend-config-1"
      frontend_private_ip_address                        = "10.0.0.4"
      frontend_private_ip_address_version                = "IPv4"
      frontend_private_ip_address_allocation             = "Static"
      frontend_private_ip_subnet_resource_id             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-subnet"
      gateway_load_balancer_frontend_ip_configuration_id = null
      public_ip_address_resource_id                      = null
      create_public_ip_address                           = false
      zones                                              = ["1", "2", "3"]
    }
    frontend2 = {
      name                                               = "frontend-config-2"
      frontend_private_ip_address                        = null
      frontend_private_ip_address_version                = "IPv4"
      frontend_private_ip_address_allocation             = "Dynamic"
      frontend_private_ip_subnet_resource_id             = null
      gateway_load_balancer_frontend_ip_configuration_id = null
      public_ip_address_resource_id                      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/publicIPAddresses/my-public-ip"
      create_public_ip_address                           = false
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
  tags                              = { environment = "dev", project = "example" }
}
sql_server_config = {
  location                                     = "eastus"
  name                                         = "my-sql-server"
  resource_group_name                          = "my-resource-group"
  server_version                               = "12.0"
  administrator_login                          = "adminuser"
  administrator_login_password                 = "P@ssw0rd123"
  connection_policy                            = null
  express_vulnerability_assessment_enabled     = false
  outbound_network_restriction_enabled         = false
  primary_user_assigned_identity_id            = null
  public_network_access_enabled                = true
  tags                                         = {
    environment = "production"
    owner       = "team-a"
  }
  transparent_data_encryption_key_vault_key_id = null
  azuread_administrator = {
    login_username              = "aadadminuser"
    object_id                   = "00000000-0000-0000-0000-000000000000"
    azuread_authentication_only = false
    tenant_id                   = null
  }
}
private_dns_zone_config = {
  domain_name         = "example.com"
  resource_group_name = "rg-private-dns"
  tags = {
    environment = "production"
    owner       = "team-networking"
  }
  soa_record = {
    email        = "admin@example.com"
    expire_time  = 2592000
    minimum_ttl  = 30
    refresh_time = 7200
    retry_time   = 600
    ttl          = 3600
    tags = {
      record_type = "SOA"
      managed_by  = "terraform"
    }
  }
}
