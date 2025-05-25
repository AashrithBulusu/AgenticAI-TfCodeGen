output "id" {
  value = module.network_security_group.id
}

output "name" {
  value = module.network_security_group.name
}

output "location" {
  value = module.network_security_group.location
}

output "resource_group_name" {
  value = module.network_security_group.resource_group_name
}

output "security_rule_ids" {
  value = module.network_security_group.security_rule_ids
}
output "id" {
  value = module.network_interface.id
}

output "name" {
  value = module.network_interface.name
}

output "location" {
  value = module.network_interface.location
}

output "resource_group_name" {
  value = module.network_interface.resource_group_name
}

output "mac_address" {
  value = module.network_interface.mac_address
}

output "private_ip_address" {
  value = module.network_interface.private_ip_address
}

output "private_ip_addresses" {
  value = module.network_interface.private_ip_addresses
}

output "dns_servers" {
  value = module.network_interface.dns_servers
}

output "enable_accelerated_networking" {
  value = module.network_interface.enable_accelerated_networking
}

output "enable_ip_forwarding" {
  value = module.network_interface.enable_ip_forwarding
}

output "tags" {
  value = module.network_interface.tags
}
output "id" {
  value = module.virtual_machine.id
}

output "name" {
  value = module.virtual_machine.name
}

output "location" {
  value = module.virtual_machine.location
}

output "resource_group_name" {
  value = module.virtual_machine.resource_group_name
}

output "vm_size" {
  value = module.virtual_machine.vm_size
}

output "os_disk_id" {
  value = module.virtual_machine.os_disk_id
}

output "network_interface_ids" {
  value = module.virtual_machine.network_interface_ids
}

output "admin_username" {
  value = module.virtual_machine.admin_username
}

output "admin_password" {
  value = module.virtual_machine.admin_password
}

output "tags" {
  value = module.virtual_machine.tags
}
output "id" {
  value = module.load_balancer.id
}

output "name" {
  value = module.load_balancer.name
}

output "resource_group_name" {
  value = module.load_balancer.resource_group_name
}

output "frontend_ip_configuration_ids" {
  value = module.load_balancer.frontend_ip_configuration_ids
}

output "backend_address_pool_ids" {
  value = module.load_balancer.backend_address_pool_ids
}

output "load_balancing_rule_ids" {
  value = module.load_balancer.load_balancing_rule_ids
}

output "probe_ids" {
  value = module.load_balancer.probe_ids
}

output "inbound_nat_rule_ids" {
  value = module.load_balancer.inbound_nat_rule_ids
}

output "inbound_nat_pool_ids" {
  value = module.load_balancer.inbound_nat_pool_ids
}

output "tags" {
  value = module.load_balancer.tags
}
output "id" {
  value = module.storage_account.id
}

output "name" {
  value = module.storage_account.name
}

output "primary_endpoint" {
  value = module.storage_account.primary_endpoint
}

output "primary_blob_endpoint" {
  value = module.storage_account.primary_blob_endpoint
}

output "primary_file_endpoint" {
  value = module.storage_account.primary_file_endpoint
}

output "primary_queue_endpoint" {
  value = module.storage_account.primary_queue_endpoint
}

output "primary_table_endpoint" {
  value = module.storage_account.primary_table_endpoint
}

output "primary_location" {
  value = module.storage_account.primary_location
}

output "secondary_endpoint" {
  value = module.storage_account.secondary_endpoint
}

output "secondary_blob_endpoint" {
  value = module.storage_account.secondary_blob_endpoint
}

output "secondary_file_endpoint" {
  value = module.storage_account.secondary_file_endpoint
}

output "secondary_queue_endpoint" {
  value = module.storage_account.secondary_queue_endpoint
}

output "secondary_table_endpoint" {
  value = module.storage_account.secondary_table_endpoint
}

output "secondary_location" {
  value = module.storage_account.secondary_location
}

output "resource_group_name" {
  value = module.storage_account.resource_group_name
}

output "account_tier" {
  value = module.storage_account.account_tier
}

output "account_replication_type" {
  value = module.storage_account.account_replication_type
}

output "identity" {
  value = module.storage_account.identity
}
output "id" {
  value = module.sql_server.id
}

output "name" {
  value = module.sql_server.name
}

output "location" {
  value = module.sql_server.location
}

output "resource_group_name" {
  value = module.sql_server.resource_group_name
}

output "fqdn" {
  value = module.sql_server.fqdn
}

output "administrator_login" {
  value = module.sql_server.administrator_login
}

output "administrator_login_password" {
  value = module.sql_server.administrator_login_password
}

output "identity" {
  value = module.sql_server.identity
}

output "tags" {
  value = module.sql_server.tags
}
output "id" {
  value = module.subnet.id
}

output "name" {
  value = module.subnet.name
}

output "address_prefix" {
  value = module.subnet.address_prefix
}

output "virtual_network_name" {
  value = module.subnet.virtual_network_name
}

output "resource_group_name" {
  value = module.subnet.resource_group_name
}

output "delegation" {
  value = module.subnet.delegation
}

output "service_endpoints" {
  value = module.subnet.service_endpoints
}

output "private_endpoint_network_policies" {
  value = module.subnet.private_endpoint_network_policies
}

output "private_link_service_network_policies" {
  value = module.subnet.private_link_service_network_policies
}
