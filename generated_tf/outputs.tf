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
output "virtual_machine_resource_id" {
  value = module.virtual_machine.resource_id
}

output "virtual_machine_admin_password" {
  value = module.virtual_machine.admin_password
}

output "virtual_machine_admin_username" {
  value = module.virtual_machine.admin_username
}

output "virtual_machine_custom_location_id" {
  value = module.virtual_machine.custom_location_id
}

output "virtual_machine_image_id" {
  value = module.virtual_machine.image_id
}

output "virtual_machine_location" {
  value = module.virtual_machine.location
}

output "virtual_machine_logical_network_id" {
  value = module.virtual_machine.logical_network_id
}

output "virtual_machine_name" {
  value = module.virtual_machine.name
}

output "virtual_machine_resource_group_name" {
  value = module.virtual_machine.resource_group_name
}

output "virtual_machine_auto_upgrade_minor_version" {
  value = module.virtual_machine.auto_upgrade_minor_version
}

output "virtual_machine_data_disk_params" {
  value = module.virtual_machine.data_disk_params
}

output "virtual_machine_domain_join_extension_tags" {
  value = module.virtual_machine.domain_join_extension_tags
}

output "virtual_machine_domain_join_password" {
  value = module.virtual_machine.domain_join_password
}

output "virtual_machine_domain_join_user_name" {
  value = module.virtual_machine.domain_join_user_name
}

output "virtual_machine_domain_target_ou" {
  value = module.virtual_machine.domain_target_ou
}

output "virtual_machine_domain_to_join" {
  value = module.virtual_machine.domain_to_join
}

output "virtual_machine_dynamic_memory" {
  value = module.virtual_machine.dynamic_memory
}

output "virtual_machine_dynamic_memory_buffer" {
  value = module.virtual_machine.dynamic_memory_buffer
}

output "virtual_machine_dynamic_memory_max" {
  value = module.virtual_machine.dynamic_memory_max
}

output "virtual_machine_dynamic_memory_min" {
  value = module.virtual_machine.dynamic_memory_min
}

output "virtual_machine_enable_telemetry" {
  value = module.virtual_machine.enable_telemetry
}

output "virtual_machine_http_proxy" {
  value = module.virtual_machine.http_proxy
}

output "virtual_machine_https_proxy" {
  value = module.virtual_machine.https_proxy
}

output "virtual_machine_linux_ssh_config" {
  value = module.virtual_machine.linux_ssh_config
}

output "virtual_machine_lock" {
  value = module.virtual_machine.lock
}

output "virtual_machine_managed_identities" {
  value = module.virtual_machine.managed_identities
}

output "virtual_machine_memory_mb" {
  value = module.virtual_machine.memory_mb
}

output "virtual_machine_nic_tags" {
  value = module.virtual_machine.nic_tags
}

output "virtual_machine_no_proxy" {
  value = module.virtual_machine.no_proxy
}

output "virtual_machine_os_type" {
  value = module.virtual_machine.os_type
}

output "virtual_machine_private_ip_address" {
  value = module.virtual_machine.private_ip_address
}

output "virtual_machine_role_assignments" {
  value = module.virtual_machine.role_assignments
}

output "virtual_machine_secure_boot_enabled" {
  value = module.virtual_machine.secure_boot_enabled
}

output "virtual_machine_tags" {
  value = module.virtual_machine.tags
}

output "virtual_machine_trusted_ca" {
  value = module.virtual_machine.trusted_ca
}

output "virtual_machine_type_handler_version" {
  value = module.virtual_machine.type_handler_version
}

output "virtual_machine_user_storage_id" {
  value = module.virtual_machine.user_storage_id
}

output "virtual_machine_v_cpu_count" {
  value = module.virtual_machine.v_cpu_count
}

output "virtual_machine_windows_ssh_config" {
  value = module.virtual_machine.windows_ssh_config
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

output "load_balancer_location" {
  value = module.load_balancer.location
}

output "load_balancer_sku" {
  value = module.load_balancer.sku
}

output "load_balancer_sku_tier" {
  value = module.load_balancer.sku_tier
}

output "load_balancer_tags" {
  value = module.load_balancer.tags
}

output "load_balancer_frontend_ip_configurations" {
  value = module.load_balancer.frontend_ip_configurations
}

output "load_balancer_backend_address_pools" {
  value = module.load_balancer.backend_address_pools
}

output "load_balancer_backend_address_pool_addresses" {
  value = module.load_balancer.backend_address_pool_addresses
}

output "load_balancer_backend_address_pool_network_interfaces" {
  value = module.load_balancer.backend_address_pool_network_interfaces
}

output "load_balancer_lb_probes" {
  value = module.load_balancer.lb_probes
}

output "load_balancer_lb_rules" {
  value = module.load_balancer.lb_rules
}

output "load_balancer_lb_nat_rules" {
  value = module.load_balancer.lb_nat_rules
}

output "load_balancer_lb_outbound_rules" {
  value = module.load_balancer.lb_outbound_rules
}

output "load_balancer_lb_nat_pools" {
  value = module.load_balancer.lb_nat_pools
}

output "load_balancer_public_ip_address_configuration" {
  value = module.load_balancer.public_ip_address_configuration
}

output "load_balancer_edge_zone" {
  value = module.load_balancer.edge_zone
}

output "load_balancer_role_assignments" {
  value = module.load_balancer.role_assignments
}

output "load_balancer_lock" {
  value = module.load_balancer.lock
}

output "load_balancer_diagnostic_settings" {
  value = module.load_balancer.diagnostic_settings
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
