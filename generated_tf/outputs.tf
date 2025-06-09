output "network_security_group_name" {
  value = module.network_security_group.name
}

output "network_security_group_resource" {
  value = module.network_security_group.resource
}

output "network_security_group_resource_id" {
  value = module.network_security_group.resource_id
}
output "network_interface_location" {
  value = module.network_interface.location
}

output "network_interface_resource" {
  value = module.network_interface.resource
}

output "network_interface_resource_group_name" {
  value = module.network_interface.resource_group_name
}

output "network_interface_resource_id" {
  value = module.network_interface.resource_id
}
output "virtual_machine_id" {
  value = module.virtual_machine.id
}

output "virtual_machine_name" {
  value = module.virtual_machine.name
}

output "virtual_machine_location" {
  value = module.virtual_machine.location
}

output "virtual_machine_tags" {
  value = module.virtual_machine.tags
}

output "virtual_machine_identity" {
  value = module.virtual_machine.identity
}

output "virtual_machine_extended_location" {
  value = module.virtual_machine.extended_location
}

output "virtual_machine_properties" {
  value = module.virtual_machine.properties
}

output "virtual_machine_timeouts" {
  value = module.virtual_machine.timeouts
}
output "load_balancer_id" {
  value = module.load_balancer.id
}

output "load_balancer_name" {
  value = module.load_balancer.name
}

output "load_balancer_resource_group_name" {
  value = module.load_balancer.resource_group_name
}

output "load_balancer_frontend_ip_configuration" {
  value = module.load_balancer.frontend_ip_configuration
}

output "load_balancer_backend_address_pool" {
  value = module.load_balancer.backend_address_pool
}

output "load_balancer_backend_address_pool_address" {
  value = module.load_balancer.backend_address_pool_address
}

output "load_balancer_network_interface_backend_address_pool_association" {
  value = module.load_balancer.network_interface_backend_address_pool_association
}

output "load_balancer_probe" {
  value = module.load_balancer.probe
}

output "load_balancer_rule" {
  value = module.load_balancer.rule
}

output "load_balancer_nat_rule" {
  value = module.load_balancer.nat_rule
}

output "load_balancer_outbound_rule" {
  value = module.load_balancer.outbound_rule
}

output "load_balancer_nat_pool" {
  value = module.load_balancer.nat_pool
}
output "storage_account_containers" {
  value = module.storage_account.containers
}

output "storage_account_fqdn" {
  value = module.storage_account.fqdn
}

output "storage_account_name" {
  value = module.storage_account.name
}

output "storage_account_private_endpoints" {
  value = module.storage_account.private_endpoints
}

output "storage_account_queues" {
  value = module.storage_account.queues
}

output "storage_account_resource" {
  value = module.storage_account.resource
  sensitive = true
}

output "storage_account_resource_id" {
  value = module.storage_account.resource_id
}

output "storage_account_shares" {
  value = module.storage_account.shares
}

output "storage_account_tables" {
  value = module.storage_account.tables
}
output "sql_server_resource" {
  value = module.sql_server.resource
}

output "sql_server_resource_databases" {
  value = module.sql_server.resource_databases
}

output "sql_server_resource_elasticpools" {
  value = module.sql_server.resource_elasticpools
}

output "sql_server_resource_id" {
  value = module.sql_server.resource_id
}

output "sql_server_resource_name" {
  value = module.sql_server.resource_name
}

output "sql_server_private_endpoints" {
  value = module.sql_server.private_endpoints
}

output "private_dns_zone_a_record_outputs" {
  value = module.private_dns_zone.a_record_outputs
}

output "private_dns_zone_aaaa_record_outputs" {
  value = module.private_dns_zone.aaaa_record_outputs
}

output "private_dns_zone_cname_record_outputs" {
  value = module.private_dns_zone.cname_record_outputs
}

output "private_dns_zone_mx_record_outputs" {
  value = module.private_dns_zone.mx_record_outputs
}

output "private_dns_zone_name" {
  value = module.private_dns_zone.name
}

output "private_dns_zone_ptr_record_outputs" {
  value = module.private_dns_zone.ptr_record_outputs
}

output "private_dns_zone_resource" {
  value = module.private_dns_zone.resource
}

output "private_dns_zone_resource_id" {
  value = module.private_dns_zone.resource_id
}

output "private_dns_zone_srv_record_outputs" {
  value = module.private_dns_zone.srv_record_outputs
}

output "private_dns_zone_txt_record_outputs" {
  value = module.private_dns_zone.txt_record_outputs
}

output "private_dns_zone_virtual_network_link_outputs" {
  value = module.private_dns_zone.virtual_network_link_outputs
}
