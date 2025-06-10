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
output "load_balancer_azurerm_lb" {
  value = module.load_balancer.azurerm_lb
}

output "load_balancer_azurerm_lb_backend_address_pool" {
  value = module.load_balancer.azurerm_lb_backend_address_pool
}

output "load_balancer_azurerm_lb_nat_rule" {
  value = module.load_balancer.azurerm_lb_nat_rule
}

output "load_balancer_azurerm_public_ip" {
  value = module.load_balancer.azurerm_public_ip
}

output "load_balancer_name" {
  value = module.load_balancer.name
}

output "load_balancer_resource" {
  value = module.load_balancer.resource
}

output "load_balancer_resource_id" {
  value = module.load_balancer.resource_id
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
output "sql_server_id" {
  value = module.sql_server.id
}

output "sql_server_name" {
  value = module.sql_server.name
}

output "sql_server_fully_qualified_domain_name" {
  value = module.sql_server.fully_qualified_domain_name
}

output "sql_server_administrator_login" {
  value = module.sql_server.administrator_login
}

output "sql_server_administrator_login_password" {
  value = module.sql_server.administrator_login_password
}

output "sql_server_location" {
  value = module.sql_server.location
}

output "sql_server_resource_group_name" {
  value = module.sql_server.resource_group_name
}

output "sql_server_version" {
  value = module.sql_server.version
}

output "sql_server_connection_policy" {
  value = module.sql_server.connection_policy
}

output "sql_server_express_vulnerability_assessment_enabled" {
  value = module.sql_server.express_vulnerability_assessment_enabled
}

output "sql_server_minimum_tls_version" {
  value = module.sql_server.minimum_tls_version
}

output "sql_server_outbound_network_restriction_enabled" {
  value = module.sql_server.outbound_network_restriction_enabled
}

output "sql_server_primary_user_assigned_identity_id" {
  value = module.sql_server.primary_user_assigned_identity_id
}

output "sql_server_public_network_access_enabled" {
  value = module.sql_server.public_network_access_enabled
}

output "sql_server_tags" {
  value = module.sql_server.tags
}

output "sql_server_transparent_data_encryption_key_vault_key_id" {
  value = module.sql_server.transparent_data_encryption_key_vault_key_id
}

output "private_dns_zone_name" {
  value = module.private_dns_zone.name
}

output "private_dns_zone_resource" {
  value = module.private_dns_zone.resource
}

output "private_dns_zone_resource_id" {
  value = module.private_dns_zone.resource_id
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

output "private_dns_zone_ptr_record_outputs" {
  value = module.private_dns_zone.ptr_record_outputs
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
