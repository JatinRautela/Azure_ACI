output "container_group_id" {
  description = "The ID of this Container Instance."
  value       = module.aci.container_group_id
}

output "ip_address" {
  description = "The IP address of this Container Instance."
  value       = module.aci.ip_address
}