import os
connection_uri = os.environ['MONGODB_URI']
encrypted_namespace = "DEMO-AZURE-FLE.users"
key_vault_namespace = "DEMO-AZURE-FLE.__keyVault"

# start-kmsproviders
provider = "gcp"
kms_providers = {
    provider: {
        "email": os.environ['GCP_EMAIL'],
        "privateKey": os.environ['GCP_PRIVATE_KEY']
    }
}
# end-kmsproviders

# start-datakeyopts
master_key = {
           "projectId": os.environ['GCP_PROJECT_ID'],  
           "location": os.environ['GCP_LOCATION'],  # "<GCP private key>",
           "keyRing": os.environ['GCP_KEY_RING'],  # "<GCP private key>",
           "keyName": os.environ['GCP_KEY_NAME']  # "<GCP private key>",
}

