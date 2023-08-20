# Public IP address example

Example Terraform configuration which shows how to create an ACI container group with a public IP address.

# Terraform Example: Configurations for "ACI" Module with Public IP Address

This Terraform example demonstrates the configuration for creating an environment with a public IP address using the "ACI" module. The module sets up an Azure Resource Group, a Log Analytics Workspace, and an Azure Container Instance (ACI) with a public IP address assigned.

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
   cd <repository_url>
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

## Variables

- `location`: The Azure region where the resources will be created.

## Outputs

The module does not provide any outputs. You can check the Azure Portal for the created Azure Container Instance with the assigned public IP address.

## Modules

1. `module.log_analytics`: Sets up an Azure Log Analytics Workspace to store diagnostics logs.
2. `module.aci`: Deploys an Azure Container Instance (ACI) with specified containers and configurations, including a public IP address.

## Terraform Provider Version

- `azurerm`: >= 3.16.0

Please ensure you have the required versions of Terraform and the Azure Provider installed before using this example.

---