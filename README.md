# MongoDB CSFLE and Queryable Encryption with AWS KMS and Azure KeyVault
__Setup of CSFLE and Queryable Encrption with AWS KMS or Azure Keyvault__

__SA Maintainer__: [Pierre Petersson](mailto:pierre.petersson@mongodb.com) <br/>
__Time to setup__: 2 mins <br/>
__Time to execute__: 10 mins <br/>

To quickly get started this example project is utilising a docker image containing tooling required to test CSFLE and Queryable Encryption with AWS KMS or Azure KeyVault. I have automated the process of setting up KMS on AWS and Azure, using terraform, and supporting scrpts to minimized manual work.

If you do not want to use the docker image and set this up on your own, follow instructions https://www.mongodb.com/docs/manual/core/csfle/tutorials/aws/aws-automatic/#use-automatic-client-side-field-level-encryption-with-aws


# Prequisites 
## A running Atlas cluster 
https://www.mongodb.com/cloud/atlas/signup


# Overivew of steps
1. Create Cloud Credentials 
2. Update credentials.env
3. Run configure_kms.sh (automates configuration of creation of KMS Key)
4. Run Demo Application

# Example Application 
* A Python application that usses AWS KMS or Azure KeyVault with MongoDB Driver
* Application inserts a document with where some fields are CSFLE and Queryable Encryption enabled.

# Create Cloud Credentials

## AWS Create IAM User</br>
<a href="https://www.techtarget.com/searchcloudcomputing/tutorial/Step-by-step-guide-on-how-to-create-an-IAM-user-in-AWS"> Create an AWS IAM user and add create AWS ACCESS KEYS</a> for that user, the user must av Administrator rights to be able to run terraform to provision KMS keys, roles and policies. 

## Azure 
We are going to use the az login to authenticate so that we can run our terraform scripts. You will need to have a valid Azure subscription.

# Update credentials.env
You will only need to update the credentials.env file with you your aws/azure credentials(or other cloud provider). 

Update the ONLY the following fields in the file  /mongodb-fle-queryable-aws-azure-gcp/python/aws/credentials.env. DONT USE QOUTES, just = string

```
## FOR AWS
MONGODB_URI=mongodb+srv://user:password@demo-cluster.tcrpd.mongodb.net/?retryWrites=true&w=majority
AWS_ACCESS_KEY_ID=AXXXXXXXXXXXXX
AWS_SECRET_ACCESS_KEY=QhjFqDaC9EzDP8nsp1IwwXtKByvKuo28itCoK2oW
AWS_REGION=eu-central-1

## FOR Azure
MONGODB_URI=mongodb+srv://user:password@demo-cluster.tcrpd.mongodb.net/?

```

# Configure KMS
```
# Start docker container - Initializing KMS Setup
## for AWS
docker run -it --rm  --env-file=python/aws/credentials.env  -v ${PWD}:/workspace  piepet/iaac-aws-gcp-azure

## for Azure
docker run -it --rm  --env-file=python/azure/credentials.env  -v ${PWD}:/workspace  piepet/iaac-aws-gcp-azure
```

Run configuration of KMS provider, will create KMS key in AWS or Azure.
```
## For AWS
cd /workspace/kms-setup/aws
./configure_kms.sh 
export $(< /workspace/python/aws/credentials.env)

## For Azure
cd /workspace/kms-setup/azure
az login
./configure_kms.sh 
export $(< /workspace/python/azure/credentials.env)

```

# Run Demo Application
Python application that inserts a document with CSFLE configured. CSFLE is configured to use AWS or Azure KMS KMS provider.

```
# Demonstrates CSFLE with KMS Provider with client side schema.
cd /workspace/python

## For AWS
python3.8 demo_csfle_client_schema.py aws

## For Azure
python3.8 demo_csfle_client_schema.py azure

```

## CSFLE Schema Stored in Database
Will create a database with name DEMO-AWS-FLE or DEMO-AZURE-FLE where the keyvault collection and the user collection will be created. The CSFLE schema will be stored in database, as a validation see below.
<br/>
<img src="img/fle_backend_validation.png" width="200">

```
cd /workspace/python
## For AWS
python3.8 demo_csfle.py aws

## For Azure
python3.8 demo_csfle.py azure

```
You should now see the following in the DEMO-AWS-FLE.users
<br/>
<img src="img/compass_kmip_fle.png" width="200">

## Queryable Encryption
Will create a database with name DEMO-AWS-FLE or DEMO-AZURE-QUERYABLE where the keyvault collection and the user collection will be created.

```
## For AWS
cd /workspace/python
python3.8 demo_queryable.py aws

## For Azure
cd /workspace/python
python3.8 demo_queryable.py azure

```

You should now see the following in the DEMO-AWS-FLE.users DEMO-AZURE-FLE.users
<br/>
<img src="img/compass_kmip_queryable.png" width="200">


The application will automatically encrypt/decrypt the fields defined in the encryption schema thats attached to the users collection. Fields that should be shown encrypted are ssn, contact.mobile, contact.email

You should now be able to see in compass that fields that are encrypted have ****** shown as value. 

## Key rotation
Decrypt multiple Data Encryption Keys (DEK) and re-encrypts them with a new Customer Master Key (CMK). Use this method to rotate the CMK that encrypts your DEKs. 

Look at field KeyMaterial in datakeys collection for respective encryptionMode (Queryable or FLE). The KeyMaterial will be replaced with new KeyMaterial. 

Before running rotate:
<br/>
<img src="img/key_rotation_before.png" width="100%">



```
## FLE MasterKeys and DEKS
cd /workspace/python
python3.8 rotate_fle.py aws

cd /workspace/python
python3.8 rotate_fle.py azure

```

```
## Queryable Encryption MasterKeys and DEKS
cd /workspace/python
python3.8 rotate_queryable.py aws

cd /workspace/python
python3.8 rotate_queryable.py azure

```
After running rotate:

<img src="img/key_rotation_after.png" width="100%">

# Cleanup
If you want to rerun setup, delete vault/data folder. only the data folder. Run the following in root of this pov.

```
## For AWS
cd /workspace/kms-setup/aws
terraform destroy

## For Azure
cd /workspace/kms-setup/azure
terraform destroy
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
## Known issues
You will need to install in docker container, once released I will add it to docker container. 
pip install 'https://github.com/mongodb/mongo-python-driver/archive/master.tar.gz'

## To build and push docker file
The Docker container is published in DockerHub, no need to build. But if you would like to rebuild the image see below.
```
docker buildx create --name builder —use
docker buildx create --use
docker buildx build --push --platform linux/amd64,linux/arm64 --tag piepet/iaac-aws-gcp-azure .
```

# Encryption Terminoligy
<img src="img/envelope_encryption.png"></br>

__Customer Master Key (CMK)__, is the encryption key used to protect(encrypt) the Data Encryption Keys, which is on the top level of the encryption hierarchy.

__The Data Encryption Key (DEK)__ is used to encrypt the data that is plain text. Once plain text is encrypted by the DEK it will be in cipher text. 

__Plain text data__ is unencrypted information that you wish to protect, 


__Cipher text__ is Encrypted information unreadable by a human or computer without decryption.

__Envelope encryption__ is the practice of encrypting plain text data with a data encryption key (DEK) and then encrypting the data key using the customer master key.
