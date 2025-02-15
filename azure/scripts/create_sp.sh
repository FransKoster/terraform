#!/bin/bash

# Variables
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

az ad sp create-for-rbac --name $SERVICE_PRINCIPAL_NAME --role Contributor --scopes /subscriptions/$SUBSCRIPTION_ID
