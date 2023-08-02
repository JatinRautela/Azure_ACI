provider "azurerm" {
  features {}
}

locals {
  env         = "env"
  name        = "pname"
  name_prefix = "${local.env}${local.name}"
}

resource "azurerm_resource_group" "example" {
  name     = "${local.name_prefix}rg"
  location = var.location
}

module "log_analytics" {
  source = "git::https://github.com/JatinRautela/azurerm-log-analytics.git"

  workspace_name      = "${local.name_prefix}-log"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}

module "aci" {
  # source = "git::https://github.com/JatinRautela/Azure_ACI.git"
  source = "../.."

  container_group_name        = "${local.name_prefix}-ci"
  resource_group_name         = azurerm_resource_group.example.name
  location                    = azurerm_resource_group.example.location
  log_analytics_workspace_id  = module.log_analytics.workspace_customer_id
  log_analytics_workspace_key = module.log_analytics.primary_shared_key

  containers = [{
    name   = "hello-world"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = 1
    memory = 1
  }]
}
