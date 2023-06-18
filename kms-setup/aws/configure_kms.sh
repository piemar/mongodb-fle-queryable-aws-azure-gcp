#!/bin/bash
terraform init
terraform apply -auto-approve
export AWS_KEY_ARN=$(terraform output -raw key_arn)
echo "AWS_KEY_ARN=$AWS_KEY_ARN" >> ../../credentials.env

