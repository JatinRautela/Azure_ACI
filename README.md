# Terraform Module: azurerm_container_group

This Terraform module simplifies the creation of an Azure Container Group. An Azure Container Group is a group of one or more containers that share the same network and storage resources and are scheduled together on the same host.

## Prerequisites

Before using this Terraform module, ensure that you have the following prerequisites:

1. **Azure Account**: You need an active Azure account to deploy the resources.
2. **Terraform**: Install Terraform on your local machine. You can download it from the [official Terraform website](https://www.terraform.io/downloads.html).
3. **Azure CLI**: Install the Azure CLI on your local machine. You can download it from the [Azure CLI website](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).

- Terraform version >= 1.3.0 is required.
- Azure provider version >= 3.16.0 is required.


## Features

- Easy deployment of container groups with multiple containers using a flexible configuration.
- Support for defining CPU and memory resources for each container.
- Configuration of environment variables and secure environment variables for containers.
- Definition of container ports and protocols for easy networking setup.
- Option to mount volumes and secrets inside containers for persistent data storage.
- Integrated diagnostics using Log Analytics to monitor container group performance.

## Getting Started with Azure Container Group Terraform Module

This repository contains a Terraform module to provision an Azure Container Group with one or more containers in an Azure Resource Group.

### Configure Azure Provider

To configure the Azure provider, you need to set up the necessary Azure credentials. If you already have the Azure CLI installed and authenticated with Azure, Terraform will use the same credentials.

If you haven't authenticated with Azure, you can do so by running:

```bash
az login
```

### Clone the Repository

First, clone this repository to your local machine using the following command:

```bash
git clone <repository_url>
cd <repository_name>
```

### Initialize Terraform

Once you have cloned the repository, navigate to the module directory and initialize Terraform:

```bash
cd path/to/module_directory
terraform init
```

This will download the necessary plugins required for Terraform to work with Azure.

### Apply the Terraform Configuration

After configuring the input variables, you can apply the Terraform configuration to create the Azure Container Group:

```bash
terraform apply
```

Terraform will show you the changes that will be applied to the infrastructure. Type `yes` to confirm and apply the changes.

### Clean Up

To clean up the resources created by Terraform, you can use the `destroy` command:

```bash
terraform destroy
```

Terraform will show you the resources that will be destroyed. Type `yes` to confirm and destroy the resources.

## Usage

```hcl
module "container_group" {
  source              = "path/to/azure-container-group"
  container_group_name = "my-container-group"
  resource_group_name = "my-resource-group"
  location            = "West US"

  containers = [
    {
      name   = "container-1"
      image  = "nginx:latest"
      cpu    = "1.0"
      memory = "1.5"

      ports = [
        {
          port     = 80
          protocol = "TCP"
        }
      ]

      environment_variables = {
        ENV_VAR1 = "value1"
        ENV_VAR2 = "value2"
      }

      volumes = [
        {
          name       = "vol-1"
          mount_path = "/data"
          secret     = {
            secret_key = "secret-value"
          }
        }
      ]
    },
    // Add more containers if needed
  ]

  dns_config = {
    nameservers = ["8.8.8.8", "8.8.4.4"]
  }

  image_registry_credentials = [
    {
      server   = "myregistry.azurecr.io"
      username = "myusername"
      password = "mypassword"
    }
  ]

  identity = {
    type         = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
    Team        = "DevOps"
  }

  log_analytics_workspace_id  = "my-log-analytics-ws-id"
  log_analytics_workspace_key = "my-log-analytics-ws-key"
}

```

## Inputs

| Name                        | Description                                      | Type             | Default          |
| --------------------------- | ------------------------------------------------ | ---------------- | -----------------|
| `container_group_name`      | The name of this Container Group.               | string           | Required         |
| `resource_group_name`       | The name of the resource group to create the resources in. | string           | Required         |
| `location`                  | The location to create the resources in.        | string           | Required         |
| `containers`                | A list of containers to create for this Container Group. | list(object)     | Required         |
| `os_type`                   | The OS type of this Container Group.            | string           | "Linux"          |
| `restart_policy`            | The restart policy of this Container Group.     | string           | "Always"         |
| `ip_address_type`           | The IP address type of this Container Group.    | string           | "None"           |
| `dns_name_label`            | A DNS name label for this Container Group.      | string           | null             |
| `dns_name_label_reuse_policy` | The reuse policy to use for the DNS name label. | string           | null             |
| `subnet_ids`                | A list of subnet IDs to be assigned to this Container Group. | list(string)  | null             |
| `dns_config`                | The DNS configuration of this Container Group.  | object({ nameservers = list(string) }) | null |
| `image_registry_credentials` | A list of image registry credentials to configure for this Container Group. | list(object) | [] |
| `identity`                  | The identity or identities to configure for this Container Group. | object({ type = string, identity_ids = list(string) }) | null |
| `tags`                      | A map of tags to assign to the resources.       | map(string)      | {}               |
| `log_analytics_workspace_id` | The workspace (customer) ID of the Log Analytics workspace to send diagnostics to. | string | null |
| `log_analytics_workspace_key`| The shared key of the Log Analytics workspace to send diagnostics to.            | string | null |

## Outputs

| Name                        | Description                                      | Type             |
| --------------------------- | ------------------------------------------------ | ---------------- |
| `container_group_id`        | The ID of this Container Group.                 | string           |
| `identity_principal_id`     | The principal ID of the system-assigned identity of this Container Instance. | string |
| `identity_tenant_id`        | The tenant ID of the system-assigned identity of this Container Instance.    | string |
| `ip_address`                | The IP address of this Container Instance.      | string           |

## Note

- The Terraform configuration may contain sensitive information like passwords or keys. Make sure to handle these securely using Terraform workspaces, environment variables, or other secure methods.

- This module assumes that the required Azure provider is already configured in the Terraform configuration and has the correct credentials to authenticate with Azure.

- Refer to the official Terraform documentation for more details on using modules and configuring Azure resources with Terraform.

- For more information on the Azure Container Group resource, refer to the Azure provider documentation.

## List of variables

| Variable Name                     | Description                                                    | Type       | Required | Default Value       |
|-----------------------------------|----------------------------------------------------------------|------------|----------|---------------------|
| `container_group_name`            | The name of this Container Group.                             | `string`   | Yes      | `"my-container-group"` |
| `resource_group_name`             | The name of the resource group to create the resources in.   | `string`   | Yes      | `"my-resource-group"` |
| `location`                        | The location to create the resources in.                     | `string`   | Yes      | `"northeurope"`       |
| `containers`                      | A list of containers to create for this Container Group.     | `list`     | No       | `[]`                  |
| `os_type`                         | The OS type of this Container Group.                         | `string`   | No       | `"Linux"`             |
| `restart_policy`                  | The restart policy of this Container Group.                  | `string`   | No       | `"Always"`            |
| `ip_address_type`                 | The IP address type of this Container Group.                 | `string`   | No       | `"None"`              |
| `dns_name_label`                  | A DNS name label for this Container Group.                   | `string`   | No       | `null`                |
| `dns_name_label_reuse_policy`     | The reuse policy to use for the DNS name label.              | `string`   | No       | `null`                |
| `subnet_ids`                      | A list of subnet IDs to be assigned to this Container Group.| `list`     | No       | `null`                |
| `dns_config`                      | The DNS configuration of this Container Group.               | `object`   | No       | `null`                |
| `image_registry_credentials`      | A list of image registry credentials to configure.           | `list`     | No       | `[]`                  |
| `identity`                        | The identity or identities to configure for this Container Group. | `object` | No       | `null`                |
| `tags`                            | A map of tags to assign to the resources.                    | `map`      | No       | `{}`                  |
| `name`                            | A string value to describe the prefix of all the resources.   | `string`   | No       | `""`                  |
| `default_tags`                    | A map to add common tags to all the resources.               | `map`      | No       | See below             |
| `common_tags`                     | A map to add common tags to all the resources.               | `map`      | No       | `{}`                  |

Default value for `default_tags`:
```hcl
{
  "Scope": "ACI",
  "CreatedBy": "Terraform"
}
```

Please note that the variables in the "Required" column that are marked "No" can be left empty if you don't want to provide a value for them.