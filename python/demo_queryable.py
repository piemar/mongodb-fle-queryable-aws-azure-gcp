"""
Automatically encrypt and decrypt a field with a KMIP KMS provider.
"""
import sys
from pprint import pprint
from bson.codec_options import CodecOptions
from pymongo import MongoClient
from pymongo.encryption import ClientEncryption
from pymongo.encryption_options import AutoEncryptionOpts
kms_provider_string=sys.argv[1]

def configure_queryable_session():
    auto_encryption_options = AutoEncryptionOpts(
        configuration.kms_providers,
        configuration.key_vault_namespace
        #crypt_shared_lib_path=os.environ['CRYPT_SHARED_LIB']
    )

    # start-create-client
    encrypted_client = MongoClient(
        configuration.connection_uri, auto_encryption_opts=auto_encryption_options)
    # end-create-client
        
    return encrypted_client

def create_schema():
    # We are creating a encrypted_fields_map that has an validation schema attached, 
    # that uses the encrypt attribute to define which fields should be encrypted.
    encrypted_fields_map = {
            "fields": [
                {
                    "path": "contact.email",
                    "bsonType": "string",
                    "queries": {"queryType": "equality"},
                },
                {
                    "path": "contact.mobile",
                    "bsonType": "string",
                    "queries": {"queryType": "equality"},
                },
                {
                    "path": "ssn",
                    "bsonType": "string",
                    "queries": {"queryType": "equality"},
                }
            ],
        }
    return encrypted_fields_map
def create_encrypted_collection(encrypted_client, provider_config, encrypted_fields_map):
    client_encryption = ClientEncryption(
            kms_providers=provider_config["kms_providers"],
            key_vault_namespace=configuration.key_vault_namespace,
            key_vault_client=encrypted_client,
            codec_options=CodecOptions()
        )
    db_name, coll_name = configuration.encrypted_namespace.split(".", 1)
    client_encryption.create_encrypted_collection(
        encrypted_client[db_name],
        coll_name,
        encrypted_fields_map,
        configuration.provider,
        configuration.master_key,
    )
    
def reset():    
    db_name, coll_name = configuration.encrypted_namespace.split(".", 1)
    mongo_client = MongoClient(configuration.connection_uri)
    
    mongo_client.drop_database(db_name)
    db_name_keyvault, coll_name_keyvault = configuration.key_vault_namespace.split(".", 1)
    mongo_client.drop_database(db_name_keyvault)
    
def create_user(encrypted_client):
    db_name, coll_name = configuration.encrypted_namespace.split(".", 1)
    db=encrypted_client[db_name]
    
    # Insert encrypted record
    coll = encrypted_client[db_name][coll_name]
    coll.insert_one({
        "firstName": 'Alan',
        "lastName":  'Turing',
        "ssn":       '901-01-0001',
        "address": {
            "street": '123 Main',
            "city": 'Omaha',
            "zip": '90210'
        },
        "contact": {
            "mobile": '202-555-1212',
            "email":  'alan@example.com'
        }
    })
    print("Queryable Encryption: Decrypted document:")
    print("===================")    
    pprint((coll.find_one({"ssn":"901-01-0001"})))
    unencrypted_coll = MongoClient(configuration.connection_uri)[db_name][coll_name]
    print("Queryable Encryption: Encrypted document:")
    print("===================")    

    pprint((unencrypted_coll.find_one()))

def configure_provider():
    return {"kms_providers":configuration.kms_providers}

def main():
    reset()
    #1,2 Configure your KMIP Provider and Certificates
    kms_provider_config = configure_provider()
    #4 Create Schema for Queryable Encryption, will be stored in database
    encrypted_fields_map = create_schema()
    #5 Configure Encrypted Client
    encrypted_client = configure_queryable_session()
    create_encrypted_collection(encrypted_client,kms_provider_config,encrypted_fields_map)
    #6 Run Query
    create_user(encrypted_client)
if __name__ == "__main__":
    if kms_provider_string == "aws":
        import aws.configuration as configuration
    if kms_provider_string == "azure":
        import azure.configuration as configuration
    main()