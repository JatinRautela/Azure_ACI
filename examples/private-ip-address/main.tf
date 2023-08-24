provider "azurerm" {
  features {}
}

locals {
  env         = var.env
  name        = var.pname
  name_prefix = "${local.env}${local.name}"
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.name_prefix}rg"
  location = var.location
}

module "log_analytics" {
  source = "git::https://github.com/tothenew/terraform-azure-loganalytics.git"

  workspace_name      = "${local.name_prefix}-log"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

module "network" {
  source = "git::https://github.com/tothenew/terraform-azure-vnet.git"

  vnet_name               = "${local.name_prefix}-vnet"
  resource_group_name     = azurerm_resource_group.rg.name
  location                = azurerm_resource_group.rg.location
  address_space           = "10.0.0.0/16"
  virtual_network_peering = false

  subnets = {
    "aci" = {
      address_prefixes           = ["10.0.1.0/24"]
      associate_with_route_table = false
      service_delegation         = true
      delegation_name            = "Microsoft.ContainerInstance/containerGroups"
      delegation_actions         = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

module "aci" {
  source = "git::https://github.com/tothenew/terraform-azure-container-instances.git"
  #source = "../.."

  container_group_name        = "${local.name_prefix}-ci"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  log_analytics_workspace_id  = module.log_analytics.workspace_customer_id
  log_analytics_workspace_key = module.log_analytics.primary_shared_key

  ip_address_type = "Private"
  subnet_ids      = [module.network.subnet_ids["aci"]]

  containers = [{
    name   = "hello-world"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = 1
    memory = 1

    ports = [{
      port = 443
    }]
  }]

  # Optional: Set DNS configuration
  dns_config = {
    nameservers = ["1.1.1.1"]
  }
}