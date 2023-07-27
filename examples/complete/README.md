# Complete Example

Example Terraform configuration which shows the complete usage of this module.


# Terraform Example: Configurations for "example1" Module

This Terraform example demonstrates the configuration for creating various Azure resources using the "ACI" module. The module sets up an environment with multiple components, including a Resource Group, Log Analytics Workspace, Azure Container Registry (ACR), Azure Storage Account, Azure Storage Share, and Azure Container Instances (ACI).

## Prerequisites

- Terraform version >= 1.3.0
- Azure Provider version >= 3.16.0

## Usage

1. Clone the "example1" module from the GitHub repository:

   ```bash
    git clone <repository_url>
   ```

2. Change to the "example1" directory:

   ```bash
    cd <repository_name>
   ```

3. Update the `variables.tf` file with the required variables, such as `location` for the Azure region where the resources will be created.

4. Initialize Terraform and download the required providers:

   ```bash
   terraform init
   ```

5. Review the planned changes:

   ```bash
   terraform plan
   ```

6. Apply the changes to create the Azure resources:

   ```bash
   terraform apply
   ```

7. When no longer needed, destroy the created resources:

   ```bash
   terraform destroy
   ```

## Variables

- `location`: The Azure region where the resources will be created.

## Outputs

- `container_group_id`: The ID of the created Container Instance.
- `identity_principal_id`: The principal ID of the system-assigned identity of the Container Instance.
- `identity_tenant_id`: The tenant ID of the system-assigned identity of the Container Instance.
- `ip_address`: The IP address of the Container Instance.

## Modules

1. `module.log_analytics`: Sets up an Azure Log Analytics Workspace to store diagnostics logs.
2. `module.acr`: Creates an Azure Container Registry (ACR) to store container images.
3. `module.storage`: Creates an Azure Storage Account with a Share to be used by the Container Instance.
4. `module.aci`: Deploys an Azure Container Instance (ACI) with specified containers and configurations.

## Terraform Provider Version

- `azurerm`: >= 3.16.0

Please ensure you have the required versions of Terraform and the Azure Provider installed before using this example.
