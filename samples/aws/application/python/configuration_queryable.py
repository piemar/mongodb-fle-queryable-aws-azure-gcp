encrypted_namespace = "DEMO-AWS-QUERYABLE.users"
key_vault_namespace = "DEMO-AWS-QUERYABLE.__keyVault"
connection_uri = "mongodb+srv://<USER>:<PASSWORD>@<URL>/?retryWrites=true"
AWS_ACCESS_KEY_ID = "<AWS_ACCESS_ID>"
AWS_SECRET_ACCESS_KEY="<AWS_SECRET_ACCESS_KEY>"
AWS_KEY_REGION="eu-central-1"
AWS_KEY_ARN="<AWS_KMS_KEY_ARN>"
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
