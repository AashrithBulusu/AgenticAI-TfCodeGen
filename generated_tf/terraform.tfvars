network_security_group_config = {
  name                = "example-nsg"
  location            = "eastus"
  resource_group_name = "example-rg"
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
      name                       = "allow-http"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "0.0.0.0/0"
      destination_address_prefix = "*"
    },
    {
      name                       = "deny-all-outbound"
      priority                   = 4000
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
  resource_group_name         = "example-rg"
  enable_accelerated_networking = true
  enable_ip_forwarding        = false
  dns_servers                 = ["8.8.8.8", "8.8.4.4"]
  internal_dns_name_label     = "example-internal-dns"
  tags = {
    environment = "production"
    owner       = "team-network"
  }
  ip_configuration = {
    name                          = "example-ip-config"
    subnet_id                     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/virtualNetworks/example-vnet/subnets/example-subnet"
    private_ip_address_allocation = "Dynamic"
    private_ip_address            = null
    public_ip_address_id          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/publicIPAddresses/example-pip"
    application_gateway_backend_address_pools_ids = []
    load_balancer_backend_address_pools_ids       = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/loadBalancers/example-lb/backendAddressPools/example-backend-pool"]
    load_balancer_inbound_nat_rules_ids           = []
  }
}
virtual_machine_config = {
  name                  = "example-vm"
  resource_group_name   = "example-resource-group"
  location              = "eastus"
  vm_size               = "Standard_DS1_v2"
  admin_username        = "adminuser"
  admin_password        = "P@ssw0rd123!"
  network_interface_ids = [
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.Network/networkInterfaces/nic1",
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.Network/networkInterfaces/nic2"
  ]
  os_disk_size_gb       = 128
  os_disk_type          = "Premium_LRS"
  data_disks = [
    {
      size_gb = 256
      type    = "Standard_LRS"
    },
    {
      size_gb = 512
      type    = "Premium_LRS"
    }
  ]
}
load_balancer_config = {
  name                = "my-load-balancer"
  resource_group_name = "my-resource-group"
  location            = "East US"
  frontend_ip_configurations = [
    {
      name                 = "frontend-ip-1"
      private_ip_address   = "10.0.0.5"
      private_ip_allocation = "Static"
      subnet_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-subnet"
      public_ip_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/publicIPAddresses/my-public-ip"
    },
    {
      name                 = "frontend-ip-2"
      private_ip_allocation = "Dynamic"
      subnet_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/my-subnet"
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
    owner       = "team-a"
  }
}
sql_server_config = {
  name                        = "my-sql-server"
  resource_group_name         = "my-resource-group"
  location                    = "eastus"
  administrator_login         = "adminuser"
  administrator_login_password = "P@ssw0rd123"
  version                     = "12.0"
  tags = {
    environment = "production"
    owner       = "team-a"
  }
}
subnet_config = {
  name                 = "app-subnet"
  address_prefixes     = ["10.0.1.0/24"]
  resource_group_name  = "rg-app-environment"
  virtual_network_name = "vnet-app"
  service_endpoints    = ["Microsoft.Storage", "Microsoft.Sql"]
  delegations = [
    {
      name         = "app-delegation"
      service_name = "Microsoft.Web/serverFarms"
    }
  ]
}
private_dns_zone_config = {
  name                = "example.com"
  resource_group_name = "rg-private-dns"
  tags = {
    environment = "production"
    owner       = "team-network"
  }
  virtual_network_links = [
    {
      name                 = "vnet-link-1"
      virtual_network_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-vnet/providers/Microsoft.Network/virtualNetworks/vnet-1"
      registration_enabled = true
    },
    {
      name                 = "vnet-link-2"
      virtual_network_id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-vnet/providers/Microsoft.Network/virtualNetworks/vnet-2"
      registration_enabled = false
    }
  ]
}
