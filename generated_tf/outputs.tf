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

output "private_ip_address_allocation" {
  value = module.network_interface.private_ip_address_allocation
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

output "admin_username" {
  value = module.virtual_machine.admin_username
}

output "admin_password" {
  value = module.virtual_machine.admin_password
}

output "private_ip_address" {
  value = module.virtual_machine.private_ip_address
}

output "public_ip_address" {
  value = module.virtual_machine.public_ip_address
}

output "os_disk_id" {
  value = module.virtual_machine.os_disk_id
}

output "data_disk_ids" {
  value = module.virtual_machine.data_disk_ids
}

output "network_interface_ids" {
  value = module.virtual_machine.network_interface_ids
}

output "provisioning_state" {
  value = module.virtual_machine.provisioning_state
}

output "tags" {
  value = module.virtual_machine.tags
}
output "id" {
  value = module.load_balancer.id
}

output "frontend_ip_configuration" {
  value = module.load_balancer.frontend_ip_configuration
}

output "backend_address_pool" {
  value = module.load_balancer.backend_address_pool
}

output "load_balancing_rule" {
  value = module.load_balancer.load_balancing_rule
}

output "probe" {
  value = module.load_balancer.probe
}

output "inbound_nat_rule" {
  value = module.load_balancer.inbound_nat_rule
}

output "inbound_nat_pool" {
  value = module.load_balancer.inbound_nat_pool
}

output "outbound_rule" {
  value = module.load_balancer.outbound_rule
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

output "primary_blob_endpoint" {
  value = module.storage_account.primary_blob_endpoint
}

output "primary_queue_endpoint" {
  value = module.storage_account.primary_queue_endpoint
}

output "primary_table_endpoint" {
  value = module.storage_account.primary_table_endpoint
}

output "primary_file_endpoint" {
  value = module.storage_account.primary_file_endpoint
}

output "primary_location" {
  value = module.storage_account.primary_location
}

output "primary_web_endpoint" {
  value = module.storage_account.primary_web_endpoint
}

output "primary_dfs_endpoint" {
  value = module.storage_account.primary_dfs_endpoint
}

output "primary_blob_connection_string" {
  value = module.storage_account.primary_blob_connection_string
}

output "primary_queue_connection_string" {
  value = module.storage_account.primary_queue_connection_string
}

output "primary_table_connection_string" {
  value = module.storage_account.primary_table_connection_string
}

output "primary_file_connection_string" {
  value = module.storage_account.primary_file_connection_string
}

output "primary_web_connection_string" {
  value = module.storage_account.primary_web_connection_string
}

output "primary_dfs_connection_string" {
  value = module.storage_account.primary_dfs_connection_string
}

output "secondary_blob_endpoint" {
  value = module.storage_account.secondary_blob_endpoint
}

output "secondary_queue_endpoint" {
  value = module.storage_account.secondary_queue_endpoint
}

output "secondary_table_endpoint" {
  value = module.storage_account.secondary_table_endpoint
}

output "secondary_file_endpoint" {
  value = module.storage_account.secondary_file_endpoint
}

output "secondary_location" {
  value = module.storage_account.secondary_location
}

output "secondary_web_endpoint" {
  value = module.storage_account.secondary_web_endpoint
}

output "secondary_dfs_endpoint" {
  value = module.storage_account.secondary_dfs_endpoint
}

output "secondary_blob_connection_string" {
  value = module.storage_account.secondary_blob_connection_string
}

output "secondary_queue_connection_string" {
  value = module.storage_account.secondary_queue_connection_string
}

output "secondary_table_connection_string" {
  value = module.storage_account.secondary_table_connection_string
}

output "secondary_file_connection_string" {
  value = module.storage_account.secondary_file_connection_string
}

output "secondary_web_connection_string" {
  value = module.storage_account.secondary_web_connection_string
}

output "secondary_dfs_connection_string" {
  value = module.storage_account.secondary_dfs_connection_string
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

output "administrator_login" {
  value = module.sql_server.administrator_login
}

output "fqdn" {
  value = module.sql_server.fqdn
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

output "resource_group_name" {
  value = module.subnet.resource_group_name
}

output "virtual_network_name" {
  value = module.subnet.virtual_network_name
}

output "service_endpoints" {
  value = module.subnet.service_endpoints
}

output "delegation" {
  value = module.subnet.delegation
}

output "network_security_group_id" {
  value = module.subnet.network_security_group_id
}

output "route_table_id" {
  value = module.subnet.route_table_id
}
output "id" {
  value = module.private_dns_zone.id
}

output "name" {
  value = module.private_dns_zone.name
}

output "resource_group_name" {
  value = module.private_dns_zone.resource_group_name
}

output "tags" {
  value = module.private_dns_zone.tags
}

output "zone_name" {
  value = module.private_dns_zone.zone_name
}
