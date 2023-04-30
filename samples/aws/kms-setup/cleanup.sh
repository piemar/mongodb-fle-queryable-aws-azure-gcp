#!/bin/bash
export $(grep -v '^#' final_configure_credentials.env | xargs)

aws iam delete-role-policy --role-name "csfle-aws-kms-${USER}" --policy-name "csfle-aws-kms-policy-${USER}"
aws iam delete-role --role-name "csfle-aws-kms-${USER}"

export AWS_KEY_ARN=$(jq -r .KeyMetadata.Arn < output_kms.json)
export AWS_ACCOUNT_ID=$(jq -r .KeyMetadata.AWSAccountId < output_kms.json)

aws kms schedule-key-deletion --key-id "${AWS_KEY_ARN}" --pending-window-in-days 7
rm output_*.json    
rm output_*.env              
rm final_configure_credentials.env