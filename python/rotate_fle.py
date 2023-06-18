import sys
from pprint import pprint
from bson.codec_options import CodecOptions
from pymongo import MongoClient
from pymongo.encryption import ClientEncryption

kms_provider_string=sys.argv[1]
def rotate():
    client = MongoClient(configuration.connection_uri)
    client_encryption = ClientEncryption(
        configuration.kms_providers,  
        configuration.key_vault_namespace,
        client,
        CodecOptions()
    )    
    client_encryption.rewrap_many_data_key({})    
    pprint("Keys rotated")


def main():
    rotate()
if __name__ == "__main__":
    if kms_provider_string == "aws":
        import aws.configuration as configuration
    if kms_provider_string == "azure":
        import azure.configuration as configuration
    main()