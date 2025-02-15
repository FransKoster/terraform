#!/bin/bash

# Variables
# source ../test/environment.sh
source ./test-environment.sh

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
  echo "Azure CLI not found. Please install it and try again."
  exit 1
fi

# Check if already logged in to Azure
if ! az account show &> /dev/null; then
  echo "Not logged into Azure. Logging in..."
  az login --service-principal \
    --username "$SERVICE_PRINCIPAL_APP_ID" \
    --password "$SERVICE_PRINCIPAL_PASSWORD" \
    --tenant "$TENANT_ID"
else
  echo "Already logged into Azure."
fi

# Set Azure Subscription
echo "Set subscription to: $SUBSCRIPTION_ID"
az account set --subscription "$SUBSCRIPTION_ID"

# Create Resource Group
echo "Create resource group: $RESOURCE_GROUP"
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create Storage Account
echo "Create storage account: $STORAGE_ACCOUNT"
az storage account create --name $STORAGE_ACCOUNT --resource-group $RESOURCE_GROUP --location $LOCATION --sku Standard_LRS --kind StorageV2

# Create Storage Container
echo "Create storage container: $CONTAINER_NAME"
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT --auth-mode login

echo "Container URL: https://$STORAGE_ACCOUNT.blob.core.windows.net/$CONTAINER_NAME"

