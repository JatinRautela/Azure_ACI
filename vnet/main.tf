resource "azurerm_virtual_network" "this" {
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
  for_each = var.subnets

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