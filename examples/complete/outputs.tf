output "container_group_id" {
  description = "The ID of this Container Instance."
  value       = module.aci.container_group_id
}

output "identity_principal_id" {
  description = "The principal ID of the system-assigned identity of this Container Instance."
  value       = module.aci.identity_principal_id
}

output "identity_tenant_id" {
  description = "The tenant ID of the system-assigned identity of this Container Instance."
  value       = module.aci.identity_tenant_id
}

output "ip_address" {
  description = "The IP address of this Container Instance."
  value       = module.aci.ip_address
}