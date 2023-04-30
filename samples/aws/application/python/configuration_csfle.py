import os
encrypted_namespace = "DEMO-AWS-FLE.users"
key_vault_namespace = "DEMO-AWS-FLE.__keyVault"
connection_uri=os.environ.get('MONGODB_CONNECTION_STRING')
AWS_ACCESS_KEY_ID=os.environ.get('AWS_ACCESS_KEY_ID')
AWS_SECRET_ACCESS_KEY=os.environ.get('AWS_SECRET_ACCESS_KEY')
AWS_KEY_REGION=os.environ['AWS_REGION']
AWS_KEY_ARN=os.environ['AWS_KEY_ARN']

# start-kmsproviders
provider = "aws"
kms_providers = {
    provider: {
        "accessKeyId": AWS_ACCESS_KEY_ID,
        "secretAccessKey": AWS_SECRET_ACCESS_KEY
    }
}
# end-kmsproviders

# start-datakeyopts
master_key = {
    "region": AWS_KEY_REGION,
    "key": AWS_KEY_ARN,
}
