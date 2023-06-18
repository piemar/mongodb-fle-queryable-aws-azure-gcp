#!/bin/bash
terraform init
terraform apply -auto-approve
export AWS_KEY_ARN=$(terraform output -raw key_arn)
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_REGION=$AWS_REGION
echo "AWS_KEY_ARN=$AWS_KEY_ARN" >> ../../python/aws/credentials.env

