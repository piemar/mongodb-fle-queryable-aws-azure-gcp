#!/bin/bash
. ./credentials.env

aws kms --region $AWS_REGION create-key > output_kms.json

AWS_KEY_ARN_LOCAL=$(jq -r '.KeyMetadata.Arn' output_kms.json)
AWS_ACCOUNT_ID_LOCAL=$(jq -r '.KeyMetadata.AWSAccountId'  output_kms.json)

sed  "s|<KMS_ARN>|$AWS_KEY_ARN_LOCAL|g"  "template_kms-role-policy.json"  > output_kms-role-policy.json
sed  "s|<ACCOUNTID>|$AWS_ACCOUNT_ID_LOCAL|g"  "template_role-trust-policy.json"  > output_role-trust-policy.json

sed  "s|<KMS_ARN>|$AWS_KEY_ARN_LOCAL|g"  "credentials.env"  > output_configure_credentials.env
sed  "s|<ACCOUNTID>|$AWS_ACCOUNT_ID_LOCAL|g"  "output_configure_credentials.env"  > final_configure_credentials.env
export $(grep -v '^#' final_configure_credentials.env | xargs)

aws iam create-role --role-name "csfle-aws-kms-${USER}" --assume-role-policy-document file://output_role-trust-policy.json
aws iam put-role-policy --role-name "csfle-aws-kms-${USER}" --policy-name "csfle-aws-kms-policy-${USER}" --policy-document file://output_kms-role-policy.json
export $(grep -v '^#' final_configure_credentials.env | xargs)