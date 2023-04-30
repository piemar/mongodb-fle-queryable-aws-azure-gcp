# MongoDB CSFLE and Queryable Encryption with AWS KMS

__Setup of CSFLE and Queryable Encrption with AWS KMS__

__SA Maintainer__: [Pierre Petersson](mailto:pierre.petersson@mongodb.com) <br/>
__Time to setup__: 2 mins <br/>
__Time to execute__: 5 mins <br/>

To quickly get started this example project is utilising a docker image containing tooling required to test CSFLE with AWS KMS. 
If you do not want to use the docker image and set this up on your own, follow instructions https://www.mongodb.com/docs/manual/core/csfle/tutorials/aws/aws-automatic/#use-automatic-client-side-field-level-encryption-with-aws


# Prequisites 
## A running Atlas cluster 
https://www.mongodb.com/cloud/atlas/signup
## Create IAM User</br>
https://www.mongodb.com/docs/manual/core/csfle/tutorials/aws/aws-automatic/#create-an-aws-iam-user

# Encryption Terminoligy
<img src="img/envelope_encryption.png"></br>

__Customer Master Key (CMK)__, is the encryption key used to protect(encrypt) the Data Encryption Keys, which is on the top level of the encryption hierarchy.

__The Data Encryption Key (DEK)__ is used to encrypt the data that is plain text. Once plain text is encrypted by the DEK it will be in cipher text. 

__Plain text data__ is unencrypted information that you wish to protect, 


__Cipher text__ is Encrypted information unreadable by a human or computer without decryption.

__Envelope encryption__ is the practice of encrypting plain text data with a data encryption key (DEK) and then encrypting the data key using the customer master key.
# Example Application 
* A Python application that usses AWS KMS with MongoDB Driver
* Application inserts a document with where some fields are CSFLE and Queryable Encryption enabled.

# Update MongoDB connection settings and Cloud provider authentication configuration
You will only need to update the credentials.env file with you your aws credentials(or other cloud provider). 

Update the only the following fields in the file  /mongodb-fle-queryable-aws-azure-gcp/samples/aws/kms-setup/credentials.env.
```
MONGODB_CONNECTION_STRING="mongodb+srv://user:XXX@demo-cluster.tcrpd.mongodb.net/?retryWrites=true"
USER='piepet'
AWS_ACCESS_KEY_ID='XXXXXX'
AWS_SECRET_ACCESS_KEY='XXXXX'
AWS_REGION='eu-central-1'
AWS_DEFAULT_REGION="$AWS_REGION"
```

There are two fields that should not be changed, as they will be replaced once you run the configure_kms.sh.

# Start Docker Container
A prebaked docker image that has all prequisites installed such as mongodb shared library, start container in root of this repo.

```
# Start docker container - Initializing KMS Setup
docker run -it --rm  --env-file=samples/aws/kms-setup/credentials.env  -v ${PWD}:/workspace  piepet/iaac-aws-gcp-azure
# Run configuration of KMS provider, will create AWS KMS key, IAM Policy and Trust Policy
cd /workspace/samples/aws/kms-setup/
source ./configure_kms.sh
```

# Test AWS as KMS provider
Python application that inserts a document with CSFLE configured. CSFLE is configured to use AWS KMS KMS provider.

```
# Demo application that demonstrates CSFLE with AWS KMS Provider with client side schema
cd /workspace/samples/aws/appliction/python
python3.8 demo_aws_csfle_client_schema.py
``

## CSFLE Schema Stored in Database
Will create a database with name DEMO-AWS-FLE where the keyvault collection and the user collection will be created. The CSFLE schema will be stored in database, as a validation see below.
<br/>
<img src="img/fle_backend_validation.png" width="200">

```
cd /workspace/samples/aws/appliction/python
python3.8 demo_aws_csfle.py
```

You should now see the following in the DEMO-AWS-FLE.users
<br/>
<img src="img/compass_kmip_fle.png" width="200">

## Queryable Encryption
Will create a database with name DEMO-AWS-QUERYABLE where the keyvault collection and the user collection will be created.

```
cd /workspace/samples/aws/appliction/python
python3.8 demo_aws_queryable.py
```

You should now see the following in the DEMO-AWS-QUERYABLE.users
<br/>
<img src="img/compass_kmip_queryable.png" width="200">


The application will automatically encrypt/decrypt the fields defined in the validation schema thats attached to the users collection. Fields that should be shown encrypted are ssn, contact.mobile, contact.email

You should now be able to see in compass that fields that are encrypted have ****** shown as value. 

## Key rotation
Decrypt multiple Data Encryption Keys (DEK) and re-encrypts them with a new Customer Master Key (CMK). Use this method to rotate the CMK that encrypts your DEKs. 

Look at field KeyMaterial in datakeys collection for respective encryptionMode (Queryable or FLE). The KeyMaterial will be replaced with new KeyMaterial. 

Before running rotate:
<br/>
<img src="img/key_rotation_before.png" width="100%">



```
## FLE MasterKeys and DEKS
cd /workspace/samples/aws/appliction/python
python3.8 rotate_fle.py
```

```
## Queryable Encryption MasterKeys and DEKS
cd /workspace/samples/aws/appliction/python
python3.8 rotate_queryable.py 
```
After running rotate:

<img src="img/key_rotation_after.png" width="100%">

# Cleanup
If you want to rerun setup, delete vault/data folder. only the data folder. Run the following in root of this pov.
```
cd /workspace/samples/aws/kms-setup
./cleanup.sh
```

# Additional Resources

## Blog article - How to Set Up HashiCorp Vault KMIP Secrets Engine with MongoDB CSFLE or Queryable Encryption</br>
https://www.mongodb.com/developer/products/atlas/hashicorp-vault-kmip-secrets-engine-mongodb/

## Client-Side Field Level Encryption The Next Generation of Privacy & Security MDBW22 Video </br>
https://www.youtube.com/watch?v=KBMfaEzxNFk

## Whitepaper CSFLE 
https://www.mongodb.com/collateral/field-level-encryption

## CSFLE Multi Cloud Environments MDBW22 Video
https://www.youtube.com/watch?v=bfyxplG1DVg&list=PL4RCxklHWZ9tKWSS21BmtFxOs51f-l1o9&index=33&t=9s

## Queryable Encryption Resources
Docs (very much a WIP): https://www.mongodb.com/docs/upcoming/core/queryable-encryption/ </br>
Blog post: https://www.mongodb.com/blog/post/mongodb-releases-queryable-encryption-preview </br>
Product page & FAQ: https://mongodb.com/products/queryable-encryption </br>

## To build and push docker file
```
docker buildx create --name builder —use
docker buildx create --use
docker buildx build --push --platform linux/amd64,linux/arm64 --tag piepet/mongodb-kmip-vault:latest .
```

docker container run -it --rm -e CLOUD_ACCESS_KEY_ID -e CLOUD_SECRET_ACCESS_KEY -e CLOUD_DEFAULT_REGION -v ${PWD}:/workspace piepet/iaac-aws-gcp-azure