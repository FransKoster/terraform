# Setup
The idea is to create multiple **Azure subscriptions** for different environments (development, test, acceptance and production). 
## Storing the terrafrom state
The idea is to separate the terraform state for different environments to avoid any conflict and to maintain logical isolation. The states are configured using different **backend** configurations for each environment. This is done using **Azure Storage Accounts** to store the state files in different containers.

## Configure Backend for each environment
For each environment we specify a different backend configuration. Below, we will define the backend configuration for two environments: `development` and `production`. In this case we use a single storage account with separate containers for production and development.

#### Example Backend Configuration for `development`:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name   = "terraform-backend-rg"
    storage_account_name  = "tfstate"
    container_name        = "development-state"
    key                   = "dev/terraform.tfstate"  # File path for development state file
  }
}
```

#### Example Backend Configuration for `production`:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name   = "terraform-backend-rg"
    storage_account_name  = "tfstate"
    container_name        = "production-state"
    key                   = "prod/terraform.tfstate"  # File path for production state file
  }
}
```

## Create Azure storage account per subscription
In this example we use seperate storage accounts for differtent subsriptions.
Prerequisite:
- Subscriptions exist
- User or ServicePrincipal with sufficient rights on Azure

### Directory Structure
The project directory structure:

```
azure/
├── development/
│   ├── main.tf                       # Dev environment Terraform code
│   ├── resource_groups.tf            # Create resource groups
│   ├── resource_groups_locals.tf     # Locals for creating rg
│   ├── variables.tf                  # variables
│   ├── terraform.tfvars        # local variables, not in the repo
│   └── providers.tf            # Dev backend configuration
├── test/
│   ├── main.tf                       # Test environment Terraform code
│   ├── resource_groups.tf            # Create resource groups
│   ├── resource_groups_locals.tf     # Locals for creating rg
│   ├── variables.tf                  # variables
│   ├── terraform.tfvars        # local variables, not in the repo
│   └── providers.tf            # test backend configuration
├── acceptance/
│   ├── ...
│   └── providers.tf            # Dev backend configuration
├── production/
│   ├── ...
│   └── providers.tf            # Dev backend configuration
└── scripts/
    ├── create_storage.sh       # create storageaccount
    ├── 
    ├── development_env.sh      # Environment variables to source
    ├── test_env.sh
    ├── acceptance_env.sh
    └── production_env.sh

```
### Example of `test_env.sh`
This file is sourced by the scripts.
```
export RESOURCE_GROUP="tfstorage"
export LOCATION="westeurope"
export STORAGE_ACCOUNT="storagetf1234"  # unique name
export CONTAINER_NAME="tfstate"
export SERVICE_PRINCIPAL_APP_ID="<app_id>"
export SERVICE_PRINCIPAL_PASSWORD="<app_secret>"
export TENANT_ID="<tenant_id>"
export SUBSCRIPTION_ID="<subscrition_id>"
```

### Create ServicePrincipal
Create the ServicePrinciple that authenticates Terraform to Azure. We do this using the command line.
`create_sp.sh`

```bash
# Variables
source ./test_env.sh

...

az ad sp create-for-rbac --name $SERVICE_PRINCIPAL_NAME --role Contributor --scopes /subscriptions/$SUBSCRIPTION_ID

```
Take note of the app_id and app_secret and add these to the `_env.sh`