network_security_group_config = {
  name                = "example-nsg"
  location            = "eastus"
  resource_group_name = "example-resource-group"
  tags = {
    environment = "production"
    owner       = "team-network"
  }
  security_rules = [
    {
      name                       = "allow-ssh"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "deny-all-outbound"
      priority                   = 200
      direction                  = "Outbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}
network_interface_config = {
  name                        = "example-nic"
  location                    = "eastus"
  resource_group_name         = "example-resource-group"
  enable_accelerated_networking = true
  enable_ip_forwarding        = false
  private_ip_address          = "10.0.0.4"
  private_ip_address_allocation = "Static"
  subnet_id                   = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/example-vnet/subnets/example-subnet"
  public_ip_address_id        = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/example-resource-group/providers/Microsoft.Network/publicIPAddresses/example-pip"
  dns_servers                 = ["8.8.8.8", "8.8.4.4"]
  tags                        = {
    environment = "production"
    owner       = "team-example"
  }
}
virtual_machine_config = {
  name                = "my-vm-instance"
  resource_group_name = "my-resource-group"
  location            = "eastus"
  vm_size             = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = "P@ssw0rd123!"
  network_interface_ids = [
    "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/my-resource-group/providers/Microsoft.Network/networkInterfaces/nic1",
    "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/my-resource-group/providers/Microsoft.Network/networkInterfaces/nic2"
  ]
  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 128
  }
}
load_balancer_config = {
  name                = "my-load-balancer"
  resource_group_name = "my-resource-group"
  location            = "East US"
  frontend_ip_configurations = [
    {
      name                 = "frontend-ip-config-1"
      private_ip_address   = "10.0.0.5"
      private_ip_allocation = "Static"
      subnet_id            = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-subnet"
      public_ip_address_id = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/my-resource-group/providers/Microsoft.Network/publicIPAddresses/my-public-ip"
    },
    {
      name                 = "frontend-ip-config-2"
      private_ip_address   = null
      private_ip_allocation = "Dynamic"
      subnet_id            = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-subnet"
      public_ip_address_id = null
    }
  ]
}
storage_account_config = {
  name                      = "mystorageaccount"
  resource_group_name       = "my-resource-group"
  location                  = "eastus"
  account_tier              = "Premium"
  account_replication_type  = "ZRS"
  enable_https_traffic_only = true
  is_hns_enabled            = true
  tags = {
    environment = "production"
    owner       = "team-xyz"
  }
}
sql_server_config = {
  name                      = "my-sql-server"
  resource_group_name       = "my-resource-group"
  location                  = "eastus"
  administrator_login       = "adminuser"
  administrator_password    = "P@ssw0rd123!"
  version                   = "12.0"
  identity_type             = "SystemAssigned"
  tags                      = {
    environment = "production"
    owner       = "team-a"
  }
  minimum_tls_version       = "1.2"
  public_network_access     = "Enabled"
  extended_auditing_policy  = {
    storage_account_access_key = null
    storage_account_id         = null
    retention_in_days          = 30
    state                      = "Enabled"
  }
}
private_dns_zone_config = {
  name                = "example-private-dns-zone"
  resource_group_name = "example-resource-group"
  tags                = {
    environment = "production"
    owner       = "team-xyz"
  }
  zone_name           = "example.com"
  registration_enabled = true
  resolution_enabled   = true
  virtual_network_links = [
    {
      name                 = "vnet-link-1"
      virtual_network_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/vnet-1"
      registration_enabled = true
    },
    {
      name                 = "vnet-link-2"
      virtual_network_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/vnet-2"
      registration_enabled = false
    }
  ]
}
