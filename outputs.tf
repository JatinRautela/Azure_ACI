output "container_group_id" {
  description = "The ID of this Container Instance."
  value       = azurerm_container_group.container_group.id
}

output "identity_principal_id" {
  description = "The principal ID of the system-assigned identity of this Container Instance."
  value       = try(azurerm_container_group.container_group.identity[0].principal_id, null)
}

output "identity_tenant_id" {
  description = "The tenant ID of the system-assigned identity of this Container Instance."
  value       = try(azurerm_container_group.container_group.identity[0].tenant_id, null)
}

output "ip_address" {
  description = "The IP address of this Container Instance."
  value       = azurerm_container_group.container_group.ip_address
}
