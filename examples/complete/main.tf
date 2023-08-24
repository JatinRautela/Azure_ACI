provider "azurerm" {
  features {}
}

locals {
  env         = var.env
  name        = var.pname
  name_prefix = "${local.env}${local.name}"
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.name_prefix}-rg"
  location = var.location
}

module "log_analytics" {
  source = "git::https://github.com/tothenew/terraform-azure-loganalytics.git"

  workspace_name      = "${local.name_prefix}-log"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

module "acr" {
  source = "git::https://github.com/tothenew/terraform-azure-acr.git"

  registry_name              = "${local.name_prefix}cr"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  log_analytics_workspace_id = module.log_analytics.workspace_id
  admin_enabled              = true
}

module "storage" {
  source = "git::https://github.com/tothenew/terraform-azure-storageaccount.git"

  account_name                 = "${local.name_prefix}st"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  log_analytics_workspace_id   = module.log_analytics.workspace_id
  shared_access_key_enabled    = true
  network_rules_default_action = "Allow"
}

resource "azurerm_storage_share" "storage_share" {
  name                 = "tools"
  storage_account_name = module.storage.account_name
  quota                = 5
}

module "aci" {
  #source = "git::https://github.com/tothenew/terraform-azure-container-instances.git"
  source = "../.."

  container_group_name        = "${local.name_prefix}-ci"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  log_analytics_workspace_id  = module.log_analytics.workspace_customer_id
  log_analytics_workspace_key = module.log_analytics.primary_shared_key
  os_type                     = "Linux"
  restart_policy              = "Always"

  ip_address_type             = "None"
  dns_name_label              = null
  dns_name_label_reuse_policy = null
  subnet_ids                  = null

  containers = [
    {
      name   = "hello-world"
      image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
      cpu    = 1
      memory = 1

      ports = [{
        port     = 8080
        protocol = "TCP"
      }]

      environment_variables = {
        "MY_VARIABLE" = "value"
      }

      secure_environment_variables = {
        "SECURE_VARIABLE" = "secure_value"
      }

      volumes = [
        {
          name       = "tools-volume"
          mount_path = "/aci/tools"

          storage_account_name = module.storage.account_name
          storage_account_key  = module.storage.primary_access_key
          share_name           = azurerm_storage_share.storage_share.name
        },
        {
          name       = "secret-volume"
          mount_path = "/aci/secrets"

          secret = {
            "secret.txt" = base64encode("supersecretvalue")
          }
        }
      ]
    }
  ]

  dns_config = null # Only supported when "ip_address_type" is "Private"

  image_registry_credentials = [{
    server   = module.acr.registry_login_server
    username = module.acr.registry_admin_username
    password = module.acr.registry_admin_password
  }]

  identity = {
    type         = "SystemAssigned"
    identity_ids = []
  }
}
