import os
connection_uri = os.environ['MONGODB_URI']
encrypted_namespace = "DEMO-AZURE-FLE.users"
key_vault_namespace = "DEMO-AZURE-FLE.__keyVault"

# start-kmsproviders
provider = "azure"
kms_providers = {
    provider: {
        "tenantId": os.environ['AZURE_TENANT_ID'],
        "clientId": os.environ['AZURE_CLIENT_ID'],
        "clientSecret": os.environ['AZURE_CLIENT_SECRET']
    }
}
# end-kmsproviders

# start-master-key
master_key = {
    "keyName": os.environ['AZURE_KEY_NAME'], # "<Your Azure key name>",
    "keyVaultEndpoint": os.environ['AZURE_KEY_VAULT_ENDPOINT'] # "<Your Azure key vault endpoint>"
}

