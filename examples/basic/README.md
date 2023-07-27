# Basic Example

Example Terraform configuration which shows the basic usage of this module.

# Terraform Configuration for Azure Container Instances (ACI) with Log Analytics Integration

This Terraform configuration provisions an Azure Container Instance (ACI) along with a Log Analytics workspace in an Azure Resource Group.

## Prerequisites

Before you begin, ensure you have the following installed on your system:

1. [Terraform](https://www.terraform.io/downloads.html) (version >= 1.3.0)
2. [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) (latest version)

You'll also need an Azure account and proper credentials set up to authenticate with Azure.

## Clone the Repository

First, clone this repository to your local machine:

```bash
git clone <repository_url>
cd <repository_name>
```

## Initialize Terraform

Navigate to the directory containing the Terraform configuration and initialize Terraform:

```bash
cd path/to/configuration_directory
terraform init
```

This will download the necessary plugins required for Terraform to work with Azure.

## Configure Azure Provider

To configure the Azure provider, you need to set up the necessary Azure credentials. If you already have the Azure CLI installed and authenticated with Azure, Terraform will use the same credentials.

If you haven't authenticated with Azure, you can do so by running:

```bash
az login
```

## Input Variables

Before you apply the Terraform configuration, you need to provide values for the required input variables. Update the `variables.tf` file with the appropriate values. For example:

```hcl
location = "West US"
```

You can modify other variables based on your requirements.

## Apply the Terraform Configuration

After configuring the input variables, you can apply the Terraform configuration to create the Azure resources:

```bash
terraform apply
```

Terraform will show you the changes that will be applied to the infrastructure. Type `yes` to confirm and apply the changes.

## Terraform Modules

### Log Analytics Module

This configuration uses the `azurerm-log-analytics` module to create a Log Analytics workspace in the specified Azure Resource Group. The module is sourced from a Git repository.

### Azure Container Instances (ACI) Module

This configuration uses the `Azure_ACI` module to create an Azure Container Instance with a single container running the "hello-world" image. The module is sourced from the local directory where this Terraform configuration is located.

## Outputs

After applying the Terraform configuration, you will see the following outputs:

- `container_group_id`: The ID of the created Azure Container Group.
- `identity_principal_id`: The principal ID of the system-assigned identity of the Azure Container Group.
- `identity_tenant_id`: The tenant ID of the system-assigned identity of the Azure Container Group.
- `ip_address`: The IP address of the Azure Container Group.

## Clean Up

To clean up the resources created by Terraform, you can use the `destroy` command:

```bash
terraform destroy
```

Terraform will show you the resources that will be destroyed. Type `yes` to confirm and destroy the resources.

## Conclusion

You have successfully provisioned an Azure Container Instance with Log Analytics integration using Terraform. Feel free to explore other features and configurations provided by the modules as per your requirements.

For more information on Terraform commands and usage, refer to the [Terraform documentation](https://www.terraform.io/docs/cli/commands/index.html). For information on the Azure Container Instance resource and its properties, refer to the [Azure provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_group). For information on the Log Analytics workspace resource and its properties, refer to the [azurerm_log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) resource documentation.