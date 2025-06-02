network_security_group_config = {
  name                = "example-nsg"
  resource_group_name = "example-resource-group"
  location            = "eastus"
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
      source_address_prefix      = "0.0.0.0/0"
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
  name                       = "example-nic"
  location                   = "eastus"
  resource_group_name        = "example-resource-group"
  subnet_id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/example-vnet/subnets/example-subnet"
  private_ip_address         = "10.0.0.4"
  private_ip_address_version = "IPv4"
  enable_ip_forwarding       = true
  enable_accelerated_networking = false
  dns_servers                = ["8.8.8.8", "8.8.4.4"]
  tags = {
    environment = "production"
    owner       = "team-network"
  }
}
virtual_machine_config = {
  name                = "my-vm"
  location            = "eastus"
  resource_group_name = "my-resource-group"
  vm_size             = "Standard_DS2_v2"
  admin_username      = "adminuser"
  admin_password      = "P@ssw0rd123!"
  network_interface_ids = [
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/networkInterfaces/nic1",
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/networkInterfaces/nic2"
  ]
  os_disk = {
    name              = "my-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 128
  }
}
load_balancer_config = {
  name                = "my-load-balancer"
  resource_group_name = "my-resource-group"
  location            = "eastus"
  sku                 = "Standard"
  frontend_ip_configurations = [
    {
      name                      = "frontend-ip-1"
      public_ip_address_id      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/publicIPAddresses/my-public-ip"
      private_ip_address        = null
      private_ip_allocation_method = "Dynamic"
      subnet_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-subnet"
    },
    {
      name                      = "frontend-ip-2"
      public_ip_address_id      = null
      private_ip_address        = "10.0.0.5"
      private_ip_allocation_method = "Static"
      subnet_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-subnet"
    }
  ]
}
storage_account_config = {
  name                     = "mystorageaccount"
  resource_group_name      = "my-resource-group"
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  enable_https_traffic_only = true
  tags = {
    environment = "production"
    owner       = "team-xyz"
  }
}
sql_server_config = {
  name                = "my-sql-server"
  resource_group_name = "my-resource-group"
  location            = "eastus"
  administrator_login = "adminuser"
  administrator_password = "P@ssw0rd123!"
  version             = "12.0"
  tags = {
    environment = "production"
    owner       = "team-xyz"
  }
}
private_dns_zone_config = {
  name                = "example.private.dns.zone"
  resource_group_name = "example-resource-group"
  tags = {
    environment = "production"
    owner       = "team-xyz"
  }
  virtual_network_links = [
    {
      name                 = "vnet-link-1"
      virtual_network_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/vnet1"
      registration_enabled = true
    },
    {
      name                 = "vnet-link-2"
      virtual_network_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.Network/virtualNetworks/vnet2"
      registration_enabled = false
    }
  ]
}
