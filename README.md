# Azure_ACI

# Terraform Module: azurerm_container_group

This Terraform module simplifies the creation of an Azure Container Group. An Azure Container Group is a group of one or more containers that share the same network and storage resources and are scheduled together on the same host.

## Prerequisites

Before using this Terraform module, ensure that you have the following prerequisites:

1. **Azure Account**: You need an active Azure account to deploy the resources.
2. **Terraform**: Install Terraform on your local machine. You can download it from the [official Terraform website](https://www.terraform.io/downloads.html).
3. **Azure CLI**: Install the Azure CLI on your local machine. You can download it from the [Azure CLI website](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).

## Features

- Easy deployment of container groups with multiple containers using a flexible configuration.
- Support for defining CPU and memory resources for each container.
- Configuration of environment variables and secure environment variables for containers.
- Definition of container ports and protocols for easy networking setup.
- Option to mount volumes and secrets inside containers for persistent data storage.
- Integrated diagnostics using Log Analytics to monitor container group performance.

## Usage

```hcl
module "container_group" {
  source         = "path/to/azurerm_container_group"
  container_group_name        = "my-container-group"
  resource_group_name         = "my-resource-group"
  location                    = "East US"
  log_analytics_workspace_id   = "my-log-analytics-workspace-id"
  log_analytics_workspace_key  = "my-log-analytics-workspace-key"

  # Define containers for the container group
  containers = [
    {
      name   = "my-container-1"
      image  = "my-container-image-1:latest"
      cpu    = "0.5"
      memory = "1.5Gi"
      ports = [
        {
          port     = 80
          protocol = "TCP"
        },
        {
          port     = 443
          protocol = "TCP"
        }
      ]
      environment_variables = {
        "ENV_VAR_1" = "value1"
        "ENV_VAR_2" = "value2"
      }
      secure_environment_variables = {
        "SECURE_VAR_1" = "secure_value1"
        "SECURE_VAR_2" = "secure_value2"
      }
      volumes = [
        {
          name       = "my-volume-1"
          mount_path = "/mnt/data"
        }
      ]
    },
    {
      name   = "my-container-2"
      image  = "my-container-image-2:latest"
      cpu    = "1"
      memory = "2Gi"
      ports = [
        {
          port     = 8080
          protocol = "TCP"
        }
      ]
      environment_variables = {
        "ENV_VAR_3" = "value3"
      }
    }
  ]
}
```

## Input Variables

- `container_group_name`: (Required) The name of the Azure Container Group.
- `resource_group_name`: (Required) The name of the resource group to create the resources in.
- `location`: (Required) The location to create the resources in.
- `log_analytics_workspace_id`: (Required) The workspace (customer) ID of the Log Analytics workspace to send diagnostics to.
- `log_analytics_workspace_key`: (Required) The shared key of the Log Analytics workspace to send diagnostics to.

For more details on other input variables and their usage, refer to the variables section in the module's source code.

## Output Variables

- `container_group_id`: The ID of the created Container Group.
- `identity_principal_id`: The principal ID of the system-assigned identity of this Container Group (if enabled).
- `identity_tenant_id`: The tenant ID of the system-assigned identity of this Container Group (if enabled).
- `ip_address`: The IP address of the Container Group.