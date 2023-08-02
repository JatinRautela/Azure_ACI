resource "azurerm_virtual_network" "this" {
    count = var.create_vnet ? 1:0
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_spaces
  dns_servers         = var.dns_servers

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan != null ? [0] : []

    content {
      id     = var.ddos_protection_plan["id"]
      enable = var.ddos_protection_plan["enable"]
    }
  }

  tags = var.tags
}

resource "azurerm_subnet" "this" {
  for_each = var.create_vnet == true ? var.subnets : {}

  name                 = each.value["name"]
  resource_group_name  = azurerm_virtual_network.this.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value["address_prefixes"]
  service_endpoints    = each.value["service_endpoints"]

  dynamic "delegation" {
    for_each = each.value["delegations"]

    content {
      # If a name is not explicitly set, set it to the index of the current object.
      # E.g., if two subnet delegations are to be configured, the first delegation will be named "0" and the second will be named "1".
      # This is the default naming convention when creating a subnet delegation in the Azure Portal.
      name = coalesce(delegation.value["name"], index(each.value["delegations"], delegation.value))

      service_delegation {
        name    = delegation.value["service_name"]
        actions = delegation.value["service_actions"]
      }
    }
  }
}

variable "vnet_name" {
  description = "The name of this virtual network."
  type        = string
}

variable "address_spaces" {
  description = "A list of address spaces that are used for this virtual network."
  type        = list(string)
}

variable "dns_servers" {
  description = "A list of DNS servers to use for this virtual network."
  type        = list(string)
  default     = []
}

variable "ddos_protection_plan" {
  description = "A DDoS Protection plan for this virtual network. This is a HIGH COST service (ref: https://azure.microsoft.com/en-us/pricing/details/ddos-protection/)."

  type = object({
    id     = string
    enable = optional(bool, false) # Disabled by default to prevent accidentally enabling HIGH COST service.
  })

  default = null
}

variable "subnets" {
  description = "A map of subnets to create for this virtual network."

  type = map(object({
    name              = string
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])

    delegations = optional(list(object({
      name            = optional(string)
      service_name    = string
      service_actions = optional(list(string), ["Microsoft.Network/virtualNetworks/subnets/action"])
    })), [])

    network_security_group_association = optional(object({
      network_security_group_id = string
    }))

    route_table_association = optional(object({
      route_table_id = string
    }))

    nat_gateway_association = optional(object({
      nat_gateway_id = string
    }))
  }))

  default = {}
}

output "vnet_id" {
  description = "The ID of this virtual network."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "The name of this virtual network."
  value       = azurerm_virtual_network.this.name
}

output "address_spaces" {
  description = "A list of address spaces that are used for this virtual network."
  value       = azurerm_virtual_network.this.address_space
}

output "subnet_ids" {
  description = "A map of subnet IDs."
  value = {
    for k, v in azurerm_subnet.this : k => v.id
  }
}

output "subnet_names" {
  description = "A map of subnet names."
  value = {
    for k, v in azurerm_subnet.this : k => v.name
  }
}