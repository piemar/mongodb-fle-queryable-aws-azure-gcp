#!/bin/bash
terraform init -upgrade
terraform apply -auto-approve
export AZURE_TENANT_ID=$(terraform output -raw AZURE_TENANT_ID)
export AZURE_CLIENT_ID=$(terraform output -raw AZURE_CLIENT_ID)
export AZURE_CLIENT_SECRET=$(terraform output -raw AZURE_CLIENT_SECRET)
export AZURE_KEY_NAME=$(terraform output -raw AZURE_KEY_NAME)
export AZURE_KEY_VERSION=$(terraform output -raw AZURE_KEY_VERSION)
export AZURE_KEY_VAULT_ENDPOINT=$(terraform output -raw AZURE_KEY_VAULT_ENDPOINT)
echo "AZURE_TENANT_ID=\"$AZURE_TENANT_ID\"" >> ../../python/azure/credentials.env
echo "AZURE_CLIENT_ID=\"$AZURE_CLIENT_ID\"" >> ../../python/azure/credentials.env
echo "AZURE_CLIENT_SECRET=\"$AZURE_CLIENT_SECRET\"" >> ../../python/azure/credentials.env
echo "AZURE_KEY_NAME=\"$AZURE_KEY_NAME\"" >> ../../python/azure/credentials.env
echo "AZURE_KEY_VERSION=\"$AZURE_KEY_VERSION\"" >> ../../python/azure/credentials.env
echo "AZURE_KEY_VAULT_ENDPOINT=\"$AZURE_KEY_VAULT_ENDPOINT\"" >> ../../python/azure/credentials.env


