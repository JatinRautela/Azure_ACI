variable "vnet_name" {
  description = "The name of this virtual network."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group to create the resources in."
  type        = string
}

variable "location" {
  description = "The location to create the resources in."
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

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}