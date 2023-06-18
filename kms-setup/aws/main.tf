terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.4.0"
    }
  }
}

provider "aws" {
  region = var.region
}
data "aws_caller_identity" "current" {}
resource "aws_kms_key" "my_kms_key" {
  description = "csfle and queryable encryption kms key"
}

resource "aws_iam_role" "fle_role" {
  name = "csfle-aws-kms-${var.suffix}"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS =  "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}
resource "aws_iam_role_policy" "kms_policy" {
  name = "fle-kms-policy"
  role = aws_iam_role.fle_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:DescribeKey"
        ]
        Effect   = "Allow"
        Resource = aws_kms_key.my_kms_key.arn
      }
    ]
  })
}


output "key_id" {
  value = aws_kms_key.my_kms_key.key_id
}

output "key_arn" {
  value = aws_kms_key.my_kms_key.arn
}