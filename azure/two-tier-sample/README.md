Terraform Templates to Deploy Infrastructure onto Azure
-------------------------------------------------------

PreRequisites:
-------------
 - Please see the section below pertaining to Credentials and Authentication

Code Organization:
-----------------
  two-tier-sample/
      - az_two_tier.tf: Contains the definition of the various artifacts that will be deployed on Azure.
      - fw_vars.tf: Define the various variables that will be required as inputs to the Terraform template.
      - terraform.tfvars: Defines default values for all the variables.

  Note: The fw_vars.tf has default values provided for certain variables. These can obviously be overridden by
        specifying those variables and values in the terraform.tfvars file.

Credentials and Authentication:
------------------------------

  - An Azure Service Principal, with the proper role and permissions needs to be created prior to deploying
    workloads into Azure using terraform.
    See: https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-authenticate-service-principal-cli
  - Once the service principal has been created on Azure, create a file called "azure_provider.tf" (file name could be anything
    but should end with .tf) with the following fields (pertaining to the service principal):

      - provider "azurerm" {
            subscription_id = "<subscription_id>"
            client_id = "<client_id>"
            client_secret = "<secret used while creating the application>"
            tenant_id = "<tenant_id>"
        }

Usage:
------

   run terraform: ```terraform apply```
