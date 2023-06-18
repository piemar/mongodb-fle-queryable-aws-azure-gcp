import os
connection_uri = os.environ['MONGODB_URI']

# start-kmsproviders
provider = "aws"
kms_providers = {
    provider: {
        "accessKeyId": os.environ['AWS_ACCESS_KEY_ID'],
        "secretAccessKey": os.environ['AWS_SECRET_ACCESS_KEY']
    }
}
# end-kmsproviders

# start-datakeyopts
master_key = {
    "key": os.environ['AWS_KEY_ARN'],  # "<Your AWS Key ARN>",
    "region": os.environ['AWS_REGION'] # "<Your AWS Key Region>"
}

